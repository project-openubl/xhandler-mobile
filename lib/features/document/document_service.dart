import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/secure_store.dart';
import '../../peru_date.dart';
import '../../src/rust/api/document.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/sunat.dart';
import 'invoice_draft.dart';
import 'sunat_bridge.dart';

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
    this._secureStore,
    this._bridge, {
    Future<Uint8List> Function() demoCertificate = loadDemoCertificate,
  }) : _loadDemoCertificate = demoCertificate;

  final AppDatabase _db;
  final SecureStore _secureStore;
  final SunatBridge _bridge;
  final Future<Uint8List> Function() _loadDemoCertificate;

  /// Waits between sends that got no answer: 1, 5, 15 minutes, then hourly
  static const retryDelays = [
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(hours: 1),
  ];

  /// How often a ticket is checked
  static const ticketCheckDelay = Duration(minutes: 2);

  /// Signs [draft] with the next number of [serie] and stores it, ready to
  /// send. Nothing is stored and no number is used if building or signing
  /// fails (a [BridgeError]).
  Future<String> emit({
    required Company company,
    required Serie serie,
    required InvoiceDraft draft,
  }) async {
    final secrets = await _secureStore.readCompanySecrets(company.id);
    final (certificate, password) = await _certificate(company, secrets);
    final deviceId = await _db.deviceId();

    return _db.transaction(() async {
      final current = await (_db.select(
        _db.series,
      )..where((s) => s.id.equals(serie.id))).getSingle();
      final numero = current.nextNumber;
      final fechaEmision = peruToday();
      final built = await _bridge.build(
        draft.toDocumentJson(
          company: company,
          serieNumero: '${current.serie}-$numero',
          fechaEmision: fechaEmision,
        ),
        DocumentDefaults(
          igvTasa: TaxRates.igv,
          icbTasa: TaxRates.icb,
          ivapTasa: TaxRates.ivap,
          fechaEmision: fechaEmision,
        ),
      );
      final signed = await _bridge.sign(built.xml, certificate, password);
      final spec = (jsonDecode(built.enrichedJson) as Map)['spec'] as Map;

      final document = await _db
          .into(_db.documents)
          .insertReturning(
            DocumentsCompanion.insert(
              companyId: company.id,
              environment: company.sunatEnvironment,
              tipoComprobante: draft.tipoComprobante,
              serie: current.serie,
              numero: numero,
              fechaEmision: fechaEmision,
              clienteTipoDocumento: draft.customer.tipoDocumentoIdentidad,
              clienteNumeroDocumento: draft.customer.numeroDocumentoIdentidad,
              clienteNombre: draft.customer.nombre,
              moneda: draft.moneda,
              total: '${(spec['total_importe'] as Map)['importe']}',
              status: DocumentStatus.pendingSend,
              digestValue: signed.digestValue,
              enrichedJson: built.enrichedJson,
              deviceId: deviceId,
            ),
          );
      await _db
          .into(_db.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              documentId: document.id,
              kind: DocumentFileKind.signedXml,
              bytes: utf8.encode(signed.xml),
            ),
          );
      await _addEvent(document.id, DocumentStatus.pendingSend);
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

  /// Sends the document, or checks its ticket, and records SUNAT's answer
  Future<DocumentStatus> send(String documentId) async {
    final document = await (_db.select(
      _db.documents,
    )..where((d) => d.id.equals(documentId))).getSingle();
    final company = await (_db.select(
      _db.companies,
    )..where((c) => c.id.equals(document.companyId))).getSingle();
    final file =
        await (_db.select(_db.documentFiles)..where(
              (f) =>
                  f.documentId.equals(documentId) &
                  f.kind.equalsValue(DocumentFileKind.signedXml),
            ))
            .getSingle();
    final xml = utf8.decode(file.bytes);

    SunatResponse response;
    try {
      final credentials = await _credentials(company, document.environment);
      final ticket = document.ticket;
      response = ticket == null
          ? await _bridge.send(xml, document.environment, credentials)
          : await _bridge.verify(
              xml,
              ticket,
              document.environment,
              credentials,
            );
    } on BridgeError catch (error) {
      response = SunatResponse(
        status: SunatStatus.exception,
        code: 'LOCAL',
        description: error.message,
        notes: const [],
      );
    }
    return _record(document, response);
  }

  /// Sends every document whose next attempt is due (the outbox)
  Future<void> sendDue() async {
    final query = _db.select(_db.documents)
      ..where(
        (d) =>
            d.deletedAt.isNull() &
            d.status.isInValues(const [
              DocumentStatus.pendingSend,
              DocumentStatus.inProgress,
            ]) &
            (d.nextAttemptAt.isNull() |
                d.nextAttemptAt.isSmallerOrEqualValue(nowUtc())),
      )
      ..orderBy([(d) => OrderingTerm(expression: d.createdAt)]);
    for (final document in await query.get()) {
      await send(document.id);
    }
  }

  Future<DocumentStatus> _record(Document document, SunatResponse response) {
    final status = statusOf(response);
    final now = nowUtc();
    final attempts = response.status == SunatStatus.notDelivered
        ? document.attempts + 1
        : document.attempts;
    final nextAttemptAt = switch (status) {
      DocumentStatus.pendingSend => now.add(
        retryDelays[(attempts - 1).clamp(0, retryDelays.length - 1)],
      ),
      DocumentStatus.inProgress => now.add(ticketCheckDelay),
      _ => null,
    };
    return _db.transaction(() async {
      await (_db.update(
        _db.documents,
      )..where((d) => d.id.equals(document.id))).write(
        DocumentsCompanion(
          status: Value(status),
          sunatCode: Value(response.code),
          sunatDescription: Value(response.description),
          sunatNotes: Value(
            response.notes.isEmpty ? null : jsonEncode(response.notes),
          ),
          ticket: Value(response.ticket ?? document.ticket),
          attempts: Value(attempts),
          nextAttemptAt: Value(nextAttemptAt),
          updatedAt: Value(now),
        ),
      );
      final cdr = response.cdrZip;
      if (cdr != null) {
        await _db
            .into(_db.documentFiles)
            .insert(
              DocumentFilesCompanion.insert(
                documentId: document.id,
                kind: DocumentFileKind.cdrZip,
                bytes: cdr,
              ),
              onConflict: DoUpdate(
                (_) => DocumentFilesCompanion(bytes: Value(cdr)),
                target: [_db.documentFiles.documentId, _db.documentFiles.kind],
              ),
            );
      }
      await _addEvent(document.id, status, response.code, response.description);
      return status;
    });
  }

  Future<void> _addEvent(
    String documentId,
    DocumentStatus status, [
    String? code,
    String? message,
  ]) => _db
      .into(_db.documentEvents)
      .insert(
        DocumentEventsCompanion.insert(
          documentId: documentId,
          status: status,
          code: Value(code),
          message: Value(message),
        ),
      );

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
    return SunatCredentials(
      username: secrets.solUsername ?? '',
      password: secrets.solPassword ?? '',
      clientId: secrets.greClientId,
      clientSecret: secrets.greClientSecret,
    );
  }
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
    ref.watch(secureStoreProvider),
    ref.watch(sunatBridgeProvider),
  ),
);
