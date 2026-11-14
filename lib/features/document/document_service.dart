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
import 'invoice_draft.dart';
import 'sunat_bridge.dart';

/// The company has no certificate and isn't in test mode
class MissingCertificateError implements Exception {
  const MissingCertificateError();
}

/// Why a draft can't be issued; checked before using a number, since SUNAT
/// would reject the document and the number would be lost
enum DraftProblem {
  noLines,

  /// Facturas are for customers with a RUC
  facturaWithoutRuc,

  /// Boletas over S/ 700 need an identified customer
  anonymousOver700,

  /// Installments must add up to the total, after the issue date
  cuotasMismatch,

  /// Notas of facturas use F series, notas of boletas B series
  noteSerieMismatch,
}

class InvalidDraftError implements Exception {
  const InvalidDraftError(this.problem);

  final DraftProblem problem;
}

/// Codes of local problems recorded as SUNAT answers
abstract final class LocalCodes {
  /// The app couldn't send or read the answer (a bug or corrupt data)
  static const error = 'LOCAL';

  /// Production without SOL credentials
  static const noCredentials = 'NO_CREDENTIALS';
}

/// Customer of boletas to people who don't identify themselves (accepted by
/// SUNAT for sales up to S/ 700)
const anonymousCustomer = DraftCustomer(
  tipoDocumentoIdentidad: '0',
  numeroDocumentoIdentidad: '-',
  nombre: 'CLIENTES VARIOS',
);

/// Amounts of a document, as SUNAT shows them
class DocumentTotals {
  const DocumentTotals(this._spec);

  /// The enriched document's `spec` (xbuilder JSON)
  final Map<String, dynamic> _spec;

  String _amount(String group, String field) =>
      roundAmount('${(_spec[group] as Map?)?[field] ?? 0}');

  String get gravado => _amount('total_impuestos', 'gravado_base_imponible');
  String get exonerado =>
      _amount('total_impuestos', 'exonerado_base_imponible');
  String get inafecto => _amount('total_impuestos', 'inafecto_base_imponible');
  String get igv => _amount('total_impuestos', 'gravado_importe');
  String get isc => _amount('total_impuestos', 'isc_importe');
  String get icb => _amount('total_impuestos', 'icb_importe');
  String get total => _amount('total_importe', 'importe');
}

/// Boletas over S/ 700 need an identified customer. Only soles are checked:
/// other currencies need an exchange rate, not supported yet.
bool exceedsAnonymousLimit(
  DraftCustomer customer,
  String moneda,
  String total,
) => customer.isAnonymous && moneda == 'PEN' && toCents(total) > toCents('700');

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
      DocumentDefaults(
        igvTasa: TaxRates.igv,
        icbTasa: TaxRates.icb,
        ivapTasa: TaxRates.ivap,
        fechaEmision: fechaEmision,
      ),
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
    if (draft.lines.isEmpty) {
      throw const InvalidDraftError(DraftProblem.noLines);
    }
    if (draft.tipoComprobante == '01' &&
        draft.customer.tipoDocumentoIdentidad != '6') {
      throw const InvalidDraftError(DraftProblem.facturaWithoutRuc);
    }
    if (draft is NoteDraft && serie.serie[0] != draft.affected.serie[0]) {
      throw const InvalidDraftError(DraftProblem.noteSerieMismatch);
    }
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
      final built = await _bridge.build(
        inputJson,
        DocumentDefaults(
          igvTasa: TaxRates.igv,
          icbTasa: TaxRates.icb,
          ivapTasa: TaxRates.ivap,
          fechaEmision: fechaEmision,
        ),
      );
      final spec = (jsonDecode(built.enrichedJson) as Map)['spec'] as Map;
      final total = roundAmount('${(spec['total_importe'] as Map)['importe']}');
      _checkTotals(draft, total, fechaEmision);
      final signed = await _bridge.sign(built.xml, certificate, password);

      final document = await _db
          .into(_db.documents)
          .insertReturning(
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
          );
      final xml = utf8.encode(signed.xml);
      await _db
          .into(_db.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              documentId: document.id,
              kind: DocumentFileKind.signedXml,
              bytes: xml,
              sha256: crypto.sha256.convert(xml).toString(),
            ),
          );
      await _addEvent(document.id, DocumentStatus.pendingSend, deviceId);
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
      for (final (index, document) in due.indexed) {
        if (budget != null && clock.elapsed > budget) break;
        if (index > 0) await Future<void>.delayed(pauseBetweenSends);
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
    } on _NoCredentials {
      response = const SunatResponse(
        status: SunatStatus.exception,
        code: LocalCodes.noCredentials,
        notes: [],
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
    final credentials = await _credentials(company, document.environment);
    final xml = await _signedXml(document);
    final ticket = document.ticket;
    if (document.status == DocumentStatus.inProgress && ticket != null) {
      return _bridge.verify(xml, ticket, document.environment, credentials);
    }
    final response = await _bridge.send(xml, document.environment, credentials);
    if (response.code != '1033') return response;
    if (document.environment == SunatEnvironment.production) {
      return _bridge.recover(document, company.ruc, credentials);
    }
    // Beta has no consult service to recover the CDR
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
  /// requests: the first ones are retried like a send without answer
  static const _throttledRetries = 2;

  Future<DocumentStatus> _record(
    Document document,
    SunatResponse incoming,
    bool manual,
  ) async {
    final response =
        incoming.code == 'HTTP 401' && document.attempts < _throttledRetries
        ? SunatResponse(
            status: SunatStatus.notDelivered,
            code: incoming.code,
            description: incoming.description,
            notes: const [],
          )
        : incoming;
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
    if (username == null || password == null) throw const _NoCredentials();
    return SunatCredentials(
      username: username,
      password: password,
      clientId: secrets.greClientId,
      clientSecret: secrets.greClientSecret,
    );
  }
}

class _NoCredentials implements Exception {
  const _NoCredentials();
}

/// The document status a SUNAT answer leads to (docs/DESIGN.md §5)
DocumentStatus statusOf(SunatResponse response) => switch (response.status) {
  SunatStatus.accepted
      when response.notes.isNotEmpty ||
          (int.tryParse(response.code ?? '') ?? 0) >= 4000 =>
    DocumentStatus.acceptedWithObservations,
  SunatStatus.accepted => DocumentStatus.accepted,
  SunatStatus.rejected => DocumentStatus.rejected,
  SunatStatus.exception => DocumentStatus.exception,
  SunatStatus.inProgress => DocumentStatus.inProgress,
  SunatStatus.unknown => DocumentStatus.unknown,
  SunatStatus.notDelivered => DocumentStatus.pendingSend,
};

final documentServiceProvider = Provider(
  (ref) => DocumentService(
    ref.watch(databaseProvider),
    ref.watch(documentRepositoryProvider),
    ref.watch(secureStoreProvider),
    ref.watch(sunatBridgeProvider),
  ),
);
