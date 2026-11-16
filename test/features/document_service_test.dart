import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/despatch/despatch_advice_draft.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/document/document_service.dart';
import 'package:xhandler_mobile/features/document/draft_problem.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/perception_retention_draft.dart';
import 'package:xhandler_mobile/features/document/sunat_answer.dart';
import 'package:xhandler_mobile/features/series/series_repository.dart';
import 'package:xhandler_mobile/peru_date.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

import '../fake_bridge.dart';

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

const _rucCustomer = DraftCustomer(
  tipoDocumentoIdentidad: '6',
  numeroDocumentoIdentidad: '20100070970',
  nombre: 'Cliente S.A.C.',
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
      pauseBetweenSends: Duration.zero,
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

  /// Makes the document's next attempt due, as if the wait had passed
  Future<void> due(String id) =>
      (database.update(database.documents)..where((d) => d.id.equals(id)))
          .write(const DocumentsCompanion(nextAttemptAt: Value(null)));

  Future<String> emit([DocumentDraft draft = _draft]) =>
      service.emit(company: company, serie: f001, draft: draft);

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

    test(
      "doesn't sign with an expired certificate, nor use a number",
      () async {
        await SecureStore().writeCompanySecrets(company.id, {
          CompanySecret.certificate: base64Encode([1, 2, 3]),
        });
        bridge.certificateValidUntil = DateTime.utc(2020);

        await expectLater(emit(), throwsA(isA<ExpiredCertificateError>()));
        expect(await database.select(database.documents).get(), isEmpty);
      },
    );
  });

  test('a document in dollars keeps its rate, and so do its notas', () async {
    final id = await emit(
      const InvoiceDraft(
        tipoComprobante: '01',
        moneda: 'USD',
        tipoCambio: '3.752',
        customer: _rucCustomer,
        lines: [DraftLine(descripcion: 'Café', cantidad: '1', precio: '10')],
      ),
    );
    bridge.responses.add(
      const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
    );
    await service.send(id);
    final factura = await document(id);
    expect(factura.tipoCambio, '3.752');

    final fc01 = await (database.select(
      database.series,
    )..where((s) => s.serie.equals('FC01'))).getSingle();
    final noteId = await service.emit(
      company: company,
      serie: fc01,
      draft: NoteDraft(
        tipoComprobante: '07',
        affected: factura,
        tipoNota: '01',
        sustento: 'Anulación',
        customer: _rucCustomer,
        lines: const [
          DraftLine(descripcion: 'Café', cantidad: '1', precio: '10'),
        ],
      ),
    );
    final note = await document(noteId);
    expect((note.moneda, note.tipoCambio), ('USD', '3.752'));
  });

  group('detracción', () {
    const subject = InvoiceDraft(
      tipoComprobante: '01',
      moneda: 'PEN',
      customer: _rucCustomer,
      lines: [
        DraftLine(
          descripcion: 'Mantenimiento',
          cantidad: '1',
          precio: '1180',
          detraccionCodigo: '020',
          detraccionPorcentaje: '12',
        ),
      ],
    );

    Future<void> setAccount(String? account) async {
      await (database.update(database.companies)
            ..where((c) => c.id.equals(company.id)))
          .write(CompaniesCompanion(cuentaDetracciones: Value(account)));
      company = company.copyWith(cuentaDetracciones: Value(account));
    }

    Map<String, Object?> lastSpec() =>
        (jsonDecode(bridge.builtJson.last) as Map)['spec']
            as Map<String, Object?>;

    test('a factura over S/ 700 carries it, to the company account', () async {
      await setAccount('00-123-456789');
      bridge.total = '1180.00';
      final id = await emit(subject);

      expect(bridge.builtJson, hasLength(2)); // again, with the detracción
      expect(lastSpec()['detraccion'], {
        'medio_pago': '001',
        'cuenta_bancaria': '00-123-456789',
        'tipo_bien_detraido': '020',
        'porcentaje': '0.12',
        'monto': '141.60',
      });
      expect((await document(id)).inputJson, contains('"detraccion"'));
    });

    test('up to S/ 700 there is none', () async {
      await setAccount('00-123-456789');
      bridge.total = '700.00';
      await emit(subject);

      expect(bridge.builtJson, hasLength(1));
      expect(lastSpec().containsKey('detraccion'), isFalse);
    });

    test('needs the company account, before using a number', () async {
      bridge.total = '1180.00';
      await expectLater(
        emit(subject),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.missingDetraccionAccount,
          ),
        ),
      );
      expect(await database.select(database.documents).get(), isEmpty);
    });

    test('credit installments add up to the total less it', () async {
      await setAccount('00-123-456789');
      // 10 % of 1001.05 is 100.105: half up, 100.11, everywhere
      bridge.total = '1001.05';
      InvoiceDraft credit(String importe) => InvoiceDraft(
        tipoComprobante: '01',
        moneda: 'PEN',
        customer: _rucCustomer,
        lines: const [
          DraftLine(
            descripcion: 'Arrendamiento',
            cantidad: '1',
            precio: '1001.05',
            detraccionCodigo: '019',
            detraccionPorcentaje: '10',
          ),
        ],
        cuotas: [DraftCuota(importe: importe, fechaPago: '2099-01-01')],
      );

      await expectLater(
        emit(credit('1001.05')),
        throwsA(isA<InvalidDraftError>()),
      );
      await emit(credit('900.94'));
      expect((lastSpec()['detraccion']! as Map)['monto'], '100.11');
    });
  });

  group('send', () {
    test(
      'the outbox stops past the deadline; the user can still send',
      () async {
        final id = await emit();
        // Issued days ago and never answered (e.g. the phone was offline)
        await (database.update(database.documents)
              ..where((d) => d.id.equals(id)))
            .write(const DocumentsCompanion(fechaEmision: Value('2020-01-01')));

        expect(await service.send(id), DocumentStatus.exception);
        expect(bridge.calls, isEmpty);
        expect((await document(id)).sunatCode, LocalCodes.pastDeadline);

        bridge.responses.add(
          const SunatResponse(
            status: SunatStatus.accepted,
            code: '0',
            notes: [],
          ),
        );
        expect(await service.send(id, manual: true), DocumentStatus.accepted);
      },
    );

    test('documents within the deadline, or sent before, keep going', () async {
      // Issued today
      final id = await emit();
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.notDelivered, notes: []),
      );
      expect(await service.send(id), DocumentStatus.pendingSend);
      expect(bridge.calls, hasLength(1));

      // Sent once without an answer, then the deadline passed: SUNAT may
      // have it, and a resend would recover its CDR
      await (database.update(
        database.documents,
      )..where((d) => d.id.equals(id))).write(
        const DocumentsCompanion(
          fechaEmision: Value('2020-01-01'),
          nextAttemptAt: Value(null),
        ),
      );
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );
      expect(await service.send(id), DocumentStatus.accepted);
      expect(bridge.calls, hasLength(2));
    });

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

        await due(id);
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
      await due(id);
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
      await due(id);
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

  group('HTTP 401', () {
    const unauthorized = SunatResponse(
      status: SunatStatus.exception,
      code: 'HTTP 401',
      notes: [],
    );

    test('is asked twice more before it is wrong credentials', () async {
      final id = await emit();
      bridge.responses.addAll([unauthorized, unauthorized, unauthorized]);

      expect(await service.send(id), DocumentStatus.exception);
      expect(
        bridge.calls.where((call) => call.startsWith('send')),
        hasLength(3),
      );
    });

    test('a throttled request is accepted when asked again', () async {
      final id = await emit();
      bridge.responses.addAll([
        unauthorized,
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      ]);

      expect(await service.send(id), DocumentStatus.accepted);
    });

    test('is asked again after sends that got no answer', () async {
      final id = await emit();
      const noAnswer = SunatResponse(
        status: SunatStatus.notDelivered,
        notes: [],
      );
      bridge.responses.addAll([noAnswer, noAnswer]);
      await service.send(id);
      await due(id);
      await service.send(id);
      await due(id);
      bridge.responses.addAll([
        unauthorized,
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      ]);

      expect(await service.send(id), DocumentStatus.accepted);
    });
  });

  group('percepción and retención', () {
    PerceptionRetentionDraft draft({
      DraftCustomer customer = _rucCustomer,
      String importe = '1180.00',
    }) => PerceptionRetentionDraft(
      tipoComprobante: '40',
      customer: customer,
      tipoRegimen: '01',
      comprobanteSerieNumero: 'F001-7',
      comprobanteFechaEmision: '2026-11-10',
      comprobanteTotal: '1180.00',
      importeOperacion: importe,
      fechaOperacion: '2026-11-13',
    );

    test('stores the amount perceived as its total', () async {
      final p001 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('P001'))).getSingle();
      final id = await service.emit(
        company: company,
        serie: p001,
        draft: draft(),
      );

      final stored = await document(id);
      expect(stored.tipoComprobante, '40');
      expect(stored.total, '23.60');
      final spec = (jsonDecode(bridge.builtJson.single) as Map)['spec'] as Map;
      expect(spec['serie'], 'P001');
      expect(spec['numero'], 1);
    });

    test('needs a RUC and an amount up to the factura total', () async {
      final p001 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('P001'))).getSingle();
      for (final (invalid, problem) in [
        (draft(customer: anonymousCustomer), DraftProblem.customerWithoutRuc),
        (draft(importe: '1180.01'), DraftProblem.operacionOverTotal),
        (draft(importe: '0'), DraftProblem.operacionOverTotal),
      ]) {
        await expectLater(
          service.emit(company: company, serie: p001, draft: invalid),
          throwsA(
            isA<InvalidDraftError>().having(
              (e) => e.problem,
              'problem',
              problem,
            ),
          ),
        );
      }
      expect(await database.select(database.documents).get(), isEmpty);
    });
  });

  group('guías de remisión', () {
    const point = (
      ubigeo: '150101',
      direccion: 'AV. ABANCAY 123',
      codigoLocal: null,
    );
    DespatchAdviceDraft guia({bool vehiculoM1L = true}) => DespatchAdviceDraft(
      customer: _rucCustomer,
      lines: _draft.lines,
      motivo: '01',
      fechaTraslado: peruToday(),
      pesoTotal: '2',
      modalidad: ModalidadTraslado.privado,
      vehiculoM1L: vehiculoM1L,
      partida: point,
      llegada: point,
    );

    Future<Serie> t001() => (database.select(
      database.series,
    )..where((s) => s.serie.equals('T001'))).getSingle();

    test('in test mode they are signed, not sent', () async {
      final id = await service.emit(
        company: company,
        serie: await t001(),
        draft: guia(),
      );

      expect(await service.send(id), DocumentStatus.accepted);
      expect((await document(id)).sunatCode, LocalCodes.betaGuia);
      expect((await document(id)).total, '0.00');
      expect(bridge.calls, isEmpty);
    });

    test('production needs the GRE credentials', () async {
      await SecureStore().writeCompanySecrets(company.id, {
        CompanySecret.certificate: base64Encode([1]),
        CompanySecret.solUsername: '20123456789USUARIO',
        CompanySecret.solPassword: 'clave',
      });
      company = company.copyWith(sunatEnvironment: SunatEnvironment.production);
      final id = await service.emit(
        company: company,
        serie: await t001(),
        draft: guia(),
      );

      expect(await service.send(id), DocumentStatus.exception);
      expect((await document(id)).sunatCode, LocalCodes.noGreCredentials);
      expect(bridge.calls, isEmpty);
    });

    test('need the vehicle and driver, or a car', () async {
      await expectLater(
        service.emit(
          company: company,
          serie: await t001(),
          draft: guia(vehiculoM1L: false),
        ),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.missingTransport,
          ),
        ),
      );
    });
  });

  group('voiding', () {
    const acceptedAnswer = SunatResponse(
      status: SunatStatus.accepted,
      code: '0',
      notes: [],
    );
    const ticket = SunatResponse(
      status: SunatStatus.inProgress,
      ticket: '1794627043358',
      notes: [],
    );

    Future<String> acceptedDocument({InvoiceDraft draft = _draft}) async {
      final serie =
          await (database.select(database.series)..where(
                (s) => s.serie.equals(
                  draft.tipoComprobante == '01' ? 'F001' : 'B001',
                ),
              ))
              .getSingle();
      final id = await service.emit(
        company: company,
        serie: serie,
        draft: draft,
      );
      bridge.responses.add(acceptedAnswer);
      await service.send(id);
      return id;
    }

    Future<String> productionFactura() async {
      await SecureStore().writeCompanySecrets(company.id, {
        CompanySecret.certificate: base64Encode([1]),
        CompanySecret.solUsername: '20123456789USUARIO',
        CompanySecret.solPassword: 'clave',
      });
      await (database.update(
        database.companies,
      )..where((c) => c.id.equals(company.id))).write(
        const CompaniesCompanion(
          sunatEnvironment: Value(SunatEnvironment.production),
        ),
      );
      company = company.copyWith(sunatEnvironment: SunatEnvironment.production);
      return acceptedDocument();
    }

    test('a factura is voided with a comunicación de baja', () async {
      final factura = await acceptedDocument();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');

      final voiding = await document(voidingId);
      expect(voiding.tipoComprobante, 'RA');
      expect(voiding.serie, 'RA-${peruToday().replaceAll('-', '')}');
      expect(voiding.numero, 1);
      expect(voiding.affectedDocumentId, factura);
      final spec = (jsonDecode(voiding.inputJson) as Map)['spec'] as Map;
      expect((spec['comprobantes'] as List).single, {
        'tipo_comprobante': '01',
        'serie': 'F001',
        'numero': 1,
        'descripcion_sustento': 'Error',
      });
      final voided = await document(factura);
      expect(voided.status, DocumentStatus.voiding);
      expect(voided.voidedByDocumentId, voidingId);

      // Numbered per day
      final other = await service.voidDocument(
        await acceptedDocument(),
        motivo: 'Error',
      );
      expect((await document(other)).numero, 2);
    });

    test('a boleta is voided with a resumen diario', () async {
      final boleta = await acceptedDocument(
        draft: const InvoiceDraft(
          tipoComprobante: '03',
          moneda: 'PEN',
          customer: anonymousCustomer,
          lines: [DraftLine(descripcion: 'Café', cantidad: '1', precio: '5')],
        ),
      );
      final voiding = await document(
        await service.voidDocument(boleta, motivo: 'Venta cancelada'),
      );

      expect(voiding.tipoComprobante, 'RC');
      final spec = (jsonDecode(voiding.inputJson) as Map)['spec'] as Map;
      final item = (spec['comprobantes'] as List).single as Map;
      expect(item['tipo_operacion'], '3');
      expect((item['comprobante'] as Map)['serie_numero'], 'B001-1');
    });

    test('in test mode, the ticket voids the document', () async {
      final factura = await acceptedDocument();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');
      bridge.responses.add(ticket);

      expect(await service.send(voidingId), DocumentStatus.accepted);
      expect((await document(voidingId)).sunatCode, LocalCodes.betaTicket);
      final voided = await document(factura);
      expect(voided.status, DocumentStatus.voided);
      expect(voided.voidedByDocumentId, voidingId);
    });

    test('a rejected voiding leaves the document accepted', () async {
      final factura = await productionFactura();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');
      bridge.responses.add(ticket);
      expect(await service.send(voidingId), DocumentStatus.inProgress);
      expect((await document(factura)).status, DocumentStatus.voiding);

      bridge.responses.add(
        const SunatResponse(
          status: SunatStatus.rejected,
          code: '2375',
          notes: [],
        ),
      );
      await due(voidingId);
      expect(await service.send(voidingId), DocumentStatus.rejected);
      expect(bridge.calls.last, 'verify 1794627043358');
      final document_ = await document(factura);
      expect(document_.status, DocumentStatus.accepted);
      expect(document_.voidedByDocumentId, isNull);
    });

    test('only accepted documents, within 7 days', () async {
      final pending = await emit();
      await expectLater(
        service.voidDocument(pending, motivo: 'Error'),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.notVoidable,
          ),
        ),
      );

      final old = await acceptedDocument();
      await (database.update(database.documents)
            ..where((d) => d.id.equals(old)))
          .write(const DocumentsCompanion(fechaEmision: Value('2020-01-01')));
      await expectLater(
        service.voidDocument(old, motivo: 'Error'),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.voidingTooLate,
          ),
        ),
      );
    });

    test('a voiding SUNAT already has keeps the document voiding', () async {
      final factura = await productionFactura();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');
      bridge.responses.add(
        const SunatResponse(
          status: SunatStatus.rejected,
          code: '2324',
          notes: [],
        ),
      );

      expect(await service.send(voidingId), DocumentStatus.rejected);
      expect((await document(factura)).status, DocumentStatus.voiding);
    });

    test('a reversión SUNAT already has keeps the document voiding', () async {
      final factura = await productionFactura();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');
      bridge.responses.add(
        const SunatResponse(
          status: SunatStatus.rejected,
          code: '2751',
          notes: [],
        ),
      );

      await service.send(voidingId);
      expect((await document(factura)).status, DocumentStatus.voiding);
    });

    test('a voiding SUNAT did not process can be sent again', () async {
      final factura = await productionFactura();
      final voidingId = await service.voidDocument(factura, motivo: 'Error');
      bridge.responses.addAll([
        const SunatResponse(
          status: SunatStatus.exception,
          code: '0151',
          notes: [],
        ),
        ticket,
        acceptedAnswer,
      ]);
      expect(await service.send(voidingId), DocumentStatus.exception);
      expect((await document(factura)).status, DocumentStatus.voiding);

      expect(
        await service.send(voidingId, manual: true),
        DocumentStatus.inProgress,
      );
      await due(voidingId);
      expect(await service.send(voidingId), DocumentStatus.accepted);
      expect((await document(factura)).status, DocumentStatus.voided);
    });

    test('a percepción is voided with a reversión', () async {
      final p001 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('P001'))).getSingle();
      final id = await service.emit(
        company: company,
        serie: p001,
        draft: const PerceptionRetentionDraft(
          tipoComprobante: '40',
          customer: _rucCustomer,
          tipoRegimen: '01',
          comprobanteSerieNumero: 'F001-7',
          comprobanteFechaEmision: '2026-11-10',
          comprobanteTotal: '100',
          importeOperacion: '100',
          fechaOperacion: '2026-11-13',
        ),
      );
      bridge.responses.add(acceptedAnswer);
      await service.send(id);

      final voiding = await document(
        await service.voidDocument(id, motivo: 'Error'),
      );
      expect(voiding.tipoComprobante, 'RR');
      expect((jsonDecode(voiding.inputJson) as Map)['kind'], 'Reversion');
    });

    test('an invoice with live notas is voided after them', () async {
      final factura = await acceptedDocument();
      final fc01 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('FC01'))).getSingle();
      final note = await service.emit(
        company: company,
        serie: fc01,
        draft: NoteDraft(
          tipoComprobante: '07',
          affected: await document(factura),
          tipoNota: '01',
          sustento: 'Anulación',
          customer: _draft.customer,
          lines: _draft.lines,
        ),
      );
      await expectLater(
        service.voidDocument(factura, motivo: 'Error'),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.voidNotesFirst,
          ),
        ),
      );

      await (database.update(
        database.documents,
      )..where((d) => d.id.equals(note))).write(
        const DocumentsCompanion(status: Value(DocumentStatus.rejected)),
      );
      await service.voidDocument(factura, motivo: 'Error');
    });

    test('a nota checks the invoice as it is now', () async {
      final factura = await document(await acceptedDocument());
      await service.voidDocument(factura.id, motivo: 'Error');
      final fc01 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('FC01'))).getSingle();

      await expectLater(
        service.emit(
          company: company,
          serie: fc01,
          draft: NoteDraft(
            tipoComprobante: '07',
            affected: factura, // read before it was voided
            tipoNota: '01',
            sustento: 'Anulación',
            customer: _draft.customer,
            lines: _draft.lines,
          ),
        ),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.invalidAffectedDocument,
          ),
        ),
      );
    });

    test('only type 13 carries cuotas, and of a factura al crédito', () async {
      final contado = await document(await acceptedDocument());
      final fc01 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('FC01'))).getSingle();
      const cuotas = [DraftCuota(importe: '50.00', fechaPago: '2099-01-20')];
      for (final (tipoNota, cuotas) in [
        (ajusteMontosYFechasDePago, cuotas), // of a factura al contado
        (ajusteMontosYFechasDePago, const <DraftCuota>[]),
        ('01', cuotas),
      ]) {
        await expectLater(
          service.emit(
            company: company,
            serie: fc01,
            draft: NoteDraft(
              tipoComprobante: '07',
              affected: contado,
              tipoNota: tipoNota,
              sustento: 'Ajuste',
              customer: _draft.customer,
              lines: _draft.lines,
              cuotas: cuotas,
            ),
          ),
          throwsA(
            isA<InvalidDraftError>().having(
              (e) => e.problem,
              'problem',
              DraftProblem.invalidAjuste,
            ),
          ),
          reason: tipoNota,
        );
      }
    });

    test('an accepted nota does not void the document it modifies', () async {
      final factura = await acceptedDocument();
      final fc01 = await (database.select(
        database.series,
      )..where((s) => s.serie.equals('FC01'))).getSingle();
      final note = await service.emit(
        company: company,
        serie: fc01,
        draft: NoteDraft(
          tipoComprobante: '07',
          affected: await document(factura),
          tipoNota: '01',
          sustento: 'Anulación',
          customer: _draft.customer,
          lines: _draft.lines,
        ),
      );
      // Only reachable with a rejected nota sent again by hand
      Future<void> setStatus(DocumentStatus status) =>
          (database.update(database.documents)..where((d) => d.id.equals(note)))
              .write(DocumentsCompanion(status: Value(status)));
      await setStatus(DocumentStatus.rejected);
      await service.voidDocument(factura, motivo: 'Error');
      await setStatus(DocumentStatus.pendingSend);
      bridge.responses.add(acceptedAnswer);
      await service.send(note);

      expect((await document(factura)).status, DocumentStatus.voiding);
    });
  });

  group('notas', () {
    Future<Document> acceptedFactura() async {
      final id = await emit();
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );
      await service.send(id);
      return document(id);
    }

    Future<Serie> serieNamed(String serie) => (database.select(
      database.series,
    )..where((s) => s.serie.equals(serie))).getSingle();

    NoteDraft credit(Document affected) => NoteDraft(
      tipoComprobante: '07',
      affected: affected,
      tipoNota: '07',
      sustento: 'Devolución',
      customer: _draft.customer,
      lines: _draft.lines,
    );

    Matcher problem(DraftProblem problem) => throwsA(
      isA<InvalidDraftError>().having((e) => e.problem, 'problem', problem),
    );

    test('notas de crédito credit at most the invoice total', () async {
      final factura = await acceptedFactura();
      final fc01 = await serieNamed('FC01');
      // The fake bridge totals 118, the factura's whole total
      final first = await service.emit(
        company: company,
        serie: fc01,
        draft: credit(factura),
      );
      await expectLater(
        service.emit(company: company, serie: fc01, draft: credit(factura)),
        problem(DraftProblem.noteExceedsInvoice),
      );

      // A rejected nota credits nothing
      await (database.update(
        database.documents,
      )..where((d) => d.id.equals(first))).write(
        const DocumentsCompanion(status: Value(DocumentStatus.rejected)),
      );
      await service.emit(company: company, serie: fc01, draft: credit(factura));
    });

    test('notas modify accepted invoices of the same environment', () async {
      final pending = await document(await emit());
      final fc01 = await serieNamed('FC01');
      await expectLater(
        service.emit(company: company, serie: fc01, draft: credit(pending)),
        problem(DraftProblem.invalidAffectedDocument),
      );

      final factura = await acceptedFactura();
      await expectLater(
        service.emit(
          company: company.copyWith(
            sunatEnvironment: SunatEnvironment.production,
          ),
          serie: fc01,
          draft: credit(factura),
        ),
        problem(DraftProblem.invalidAffectedDocument),
      );
      await expectLater(
        service.emit(
          company: company,
          serie: await serieNamed('BC01'),
          draft: credit(factura),
        ),
        problem(DraftProblem.noteSerieMismatch),
      );
    });

    test('a nota de crédito points to the invoice it modifies', () async {
      final factura = await acceptedFactura();
      final note = await service.emit(
        company: company,
        serie: await serieNamed('FC01'),
        draft: NoteDraft(
          tipoComprobante: '07',
          affected: factura,
          tipoNota: '01',
          sustento: 'Anulación de la operación',
          customer: _draft.customer,
          lines: _draft.lines,
        ),
      );

      final stored = await document(note);
      expect(stored.serie, 'FC01');
      expect(stored.affectedDocumentId, factura.id);
      final spec = (jsonDecode(bridge.builtJson.last) as Map)['spec'] as Map;
      expect(spec['comprobante_afectado_serie_numero'], 'F001-1');
    });

    test('notas of facturas use F series', () async {
      final factura = await acceptedFactura();
      await expectLater(
        service.emit(
          company: company,
          serie: await serieNamed('BC01'),
          draft: NoteDraft(
            tipoComprobante: '07',
            affected: factura,
            tipoNota: '01',
            sustento: 'x',
            customer: _draft.customer,
            lines: _draft.lines,
          ),
        ),
        throwsA(
          isA<InvalidDraftError>().having(
            (e) => e.problem,
            'problem',
            DraftProblem.noteSerieMismatch,
          ),
        ),
      );
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
