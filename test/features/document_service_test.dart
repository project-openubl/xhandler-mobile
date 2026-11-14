import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_bridge.dart';

import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/document/document_service.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/series/series_repository.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

const _draft = InvoiceDraft(
  tipoComprobante: '01',
  moneda: 'PEN',
  customer: DraftCustomer(
    tipoDocumentoIdentidad: '6',
    numeroDocumentoIdentidad: '20100070970',
    nombre: 'Cliente S.A.C.',
  ),
  lines: [DraftLine(descripcion: 'Café', cantidad: '2', precio: '59.00')],
);

void main() {
  late AppDatabase database;
  late FakeBridge bridge;
  late DocumentService service;
  late Company company;
  late Serie f001;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    bridge = FakeBridge();
    service = DocumentService(
      database,
      DocumentRepository(database),
      SecureStore(),
      bridge,
      demoCertificate: () async => Uint8List(1),
    );
    final companies = CompanyRepository(database, SecureStore());
    await companies.create(
      CompaniesCompanion.insert(ruc: '20123456789', razonSocial: 'Empresa'),
    );
    company = (await companies.watchActive().first)!;
    f001 = await (database.select(
      database.series,
    )..where((s) => s.serie.equals('F001'))).getSingle();
  });
  tearDown(() => database.close());

  Future<Document> document(String id) => (database.select(
    database.documents,
  )..where((d) => d.id.equals(id))).getSingle();

  Future<String> emit() =>
      service.emit(company: company, serie: f001, draft: _draft);

  group('emit', () {
    test('takes the next number, signs and stores the document', () async {
      final id = await emit();
      final second = await emit();

      final first = await document(id);
      expect(first.serie, 'F001');
      expect(first.numero, 1);
      expect((await document(second)).numero, 2);
      expect(first.status, DocumentStatus.pendingSend);
      expect(first.total, '118.00'); // rounded
      expect(first.digestValue, 'hash');

      final spec = (jsonDecode(bridge.builtJson.first) as Map)['spec'] as Map;
      expect(spec['serie_numero'], 'F001-1');
      expect((spec['proveedor'] as Map)['ruc'], '20123456789');
      expect(
        ((spec['detalles'] as List).single as Map)['precio_con_impuestos'],
        '59.00',
      );

      final serie = await (database.select(
        database.series,
      )..where((s) => s.id.equals(f001.id))).getSingle();
      expect(serie.nextNumber, 3);
      final xml = await (database.select(
        database.documentFiles,
      )..where((f) => f.documentId.equals(id))).getSingle();
      expect(utf8.decode(xml.bytes), '<Invoice>F001-1</Invoice><Signed/>');
    });

    test("uses no number when the document can't be built", () async {
      bridge.buildError = const BridgeError(
        kind: BridgeErrorKind.invalidDocument,
        message: 'invalid igv_tipo',
      );
      await expectLater(emit(), throwsA(isA<BridgeError>()));

      expect(await database.select(database.documents).get(), isEmpty);
      final serie = await (database.select(
        database.series,
      )..where((s) => s.id.equals(f001.id))).getSingle();
      expect(serie.nextNumber, 1);
    });

    test('needs a certificate outside test mode', () async {
      company = company.copyWith(sunatEnvironment: SunatEnvironment.production);
      await expectLater(emit(), throwsA(isA<MissingCertificateError>()));
    });
  });

  group('send', () {
    test('records an accepted document with its CDR', () async {
      final id = await emit();
      bridge.responses.add(
        SunatResponse(
          status: SunatStatus.accepted,
          code: '0',
          description: 'La Factura ha sido aceptada',
          notes: const [],
          cdrZip: Uint8List.fromList([1, 2, 3]),
        ),
      );

      expect(await service.send(id), DocumentStatus.accepted);

      expect(bridge.calls, ['send 20123456789MODDATOS']);
      final sent = await document(id);
      expect(sent.sunatCode, '0');
      expect(sent.nextAttemptAt, isNull);
      final files = await (database.select(
        database.documentFiles,
      )..where((f) => f.documentId.equals(id))).get();
      expect(files.map((f) => f.kind), containsAll(DocumentFileKind.values));
      final events = await (database.select(
        database.documentEvents,
      )..where((e) => e.documentId.equals(id))).get();
      expect(events.map((e) => e.status), [
        DocumentStatus.pendingSend,
        DocumentStatus.accepted,
      ]);
    });

    test(
      'retries later, longer each time, when SUNAT gives no answer',
      () async {
        final id = await emit();
        const noAnswer = SunatResponse(
          status: SunatStatus.notDelivered,
          description: 'connection refused',
          notes: [],
        );
        bridge.responses.addAll([noAnswer, noAnswer]);

        final before = DateTime.now().toUtc();
        expect(await service.send(id), DocumentStatus.pendingSend);
        var pending = await document(id);
        expect(pending.attempts, 1);
        expect(
          pending.nextAttemptAt!.difference(before),
          greaterThanOrEqualTo(const Duration(minutes: 1)),
        );

        await service.send(id);
        pending = await document(id);
        expect(pending.attempts, 2);
        expect(
          pending.nextAttemptAt!.difference(before),
          greaterThanOrEqualTo(const Duration(minutes: 5)),
        );
      },
    );

    test('follows a ticket until SUNAT answers', () async {
      final id = await emit();
      bridge.responses.addAll([
        const SunatResponse(
          status: SunatStatus.inProgress,
          notes: [],
          ticket: '1700000000000',
        ),
        SunatResponse(
          status: SunatStatus.accepted,
          code: '0',
          notes: const [],
          cdrZip: Uint8List(1),
        ),
      ]);

      expect(await service.send(id), DocumentStatus.inProgress);
      expect((await document(id)).ticket, '1700000000000');
      expect(await service.send(id), DocumentStatus.accepted);
      expect(bridge.calls.last, 'verify 1700000000000');
    });

    test('sendDue only sends documents whose time has come', () async {
      final due = await emit();
      final later = await emit();
      await (database.update(
        database.documents,
      )..where((d) => d.id.equals(later))).write(
        DocumentsCompanion(
          nextAttemptAt: Value(
            DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
        ),
      );
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );

      await service.sendDue();

      expect((await document(due)).status, DocumentStatus.accepted);
      expect((await document(later)).status, DocumentStatus.pendingSend);
    });
  });

  group('emit checks the draft before using a number', () {
    Future<void> expectProblem(
      InvoiceDraft draft,
      DraftProblem problem, {
      Serie? serie,
    }) async {
      await expectLater(
        service.emit(company: company, serie: serie ?? f001, draft: draft),
        throwsA(
          isA<InvalidDraftError>().having((e) => e.problem, 'problem', problem),
        ),
      );
      expect(await database.select(database.documents).get(), isEmpty);
    }

    test('facturas are for RUC customers', () async {
      await expectProblem(
        const InvoiceDraft(
          tipoComprobante: '01',
          moneda: 'PEN',
          customer: anonymousCustomer,
          lines: [DraftLine(descripcion: 'x', cantidad: '1', precio: '1')],
        ),
        DraftProblem.facturaWithoutRuc,
      );
    });

    test('anonymous boletas up to S/ 700', () async {
      final b001 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('B001'))).getSingle();
      bridge.total = '700.01';
      await expectProblem(
        const InvoiceDraft(
          tipoComprobante: '03',
          moneda: 'PEN',
          customer: anonymousCustomer,
          lines: [DraftLine(descripcion: 'x', cantidad: '1', precio: '700.01')],
        ),
        DraftProblem.anonymousOver700,
        serie: b001,
      );
    });

    test('installments add up to the total, after today', () async {
      await expectProblem(
        const InvoiceDraft(
          tipoComprobante: '01',
          moneda: 'PEN',
          customer: DraftCustomer(
            tipoDocumentoIdentidad: '6',
            numeroDocumentoIdentidad: '20100070970',
            nombre: 'Cliente',
          ),
          lines: [DraftLine(descripcion: 'x', cantidad: '2', precio: '59')],
          cuotas: [DraftCuota(importe: '100', fechaPago: '2099-01-01')],
        ),
        DraftProblem.cuotasMismatch,
      );
    });

    test('the serie must be of the document type', () async {
      final b001 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('B001'))).getSingle();
      await expectLater(
        service.emit(company: company, serie: b001, draft: _draft),
        throwsA(isA<StateError>()),
      );
    });
  });

  test('a lowered next number never reuses an issued one', () async {
    await emit();
    await emit();
    await (database.update(database.series)..where((s) => s.id.equals(f001.id)))
        .write(const SeriesCompanion(nextNumber: Value(1)));

    final third = await emit();

    expect((await document(third)).numero, 3);
  });

  group('send, more cases', () {
    test('keeps the observations of an accepted document', () async {
      final id = await emit();
      bridge.responses.add(
        const SunatResponse(
          status: SunatStatus.accepted,
          code: '0',
          notes: ['4252 - El dato ingresado como atributo no cumple'],
        ),
      );

      expect(await service.send(id), DocumentStatus.acceptedWithObservations);
      expect(jsonDecode((await document(id)).sunatNotes!), hasLength(1));
    });

    test('does nothing to a document SUNAT already answered', () async {
      final id = await emit();
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );
      await service.send(id);

      expect(await service.send(id, manual: true), DocumentStatus.accepted);
      expect(bridge.calls, hasLength(1));
    });

    test('runs one send at a time', () async {
      final id = await emit();
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );

      final results = await Future.wait([service.sendDue(), service.sendDue()]);

      expect(results, hasLength(2));
      expect(bridge.calls, hasLength(1));
      expect((await document(id)).status, DocumentStatus.accepted);
    });

    test('a resend after an exception sends again instead of checking the old ticket', () async {
      final id = await emit();
      bridge.responses.addAll([
        const SunatResponse(
          status: SunatStatus.inProgress,
          notes: [],
          ticket: 'T1',
        ),
        const SunatResponse(
          status: SunatStatus.exception,
          code: '0111',
          notes: [],
        ),
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      ]);

      await service.send(id); // ticket
      await service.send(id); // the ticket ends in an exception
      expect((await document(id)).ticket, isNull);
      await service.send(id, manual: true);

      expect(bridge.calls, [
        'send 20123456789MODDATOS',
        'verify T1',
        'send 20123456789MODDATOS',
      ]);
    });

    test('1033 recovers the CDR in production, is unknown in beta', () async {
      final beta = await emit();
      const registered = SunatResponse(
        status: SunatStatus.exception,
        code: '1033',
        description: 'El comprobante fue registrado previamente',
        notes: [],
      );
      bridge.responses.add(registered);
      expect(await service.send(beta), DocumentStatus.unknown);

      final secureStore = SecureStore();
      await secureStore.writeCompanySecrets(company.id, {
        CompanySecret.certificate: base64Encode([1]),
        CompanySecret.solUsername: '20123456789USUARIO',
        CompanySecret.solPassword: 'clave',
      });
      company = company.copyWith(sunatEnvironment: SunatEnvironment.production);
      await SeriesRepository(database)
          .resetNumbers(company.id, SunatEnvironment.production);
      final production = await emit();
      bridge.responses.addAll([
        registered,
        SunatResponse(
          status: SunatStatus.accepted,
          code: '0',
          notes: const [],
          cdrZip: Uint8List(1),
        ),
      ]);

      expect(await service.send(production), DocumentStatus.accepted);
      expect(bridge.calls.last, 'recover F001-1');
      expect(bridge.calls[bridge.calls.length - 2], 'send 20123456789USUARIO');
    });

    test('production without SOL credentials says so', () async {
      await SecureStore().writeCompanySecrets(company.id, {
        CompanySecret.certificate: base64Encode([1]),
      });
      company = company.copyWith(sunatEnvironment: SunatEnvironment.production);
      final id = await emit();

      expect(await service.send(id), DocumentStatus.exception);
      expect((await document(id)).sunatCode, LocalCodes.noCredentials);
      expect(bridge.calls, isEmpty);
    });

    test("an unreadable answer is asked again later; other errors don't stop the outbox", () async {
      final first = await emit();
      final second = await emit();
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );
      await (database.delete(
        database.documentFiles,
      )..where((f) => f.documentId.equals(first))).go();

      await service.sendDue();

      expect((await document(first)).status, DocumentStatus.exception);
      expect((await document(first)).sunatCode, LocalCodes.error);
      expect((await document(second)).status, DocumentStatus.accepted);
    });

    test('repeated failures update one event instead of piling up', () async {
      final id = await emit();
      const noAnswer = SunatResponse(
        status: SunatStatus.notDelivered,
        description: 'timeout',
        notes: [],
      );
      bridge.responses.addAll([noAnswer, noAnswer, noAnswer]);
      for (var i = 0; i < 3; i++) {
        await (database.update(database.documents)
              ..where((d) => d.id.equals(id)))
            .write(const DocumentsCompanion(nextAttemptAt: Value(null)));
        await service.send(id);
      }

      final events = await (database.select(
        database.documentEvents,
      )..where((e) => e.documentId.equals(id))).get();
      // Issued and its three retries are one "pending" event
      expect(events.single.message, 'timeout');
    });
  });

  test('statusOf follows DESIGN §5', () {
    SunatResponse answer(
      SunatStatus status, [
      String? code,
      List<String> notes = const [],
    ]) => SunatResponse(status: status, code: code, notes: notes);

    expect(
      statusOf(answer(SunatStatus.accepted, '0')),
      DocumentStatus.accepted,
    );
    expect(
      statusOf(answer(SunatStatus.accepted, '4252')),
      DocumentStatus.acceptedWithObservations,
    );
    expect(
      statusOf(answer(SunatStatus.accepted, '0', ['observación'])),
      DocumentStatus.acceptedWithObservations,
    );
    expect(
      statusOf(answer(SunatStatus.rejected, '2335')),
      DocumentStatus.rejected,
    );
    expect(
      statusOf(answer(SunatStatus.exception, 'HTTP 401')),
      DocumentStatus.exception,
    );
    expect(
      statusOf(answer(SunatStatus.notDelivered)),
      DocumentStatus.pendingSend,
    );
    expect(
      statusOf(answer(SunatStatus.inProgress, '98')),
      DocumentStatus.inProgress,
    );
  });
}
