import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailer/mailer.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/customer/customer_repository.dart';
import 'package:xhandler_mobile/features/delivery/delivery_service.dart';
import 'package:xhandler_mobile/features/delivery/email_sender.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/pdf/pdf_templates.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

import '../../fake_email_sender.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late FakeEmailSender sender;
  late DeliveryService service;
  late Company company;
  late Document document;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    sender = FakeEmailSender();
    service = DeliveryService(
      database,
      DocumentRepository(database),
      CustomerRepository(database),
      SecureStore(),
      sender,
    );
    final companies = CompanyRepository(database, SecureStore());
    await companies.create(
      CompaniesCompanion.insert(
        ruc: '20123456789',
        razonSocial: 'Empresa S.A.C.',
      ),
    );
    company = (await companies.watchActive().first)!;
    document = await database
        .into(database.documents)
        .insertReturning(
          DocumentsCompanion.insert(
            companyId: company.id,
            environment: SunatEnvironment.beta,
            tipoComprobante: '01',
            serie: 'F001',
            numero: 7,
            fechaEmision: '2026-11-13',
            clienteTipoDocumento: '6',
            clienteNumeroDocumento: '20100070970',
            clienteNombre: 'SUPERMERCADOS PERUANOS S.A.',
            moneda: 'PEN',
            total: '118.00',
            status: DocumentStatus.accepted,
            digestValue: 'hash',
            inputJson: jsonEncode({
              'spec': {
                'cliente': {
                  'contacto': {'email': 'compras@example.com'},
                },
              },
            }),
            enrichedJson: jsonEncode({
              'spec': {
                'cliente': {
                  'tipo_documento_identidad': '6',
                  'numero_documento_identidad': '20100070970',
                  'nombre': 'SUPERMERCADOS PERUANOS S.A.',
                },
                'detalles': <Object>[],
                'total_importe': {'importe': '118.00'},
              },
            }),
            deviceId: 'd',
          ),
        );
  });
  tearDown(() => database.close());

  Future<void> configureEmail() =>
      SecureStore().writeCompanySecrets(company.id, {
        CompanySecret.smtpHost: 'smtp.gmail.com',
        CompanySecret.smtpPort: '465',
        CompanySecret.smtpUsername: 'ventas@empresa.pe',
        CompanySecret.smtpPassword: 'app password',
      });

  test('the email comes from the customer list, else the document', () async {
    expect(await service.emailOf(document), 'compras@example.com');

    await database
        .into(database.customers)
        .insert(
          CustomersCompanion.insert(
            companyId: company.id,
            tipoDocumentoIdentidad: '6',
            numeroDocumentoIdentidad: '20100070970',
            nombre: 'SUPERMERCADOS PERUANOS S.A.',
            email: const Value('facturas@spsa.pe'),
          ),
        );
    expect(await service.emailOf(document), 'facturas@spsa.pe');
  });

  test('emails the PDF and XML, and records it', () async {
    await configureEmail();
    await database
        .into(database.documentFiles)
        .insert(
          DocumentFilesCompanion.insert(
            documentId: document.id,
            kind: DocumentFileKind.signedXml,
            bytes: Uint8List.fromList([60]),
            sha256: 'x',
          ),
        );

    await service.email(
      company: company,
      document: document,
      to: 'compras@example.com',
      template: pdfTemplates.first,
    );

    expect(sender.sent.single.to, 'compras@example.com');
    expect(
      sender.sent.single.subject,
      'Factura F001-00000007 de Empresa S.A.C.',
    );
    expect(sender.sent.single.files, [
      '20123456789-01-F001-7.pdf',
      '20123456789-01-F001-7.xml',
    ]);
    final delivery = await database.select(database.deliveries).getSingle();
    expect(delivery.channel, DeliveryChannel.email);
    expect(delivery.recipient, 'compras@example.com');
  });

  test('without an email account nothing is sent', () async {
    expect(await service.canEmail(company), isFalse);
    await expectLater(
      service.email(
        company: company,
        document: document,
        to: 'compras@example.com',
        template: pdfTemplates.first,
      ),
      throwsA(isA<EmailNotConfiguredError>()),
    );
    await configureEmail();
    expect(await service.canEmail(company), isTrue);
  });

  test('a failed email is not recorded', () async {
    await configureEmail();
    sender.error = const EmailException(EmailError.authentication);

    await expectLater(
      service.email(
        company: company,
        document: document,
        to: 'compras@example.com',
        template: pdfTemplates.first,
      ),
      throwsA(isA<EmailException>()),
    );
    expect(await database.select(database.deliveries).get(), isEmpty);
  });

  test('the email says when SUNAT has not confirmed the document', () {
    expect(
      DeliveryService.body(company, document),
      isNot(contains('pendiente')),
    );
    expect(
      DeliveryService.body(
        company,
        document.copyWith(status: DocumentStatus.pendingSend),
      ),
      contains('pendiente de confirmación de SUNAT'),
    );
  });

  test('mail failures say what the user can do', () {
    expect(
      emailErrorOf(SmtpClientAuthenticationException('535 bad credentials')),
      EmailError.authentication,
    );
    for (final error in [
      SmtpNoGreetingException('no greeting'),
      SmtpUnsecureException('no STARTTLS'),
      const SocketException('unreachable'),
      const HandshakeException('bad certificate'),
      TimeoutException('slow'),
    ]) {
      expect(emailErrorOf(error), EmailError.connection, reason: '$error');
    }
    expect(
      emailErrorOf(SmtpMessageValidationException('bad', [])),
      EmailError.rejected,
    );
    expect(emailErrorOf(StateError('bug')), isNull);
  });

  test('test-mode documents say they are not valid', () {
    expect(
      DeliveryService.body(company, document),
      contains('sin validez tributaria'),
    );
    expect(
      DeliveryService.body(
        company,
        document.copyWith(environment: SunatEnvironment.production),
      ),
      isNot(contains('sin validez')),
    );
  });
}
