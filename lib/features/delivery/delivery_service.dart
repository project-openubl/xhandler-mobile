import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/secure_store.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../customer/customer_repository.dart';
import '../document/document_repository.dart';
import '../document/document_status.dart';
import '../document/sunat_answer.dart';
import '../pdf/pdf_templates.dart';
import '../pdf/share_document.dart';
import 'email_sender.dart';

/// The company's email account isn't configured
class EmailNotConfiguredError implements Exception {
  const EmailNotConfiguredError();
}

/// Sends documents to customers and records it (docs/DESIGN.md §8)
class DeliveryService {
  DeliveryService(
    this._db,
    this._documents,
    this._customers,
    this._secureStore,
    this._emailSender,
  );

  final AppDatabase _db;
  final DocumentRepository _documents;
  final CustomerRepository _customers;
  final SecureStore _secureStore;
  final EmailSender _emailSender;

  /// The customer's email, from the customer list or the document
  Future<String?> emailOf(Document document) async {
    final customer = await _customers.findByDocument(
      document.companyId,
      document.clienteTipoDocumento,
      document.clienteNumeroDocumento,
    );
    final spec =
        (jsonDecode(document.inputJson) as Map<String, Object?>)['spec']
            as Map<String, Object?>?;
    final contacto =
        (spec?['cliente'] as Map<String, Object?>?)?['contacto']
            as Map<String, Object?>?;
    String? text(Object? value) =>
        value is String && value.trim().isNotEmpty ? value.trim() : null;
    return text(customer?.email) ?? text(contacto?['email']);
  }

  /// How the company signs its emails
  static String _senderName(Company company) =>
      company.nombreComercial ?? company.razonSocial;

  /// Whether the company can send emails
  Future<bool> canEmail(Company company) async =>
      smtpSettings(await _secureStore.readCompanySecrets(company.id)) != null;

  /// "Factura F001-00000001 de Empresa S.A.C."
  static String subject(Company company, Document document) =>
      '${Catalogs.tiposComprobante[document.tipoComprobante]} '
      '${serieNumero(document.serie, document.numero)} de '
      '${company.razonSocial}';

  static String body(Company company, Document document) {
    final tipo = Catalogs.tiposComprobante[document.tipoComprobante]!
        .toLowerCase();
    return [
      'Hola, ${document.clienteNombre}:',
      '',
      'Te enviamos tu $tipo ${serieNumero(document.serie, document.numero)}'
          ' por ${formatMoney(document.moneda, document.total)}, en PDF y XML.',
      if (!acceptedStatuses.contains(document.status))
        'Aún está pendiente de confirmación de SUNAT.',
      if (document.environment == SunatEnvironment.beta)
        Strings.testDocumentNote,
      '',
      _senderName(company),
      'RUC ${company.ruc}',
    ].join('\n');
  }

  /// Emails the document to [to] from the company's account. Throws
  /// [EmailNotConfiguredError] or [EmailException].
  Future<void> email({
    required Company company,
    required Document document,
    required String to,
    required PdfTemplate template,
  }) async {
    final settings = smtpSettings(
      await _secureStore.readCompanySecrets(company.id),
    );
    if (settings == null) throw const EmailNotConfiguredError();
    await _emailSender.send(
      settings: settings,
      fromName: _senderName(company),
      to: to,
      subject: subject(company, document),
      body: body(company, document),
      files: await deliveryFiles(
        company: company,
        document: document,
        documents: _documents,
        template: template,
      ),
    );
    await record(document, DeliveryChannel.email, to);
  }

  /// Sends a test email to the account itself. Throws [EmailException].
  Future<void> testEmail(Company company, SmtpSettings settings) =>
      _emailSender.send(
        settings: settings,
        fromName: _senderName(company),
        to: settings.username,
        subject: 'Prueba de XHandler',
        body: 'Tu correo está listo para enviar comprobantes a tus clientes.',
      );

  /// Adds a delivery to the document's record
  Future<void> record(
    Document document,
    DeliveryChannel channel,
    String? recipient,
  ) async {
    await _db
        .into(_db.deliveries)
        .insert(
          DeliveriesCompanion.insert(
            documentId: document.id,
            channel: channel,
            recipient: Value(recipient),
            deviceId: await _db.deviceId(),
          ),
        );
  }

  Stream<List<Delivery>> watch(String documentId) =>
      (_db.select(_db.deliveries)
            ..where((d) => d.documentId.equals(documentId))
            ..orderBy([(d) => OrderingTerm(expression: d.createdAt)]))
          .watch();
}

final deliveryServiceProvider = Provider(
  (ref) => DeliveryService(
    ref.watch(databaseProvider),
    ref.watch(documentRepositoryProvider),
    ref.watch(customerRepositoryProvider),
    ref.watch(secureStoreProvider),
    ref.watch(emailSenderProvider),
  ),
);

final deliveriesProvider = StreamProvider.autoDispose
    .family<List<Delivery>, String>(
      (ref, documentId) => ref.watch(deliveryServiceProvider).watch(documentId),
    );
