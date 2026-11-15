import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../amount_text.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/secure_store.dart';
import '../../peru_date.dart';
import '../../src/rust/api/document.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/sunat.dart';
import 'document_repository.dart';
import 'document_status.dart';
import 'document_totals.dart';
import 'draft_problem.dart';
import 'invoice_draft.dart';
import 'sunat_answer.dart';
import 'sunat_bridge.dart';
import 'voiding.dart';

/// The company has no certificate and isn't in test mode
class MissingCertificateError implements Exception {
  const MissingCertificateError();
}

/// SUNAT's public demo certificate, used in test mode without a certificate
Future<Uint8List> loadDemoCertificate() async =>
    (await rootBundle.load('assets/demo/certificado_demo.pfx')).buffer
        .asUint8List();

/// Issues documents and sends them to SUNAT (docs/DESIGN.md §5)
class DocumentService {
  DocumentService(
    this._db,
    this._documents,
    this._secureStore,
    this._bridge, {
    Future<Uint8List> Function() demoCertificate = loadDemoCertificate,
    this.pauseBetweenSends = const Duration(seconds: 3),
  }) : _loadDemoCertificate = demoCertificate;

  /// SUNAT answers HTTP 401 to requests sent right after another
  final Duration pauseBetweenSends;

  /// When SUNAT was last called, to keep [pauseBetweenSends]
  DateTime? _lastRequestAt;

  final AppDatabase _db;
  final DocumentRepository _documents;
  final SecureStore _secureStore;
  final SunatBridge _bridge;
  final Future<Uint8List> Function() _loadDemoCertificate;

  /// The last send; sends run one at a time (outbox, manual retries)
  Future<void>? _sending;

  /// The outbox round in progress, if any
  Future<void>? _outbox;

  /// Waits between sends that got no answer: 1, 5, 15 minutes, then hourly
  static const retryDelays = [
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(hours: 1),
  ];

  /// How often a ticket is checked
  static const ticketCheckDelay = Duration(minutes: 2);

  /// Statuses a send can change: waiting ones, and those the user fixes
  static const sendable = {
    DocumentStatus.pendingSend,
    DocumentStatus.inProgress,
    DocumentStatus.exception,
    DocumentStatus.unknown,
  };

  /// What xbuilder fills in documents issued on [fechaEmision]
  static DocumentDefaults _defaults(String fechaEmision) => DocumentDefaults(
    igvTasa: TaxRates.igv,
    icbTasa: TaxRates.icb,
    ivapTasa: TaxRates.ivap,
    fechaEmision: fechaEmision,
  );

  /// The amounts [draft] would have, without issuing it
  Future<DocumentTotals> preview({
    required Company company,
    required Serie serie,
    required DocumentDraft draft,
  }) async {
    final fechaEmision = peruToday();
    final built = await _bridge.build(
      draft.toDocumentJson(
        company: company,
        serieNumero: '${serie.serie}-${serie.nextNumber}',
        fechaEmision: fechaEmision,
      ),
      _defaults(fechaEmision),
    );
    final json = jsonDecode(built.enrichedJson) as Map<String, dynamic>;
    return DocumentTotals(json['spec'] as Map<String, dynamic>);
  }

  /// Signs [draft] with the next number of [serie] and stores it, ready to
  /// send. Nothing is stored and no number is used when the draft is invalid
  /// ([InvalidDraftError]) or can't be built or signed ([BridgeError]).
  Future<String> emit({
    required Company company,
    required Serie serie,
    required DocumentDraft draft,
  }) async {
    final problem = draft.problem;
    if (problem != null) throw InvalidDraftError(problem);
    if (draft is NoteDraft) await _checkAffected(draft, company, serie);
    final secrets = await _secureStore.readCompanySecrets(company.id);
    final (certificate, password) = await _certificate(company, secrets);
    final deviceId = await _db.deviceId();

    // The serie's row stays locked while the Rust bridge builds and signs:
    // fast, and nothing else issues documents meanwhile
    return _db.transaction(() async {
      final current =
          await (_db.select(_db.series)..where(
                (s) =>
                    s.id.equals(serie.id) &
                    s.companyId.equals(company.id) &
                    s.tipoComprobante.equals(draft.tipoComprobante) &
                    s.active.equals(true),
              ))
              .getSingle();
      final lastNumero = await _documents.lastNumero(
        company.id,
        company.sunatEnvironment,
        current.tipoComprobante,
        current.serie,
      );
      final numero = current.nextNumber > lastNumero
          ? current.nextNumber
          : lastNumero + 1;
      final fechaEmision = peruToday();
      final inputJson = draft.toDocumentJson(
        company: company,
        serieNumero: '${current.serie}-$numero',
        fechaEmision: fechaEmision,
      );
      final built = await _bridge.build(inputJson, _defaults(fechaEmision));
      final spec =
          (jsonDecode(built.enrichedJson) as Map)['spec']
              as Map<String, Object?>;
      final total = roundAmount(draft.totalOf(spec));
      _checkTotals(draft, total, fechaEmision);
      if (draft is NoteDraft && draft.tipoComprobante == '07') {
        final credited = creditedCents(
          await _documents.related(draft.affected.id),
        );
        if (credited + toCents(total) > toCents(draft.affected.total)) {
          throw const InvalidDraftError(DraftProblem.noteExceedsInvoice);
        }
      }
      final signed = await _bridge.sign(built.xml, certificate, password);

      final document = await _store(
        DocumentsCompanion.insert(
          companyId: company.id,
          environment: company.sunatEnvironment,
          tipoComprobante: current.tipoComprobante,
          serie: current.serie,
          numero: numero,
          fechaEmision: fechaEmision,
          clienteTipoDocumento: draft.customer.tipoDocumentoIdentidad,
          clienteNumeroDocumento: draft.customer.numeroDocumentoIdentidad,
          clienteNombre: draft.customer.nombre,
          moneda: draft.moneda,
          total: total,
          status: DocumentStatus.pendingSend,
          digestValue: signed.digestValue,
          inputJson: inputJson,
          enrichedJson: built.enrichedJson,
          affectedDocumentId: Value(draft.affectedDocumentId),
          deviceId: deviceId,
        ),
        signed.xml,
      );
      await (_db.update(
        _db.series,
      )..where((s) => s.id.equals(current.id))).write(
        SeriesCompanion(
          nextNumber: Value(numero + 1),
          updatedAt: Value(nowUtc()),
        ),
      );
      return document.id;
    });
  }

  /// Stores a signed document, ready to send
  Future<Document> _store(DocumentsCompanion document, String signedXml) async {
    final stored = await _db.into(_db.documents).insertReturning(document);
    final xml = utf8.encode(signedXml);
    await _db
        .into(_db.documentFiles)
        .insert(
          DocumentFilesCompanion.insert(
            documentId: stored.id,
            kind: DocumentFileKind.signedXml,
            bytes: xml,
            sha256: crypto.sha256.convert(xml).toString(),
          ),
        );
    await _addEvent(stored.id, stored.status, stored.deviceId);
    return stored;
  }

  /// Issues the comunicación de baja, resumen diario or reversión that voids
  /// an accepted document, ready to send; the document is [DocumentStatus.voiding]
  /// until SUNAT answers it. Returns the voiding document's id.
  Future<String> voidDocument(
    String documentId, {
    required String motivo,
  }) async {
    final fechaEmision = peruToday();
    final document = await _documents.find(documentId);
    final company = await (_db.select(
      _db.companies,
    )..where((c) => c.id.equals(document.companyId))).getSingle();
    await _checkVoidable(document, company, fechaEmision);
    final secrets = await _secureStore.readCompanySecrets(company.id);
    final (certificate, password) = await _certificate(company, secrets);
    final deviceId = await _db.deviceId();
    final tipo = voidingTipo(document);
    final serie = voidingSerie(tipo, fechaEmision);

    return _db.transaction(() async {
      // Read again: it may have been voided meanwhile
      final current = await _documents.find(documentId);
      await _checkVoidable(current, company, fechaEmision);
      final numero =
          await _documents.lastNumero(
            company.id,
            current.environment,
            tipo,
            serie,
          ) +
          1;
      final inputJson = voidingJson(
        company: company,
        document: current,
        motivo: motivo,
        numero: numero,
        fechaEmision: fechaEmision,
      );
      final built = await _bridge.build(inputJson, _defaults(fechaEmision));
      final signed = await _bridge.sign(built.xml, certificate, password);
      final voiding = await _store(
        DocumentsCompanion.insert(
          companyId: company.id,
          environment: current.environment,
          tipoComprobante: tipo,
          serie: serie,
          numero: numero,
          fechaEmision: fechaEmision,
          clienteTipoDocumento: current.clienteTipoDocumento,
          clienteNumeroDocumento: current.clienteNumeroDocumento,
          clienteNombre: current.clienteNombre,
          moneda: current.moneda,
          total: current.total,
          status: DocumentStatus.pendingSend,
          digestValue: signed.digestValue,
          inputJson: inputJson,
          enrichedJson: built.enrichedJson,
          affectedDocumentId: Value(current.id),
          deviceId: deviceId,
        ),
        signed.xml,
      );
      await (_db.update(
        _db.documents,
      )..where((d) => d.id.equals(current.id))).write(
        DocumentsCompanion(
          status: const Value(DocumentStatus.voiding),
          voidedByDocumentId: Value(voiding.id),
          updatedAt: Value(nowUtc()),
        ),
      );
      await _addEvent(
        current.id,
        DocumentStatus.voiding,
        deviceId,
        null,
        serieNumero(voiding.serie, voiding.numero),
      );
      return voiding.id;
    });
  }

  /// Documents accepted by SUNAT up to [voidingDays] ago can be voided
  /// (later, a nota de crédito is issued instead), once their notas are
  Future<void> _checkVoidable(
    Document document,
    Company company,
    String today,
  ) async {
    if (!voidableTipos.contains(document.tipoComprobante) ||
        !acceptedStatuses.contains(document.status) ||
        document.environment != company.sunatEnvironment) {
      throw const InvalidDraftError(DraftProblem.notVoidable);
    }
    if (!inVoidingTime(document, today)) {
      throw const InvalidDraftError(DraftProblem.voidingTooLate);
    }
    final related = await _documents.related(document.id);
    if (related.any(
      (d) =>
          const {'07', '08'}.contains(d.tipoComprobante) &&
          d.status != DocumentStatus.rejected &&
          d.status != DocumentStatus.voided,
    )) {
      throw const InvalidDraftError(DraftProblem.voidNotesFirst);
    }
  }

  /// Rejections of a voiding document saying SUNAT already has it, or has
  /// already voided the document: the document isn't accepted again
  static const _alreadyVoided = {'2223', '2323', '2324', '2751', '2987'};

  /// When SUNAT answers a voiding document, the document it voids is
  /// voided, or accepted again if SUNAT rejected the voiding
  Future<void> _settleVoiding(
    Document voiding,
    DocumentStatus status,
    String? code,
    String deviceId,
  ) async {
    final voidedId = voiding.affectedDocumentId;
    final isVoided = acceptedStatuses.contains(status);
    if (!voidingTipos.contains(voiding.tipoComprobante) ||
        voidedId == null ||
        (!isVoided && status != DocumentStatus.rejected) ||
        (!isVoided && _alreadyVoided.contains(code))) {
      return;
    }
    final voided = await _documents.find(voidedId);
    if (voided.status != DocumentStatus.voiding) return;
    final hasObservations =
        voided.sunatNotes != null ||
        (int.tryParse(voided.sunatCode ?? '') ?? 0) >= 4000;
    final newStatus = isVoided
        ? DocumentStatus.voided
        : hasObservations
        ? DocumentStatus.acceptedWithObservations
        : DocumentStatus.accepted;
    await (_db.update(
      _db.documents,
    )..where((d) => d.id.equals(voidedId))).write(
      DocumentsCompanion(
        status: Value(newStatus),
        // A rejected voiding can be tried again
        voidedByDocumentId: Value(isVoided ? voiding.id : null),
        updatedAt: Value(nowUtc()),
      ),
    );
    await _addEvent(
      voidedId,
      newStatus,
      deviceId,
      null,
      serieNumero(voiding.serie, voiding.numero),
    );
  }

  /// Notas modify accepted facturas and boletas, as they are now
  Future<void> _checkAffected(
    NoteDraft draft,
    Company company,
    Serie serie,
  ) async {
    final affected = await _documents.find(draft.affected.id);
    if (!const {'01', '03'}.contains(affected.tipoComprobante) ||
        !acceptedStatuses.contains(affected.status) ||
        affected.companyId != company.id ||
        affected.environment != company.sunatEnvironment) {
      throw const InvalidDraftError(DraftProblem.invalidAffectedDocument);
    }
    if (!serie.serie.startsWith(affected.serie.substring(0, 1))) {
      throw const InvalidDraftError(DraftProblem.noteSerieMismatch);
    }
  }

  void _checkTotals(DocumentDraft draft, String total, String fechaEmision) {
    if (exceedsAnonymousLimit(draft.customer, draft.moneda, total)) {
      throw const InvalidDraftError(DraftProblem.anonymousOver700);
    }
    if (draft is! InvoiceDraft || draft.cuotas.isEmpty) return;
    final cuotas = draft.cuotas;
    final sum = cuotas.fold(BigInt.zero, (sum, c) => sum + toCents(c.importe));
    if (sum != toCents(total) ||
        cuotas.any((c) => c.fechaPago.compareTo(fechaEmision) <= 0)) {
      throw const InvalidDraftError(DraftProblem.cuotasMismatch);
    }
  }

  /// Sends the document, or checks its ticket, and records SUNAT's answer.
  /// [manual] sends (the user's "send now") restart the retry back-off.
  Future<DocumentStatus> send(String documentId, {bool manual = false}) {
    final previous = _sending;
    final sent = previous == null
        ? _send(documentId, manual)
        : previous.then((_) => _send(documentId, manual));
    _sending = sent.then((_) {}, onError: (_) {});
    return sent;
  }

  /// Sends every document whose next attempt is due (the outbox). Calls
  /// while a round is running join it. With a [budget] (iOS gives
  /// background tasks about 30 s), no new send starts once it's spent; the
  /// rest wait for the next round.
  Future<void> sendDue({Duration? budget}) => _outbox ??= () async {
    final clock = Stopwatch()..start();
    try {
      final due = await _documents.due(nowUtc());
      for (final document in due) {
        if (budget != null && clock.elapsed > budget) break;
        await send(document.id);
      }
    } finally {
      _outbox = null;
    }
  }();

  /// How long a claimed document waits before another connection may try
  static const claimTime = Duration(minutes: 2);

  Future<DocumentStatus> _send(String documentId, bool manual) async {
    final found = await _documents.find(documentId);
    if (!sendable.contains(found.status)) return found.status;
    // Automatic sends respect the retry back-off
    final nextAttemptAt = found.nextAttemptAt;
    final now = nowUtc();
    if (!manual && nextAttemptAt != null && nextAttemptAt.isAfter(now)) {
      return found.status;
    }
    // Claims it: the app and the background outbox use separate database
    // connections, and only one of them must send it
    final claimed =
        await (_db.update(_db.documents)..where(
              (d) =>
                  d.id.equals(documentId) & d.updatedAt.equals(found.updatedAt),
            ))
            .write(
              DocumentsCompanion(
                nextAttemptAt: Value(now.add(claimTime)),
                updatedAt: Value(now),
              ),
            );
    if (claimed == 0) return (await _documents.find(documentId)).status;
    final document = await _documents.find(documentId);

    SunatResponse response;
    try {
      response = await _ask(document);
    } on _NoCredentials catch (missing) {
      response = SunatResponse(
        status: SunatStatus.exception,
        code: missing.code,
        notes: const [],
      );
    } on BridgeError catch (error) {
      response = SunatResponse(
        // The answer couldn't be read: SUNAT may have it, ask again later
        status: error.kind == BridgeErrorKind.other
            ? SunatStatus.notDelivered
            : SunatStatus.exception,
        code: LocalCodes.error,
        description: error.message,
        notes: const [],
      );
    } on Object catch (error) {
      // Anything else must not stop the outbox for the other documents
      response = SunatResponse(
        status: SunatStatus.exception,
        code: LocalCodes.error,
        description: '$error',
        notes: const [],
      );
    }
    return _record(document, response, manual);
  }

  /// Sends, or checks the ticket of a document in progress. A resend that
  /// answers 1033 (registered previously, e.g. the first send timed out
  /// after SUNAT got it) recovers the original CDR.
  Future<SunatResponse> _ask(Document document) async {
    final company = await (_db.select(
      _db.companies,
    )..where((c) => c.id.equals(document.companyId))).getSingle();
    if (document.tipoComprobante == '09' &&
        document.environment == SunatEnvironment.beta) {
      return const SunatResponse(
        status: SunatStatus.accepted,
        code: LocalCodes.betaGuia,
        notes: [],
      );
    }
    final credentials = await _credentials(company, document.environment);
    if (document.tipoComprobante == '09' &&
        (credentials.clientId == null || credentials.clientSecret == null)) {
      throw const _NoCredentials(LocalCodes.noGreCredentials);
    }
    final xml = await _signedXml(document);
    final ticket = document.ticket;
    if (document.status == DocumentStatus.inProgress && ticket != null) {
      return _request(
        () => _bridge.verify(xml, ticket, document.environment, credentials),
      );
    }
    final response = await _request(
      () => _bridge.send(xml, document.environment, credentials),
    );
    if (document.environment == SunatEnvironment.beta &&
        voidingTipos.contains(document.tipoComprobante) &&
        response.ticket != null) {
      // Beta can't check tickets: test mode takes the voiding as accepted
      return const SunatResponse(
        status: SunatStatus.accepted,
        code: LocalCodes.betaTicket,
        notes: [],
      );
    }
    if (response.code != '1033') return response;
    // SUNAT's CDR consult covers invoices and notas only
    if (document.environment == SunatEnvironment.production &&
        const {'01', '03', '07', '08'}.contains(document.tipoComprobante)) {
      return _request(
        () => _bridge.recover(document, company.ruc, credentials),
      );
    }
    // Beta has no consult service, and other documents have no CDR to
    // consult
    return SunatResponse(
      status: SunatStatus.unknown,
      code: response.code,
      description: response.description,
      notes: const [],
    );
  }

  Future<String> _signedXml(Document document) async {
    final xml = await _documents.file(document.id, DocumentFileKind.signedXml);
    return utf8.decode(xml!);
  }

  /// HTTP 401 is either wrong credentials or SUNAT throttling quick
  /// requests: it's asked again this many times before it's taken as wrong
  /// credentials. SUNAT didn't process the document, so asking is safe.
  static const _throttledRetries = 2;

  /// Calls SUNAT at least [pauseBetweenSends] after the previous call,
  /// whether it's the outbox, a manual send or a ticket check
  Future<SunatResponse> _request(Future<SunatResponse> Function() call) async {
    for (var retry = 0; ; retry++) {
      final last = _lastRequestAt;
      if (last != null) {
        final wait = pauseBetweenSends - DateTime.now().difference(last);
        if (wait > Duration.zero) await Future<void>.delayed(wait);
      }
      final SunatResponse response;
      try {
        response = await call();
      } finally {
        _lastRequestAt = DateTime.now();
      }
      if (response.code != 'HTTP 401' || retry == _throttledRetries) {
        return response;
      }
    }
  }

  Future<DocumentStatus> _record(
    Document document,
    SunatResponse response,
    bool manual,
  ) async {
    var status = statusOf(response);
    // A ticket check that got no answer is still a ticket check
    if (status == DocumentStatus.pendingSend &&
        document.status == DocumentStatus.inProgress) {
      status = DocumentStatus.inProgress;
    }
    final now = nowUtc();
    final attempts = response.status == SunatStatus.notDelivered
        ? (manual ? 0 : document.attempts) + 1
        : 0;
    final nextAttemptAt = switch (status) {
      DocumentStatus.pendingSend => now.add(
        retryDelays[(attempts - 1).clamp(0, retryDelays.length - 1)],
      ),
      DocumentStatus.inProgress => now.add(ticketCheckDelay),
      _ => null,
    };
    final deviceId = await _db.deviceId();
    return _db.transaction(() async {
      // Only if nothing else changed the document since it was read
      final updated =
          await (_db.update(_db.documents)..where(
                (d) =>
                    d.id.equals(document.id) &
                    d.updatedAt.equals(document.updatedAt),
              ))
              .write(
                DocumentsCompanion(
                  status: Value(status),
                  sunatCode: Value(response.code),
                  sunatDescription: Value(response.description),
                  sunatNotes: Value(
                    response.notes.isEmpty ? null : jsonEncode(response.notes),
                  ),
                  // A new send starts without the old ticket
                  ticket: Value(
                    status == DocumentStatus.inProgress
                        ? response.ticket ?? document.ticket
                        : null,
                  ),
                  attempts: Value(attempts),
                  nextAttemptAt: Value(nextAttemptAt),
                  updatedAt: Value(now),
                ),
              );
      if (updated == 0) return (await _documents.find(document.id)).status;

      final cdr = response.cdrZip;
      if (cdr != null) {
        final sha256 = crypto.sha256.convert(cdr).toString();
        await _db
            .into(_db.documentFiles)
            .insert(
              DocumentFilesCompanion.insert(
                documentId: document.id,
                kind: DocumentFileKind.cdrZip,
                bytes: cdr,
                sha256: sha256,
              ),
              onConflict: DoUpdate(
                (_) => DocumentFilesCompanion(
                  bytes: Value(cdr),
                  sha256: Value(sha256),
                  updatedAt: Value(now),
                ),
                target: [_db.documentFiles.documentId, _db.documentFiles.kind],
              ),
            );
      }
      await _addEvent(
        document.id,
        status,
        deviceId,
        response.code,
        response.description,
      );
      await _settleVoiding(document, status, response.code, deviceId);
      return status;
    });
  }

  /// Adds an event to the timeline; a repeat of the last one (e.g. hourly
  /// retries without connection) only updates its time and message
  Future<void> _addEvent(
    String documentId,
    DocumentStatus status,
    String deviceId, [
    String? code,
    String? message,
  ]) async {
    final last =
        await (_db.select(_db.documentEvents)
              ..where((e) => e.documentId.equals(documentId))
              ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (last != null && last.status == status && last.code == code) {
      await (_db.update(
        _db.documentEvents,
      )..where((e) => e.id.equals(last.id))).write(
        DocumentEventsCompanion(
          message: Value(message),
          updatedAt: Value(nowUtc()),
        ),
      );
      return;
    }
    await _db
        .into(_db.documentEvents)
        .insert(
          DocumentEventsCompanion.insert(
            documentId: documentId,
            status: status,
            code: Value(code),
            message: Value(message),
            deviceId: deviceId,
          ),
        );
  }

  Future<(Uint8List, String)> _certificate(
    Company company,
    CompanySecrets secrets,
  ) async {
    final certificate = secrets.certificate;
    if (certificate != null) {
      return (certificate, secrets.certificatePassword ?? '');
    }
    if (company.sunatEnvironment == SunatEnvironment.beta) {
      return (await _loadDemoCertificate(), 'password');
    }
    throw const MissingCertificateError();
  }

  /// SUNAT beta takes any RUC with the MODDATOS user
  Future<SunatCredentials> _credentials(
    Company company,
    SunatEnvironment environment,
  ) async {
    if (environment == SunatEnvironment.beta) {
      return SunatCredentials(
        username: '${company.ruc}MODDATOS',
        password: 'MODDATOS',
      );
    }
    final secrets = await _secureStore.readCompanySecrets(company.id);
    final username = secrets.solUsername;
    final password = secrets.solPassword;
    if (username == null || password == null) {
      throw const _NoCredentials(LocalCodes.noCredentials);
    }
    return SunatCredentials(
      username: username,
      password: password,
      clientId: secrets.greClientId,
      clientSecret: secrets.greClientSecret,
    );
  }
}

class _NoCredentials implements Exception {
  const _NoCredentials(this.code);

  /// [LocalCodes.noCredentials] or [LocalCodes.noGreCredentials]
  final String code;
}

final documentServiceProvider = Provider(
  (ref) => DocumentService(
    ref.watch(databaseProvider),
    ref.watch(documentRepositoryProvider),
    ref.watch(secureStoreProvider),
    ref.watch(sunatBridgeProvider),
  ),
);
