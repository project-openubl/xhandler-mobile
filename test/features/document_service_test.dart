import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/document/document_service.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/sunat_bridge.dart';
import 'package:xhandler_mobile/src/rust/api/document.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/signer.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

/// Answers like the bridge without the native library
class FakeBridge implements SunatBridge {
  final builtJson = <String>[];
  final responses = <SunatResponse>[];
  final calls = <String>[];
  BridgeError? buildError;

  @override
  Future<BuiltDocument> build(
    String documentJson,
    DocumentDefaults defaults,
  ) async {
    if (buildError != null) throw buildError!;
    builtJson.add(documentJson);
    final spec = (jsonDecode(documentJson) as Map)['spec'] as Map;
    return BuiltDocument(
      xml: '<Invoice>${spec['serie_numero']}</Invoice>',
      enrichedJson: jsonEncode({
        'kind': 'Invoice',
        'spec': {
          ...spec,
          'total_importe': {'importe': '118.00'},
        },
      }),
    );
  }

  @override
  Future<SignedDocument> sign(
    String xml,
    Uint8List certificate,
    String password,
  ) async => SignedDocument(xml: '$xml<Signed/>', digestValue: 'hash');

  @override
  Future<SunatResponse> send(
    String xml,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) async {
    calls.add('send ${credentials.username}');
    return responses.removeAt(0);
  }

  @override
  Future<SunatResponse> verify(
    String xml,
    String ticket,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) async {
    calls.add('verify $ticket');
    return responses.removeAt(0);
  }
}

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
      expect(first.total, '118.00');
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
