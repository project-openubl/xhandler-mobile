import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/despatch/despatch_advice_draft.dart';
import 'package:xhandler_mobile/features/document/draft_problem.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/perception_retention_draft.dart';
import 'package:xhandler_mobile/features/document/voiding.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

/// The JSON the app sends to xbuilder. The same files are built by the Rust
/// bridge's tests (rust/src/api/document.rs), so both sides agree on it.
/// `UPDATE_GOLDEN=true flutter test` rewrites them.
const _drafts = 'rust/tests/resources/drafts';

final _company = Company(
  id: '1',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  ruc: '20123456789',
  razonSocial: 'Empresa S.A.C.',
  nombreComercial: 'Empresa',
  direccion: 'AV. LARCO 123',
  distrito: 'MIRAFLORES',
  provincia: 'LIMA',
  departamento: 'LIMA',
  ubigeo: '150122',
  codigoLocal: '0000',
  sunatEnvironment: SunatEnvironment.beta,
  moneda: 'PEN',
  igvTipo: '10',
  esAgentePercepcion: false,
  esAgenteRetencion: false,
  lookupProvider: LookupProvider.none,
);

void main() {
  void expectGoldenJson(String name, String document) {
    final json = const JsonEncoder.withIndent('  ')
        .convert(jsonDecode(document));
    final file = File('$_drafts/$name.json');
    if (Platform.environment['UPDATE_GOLDEN'] == 'true') {
      file.writeAsStringSync('$json\n');
    }
    expect(json, file.readAsStringSync().trim());
  }

  void expectGolden(String name, DocumentDraft draft, String serieNumero) =>
      expectGoldenJson(
        name,
        draft.toDocumentJson(
          company: _company,
          serieNumero: serieNumero,
          fechaEmision: '2026-11-13',
        ),
      );

  test('factura, payment in full, with a bag and ISC', () {
    expectGolden(
      'factura_contado',
      const InvoiceDraft(
        tipoComprobante: '01',
        moneda: 'PEN',
        customer: DraftCustomer(
          tipoDocumentoIdentidad: '6',
          numeroDocumentoIdentidad: '20100070970',
          nombre: 'SUPERMERCADOS PERUANOS S.A.',
          direccion: 'CAL. MORELLI 181',
          distrito: 'SAN BORJA',
          provincia: 'LIMA',
          departamento: 'LIMA',
          ubigeo: '150130',
          email: 'compras@example.com',
        ),
        lines: [
          DraftLine(
            descripcion: 'Cerveza',
            cantidad: '6',
            precio: '7.50',
            codigo: 'CER-01',
            codigoSunat: '50202201',
            iscTipo: '01',
            iscTasa: '30',
          ),
          DraftLine(
            descripcion: 'Bolsa plástica',
            cantidad: '1',
            precio: '0.10',
            esBolsa: true,
          ),
        ],
      ),
      'F001-1',
    );
  });

  test('boleta in installments, prices without IGV', () {
    expectGolden(
      'boleta_credito',
      const InvoiceDraft(
        tipoComprobante: '03',
        moneda: 'USD',
        customer: DraftCustomer(
          tipoDocumentoIdentidad: '1',
          numeroDocumentoIdentidad: '46027897',
          nombre: 'JUANA PEREZ',
        ),
        lines: [
          DraftLine(
            descripcion: 'Servicio de consultoría',
            cantidad: '1',
            precio: '1000',
            precioIncluyeIgv: false,
            unidadMedida: 'ZZ',
          ),
        ],
        cuotas: [
          DraftCuota(importe: '590', fechaPago: '2026-12-13'),
          DraftCuota(importe: '590', fechaPago: '2027-01-13'),
        ],
      ),
      'B001-25',
    );
  });

  test('exonerated sale to an anonymous customer', () {
    expectGolden(
      'boleta_exonerada',
      const InvoiceDraft(
        tipoComprobante: '03',
        moneda: 'PEN',
        customer: DraftCustomer(
          tipoDocumentoIdentidad: '0',
          numeroDocumentoIdentidad: '-',
          nombre: 'CLIENTES VARIOS',
        ),
        lines: [
          DraftLine(
            descripcion: 'Libro',
            cantidad: '2',
            precio: '45',
            igvTipo: '20',
          ),
        ],
      ),
      'B001-26',
    );
  });

  final factura = Document(
    id: 'f1',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
    companyId: '1',
    environment: SunatEnvironment.beta,
    tipoComprobante: '01',
    serie: 'F001',
    numero: 1,
    fechaEmision: '2026-11-13',
    clienteTipoDocumento: '6',
    clienteNumeroDocumento: '20100070970',
    clienteNombre: 'SUPERMERCADOS PERUANOS S.A.',
    moneda: 'PEN',
    total: '118.00',
    status: DocumentStatus.accepted,
    digestValue: 'hash',
    attempts: 0,
    inputJson: '{}',
    enrichedJson: '{}',
    deviceId: 'd',
  );
  const supermercados = DraftCustomer(
    tipoDocumentoIdentidad: '6',
    numeroDocumentoIdentidad: '20100070970',
    nombre: 'SUPERMERCADOS PERUANOS S.A.',
  );

  test('nota de crédito: annulment of a factura', () {
    expectGolden(
      'nota_credito_anulacion',
      NoteDraft(
        tipoComprobante: '07',
        affected: factura,
        tipoNota: '01',
        sustento: 'Anulación de la operación',
        customer: supermercados,
        lines: const [
          DraftLine(descripcion: 'Café', cantidad: '2', precio: '59.00'),
        ],
      ),
      'FC01-1',
    );
  });

  test('nota de débito: late payment interest, without IGV', () {
    expectGolden(
      'nota_debito_mora',
      NoteDraft(
        tipoComprobante: '08',
        affected: factura,
        tipoNota: '01',
        sustento: 'Intereses por mora',
        customer: supermercados,
        lines: const [
          DraftLine(
            descripcion: 'Intereses',
            cantidad: '1',
            precio: '10.00',
            unidadMedida: 'ZZ',
            // Compensation, not a sale: inafecto
            igvTipo: '30',
          ),
        ],
      ),
      'FD01-1',
    );
  });

  final boleta = factura.copyWith(
    id: 'b1',
    tipoComprobante: '03',
    serie: 'B001',
    numero: 26,
    clienteTipoDocumento: '0',
    clienteNumeroDocumento: '-',
    clienteNombre: 'CLIENTES VARIOS',
    total: '90.00',
    inputJson: File('$_drafts/boleta_exonerada.json').readAsStringSync(),
    enrichedJson: jsonEncode({
      'spec': {
        'total_impuestos': {
          'exonerado_base_imponible': '90.00',
          'exonerado_importe': '0.00',
        },
      },
    }),
  );

  test('nota de crédito of a boleta to an anonymous customer', () {
    expectGolden(
      'nota_credito_boleta',
      NoteDraft(
        tipoComprobante: '07',
        affected: boleta,
        tipoNota: '07',
        sustento: 'Devolución de un libro',
        customer: anonymousCustomer,
        lines: const [
          DraftLine(
            descripcion: 'Libro',
            cantidad: '1',
            precio: '45',
            igvTipo: '20',
          ),
        ],
      ),
      'BC01-1',
    );
  });

  String voiding(Document document, String motivo) => voidingJson(
    company: _company,
    document: document,
    motivo: motivo,
    numero: 1,
    fechaEmision: '2026-11-13',
  );

  test('comunicación de baja of a factura', () {
    expectGoldenJson('baja_factura', voiding(factura, 'Error en el precio'));
  });

  test('resumen diario voiding a boleta', () {
    expectGoldenJson(
      'resumen_anula_boleta',
      voiding(boleta, 'Venta cancelada'),
    );
  });

  test('resumen diario voiding a nota of a boleta', () {
    final note = boleta.copyWith(
      id: 'n1',
      tipoComprobante: '07',
      serie: 'BC01',
      numero: 1,
      total: '45.00',
      inputJson: File('$_drafts/nota_credito_boleta.json').readAsStringSync(),
      enrichedJson: jsonEncode({
        'spec': {
          'total_impuestos': {'exonerado_base_imponible': '45.00'},
        },
      }),
    );
    expectGoldenJson(
      'resumen_anula_nota_boleta',
      voiding(note, 'Nota emitida por error'),
    );
  });

  test('percepción of a factura collected in full', () {
    const draft = PerceptionRetentionDraft(
      tipoComprobante: '40',
      customer: supermercados,
      tipoRegimen: '01',
      comprobanteSerieNumero: 'F001-1',
      comprobanteFechaEmision: '2026-11-10',
      comprobanteTotal: '1180.00',
      importeOperacion: '1180.00',
      fechaOperacion: '2026-11-13',
    );
    expect(draft.importe, '23.60');
    expect(draft.importeNeto, '1203.60');
    expectGolden('percepcion', draft, 'P001-1');
  });

  test('retención of a supplier factura paid in part', () {
    const draft = PerceptionRetentionDraft(
      tipoComprobante: '20',
      customer: supermercados,
      tipoRegimen: '01',
      comprobanteSerieNumero: 'F002-15',
      comprobanteFechaEmision: '2026-11-10',
      comprobanteTotal: '1000.00',
      importeOperacion: '500.55',
      fechaOperacion: '2026-11-13',
      observaciones: 'Primer pago',
    );
    expect(draft.importe, '15.02'); // 15.0165, half up
    expect(draft.importeNeto, '485.53');
    expectGolden('retencion', draft, 'R001-1');
  });

  test('reversión of a percepción', () {
    final percepcion = factura.copyWith(
      id: 'p1',
      tipoComprobante: '40',
      serie: 'P001',
      numero: 3,
    );
    expectGoldenJson(
      'reversion_percepcion',
      voiding(percepcion, 'Cobro registrado por error'),
    );
  });

  final vehicle = Vehicle(
    id: 'v1',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
    companyId: '1',
    placa: 'ABC123',
    numeroCirculacion: '15M21028213E',
  );
  final driver = Driver(
    id: 'd1',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
    companyId: '1',
    tipoDocumentoIdentidad: '1',
    numeroDocumentoIdentidad: '46027897',
    nombres: 'JUAN',
    apellidos: 'PEREZ ROJAS',
    licencia: 'Q46027897',
  );
  const almacen = (
    ubigeo: '150103',
    direccion: 'AV. LOS FRUTALES 123, ATE',
    codigoLocal: null,
  );
  const tienda = (
    ubigeo: '150130',
    direccion: 'CAL. MORELLI 181, SAN BORJA',
    codigoLocal: null,
  );

  test('guía de remisión of a factura, in the company vehicle', () {
    expectGolden(
      'guia_transporte_privado',
      DespatchAdviceDraft(
        customer: supermercados,
        lines: const [
          DraftLine(
            descripcion: 'Café',
            cantidad: '2',
            precio: '59',
            codigo: 'CAF-01',
          ),
          DraftLine(descripcion: 'Taza', cantidad: '2', precio: '10'),
        ],
        motivo: '01',
        fechaTraslado: '2026-11-13',
        pesoTotal: '2.5',
        numeroBultos: 1,
        modalidad: ModalidadTraslado.privado,
        vehicle: vehicle,
        driver: driver,
        partida: almacen,
        llegada: tienda,
        related: factura,
      ),
      'T001-1',
    );
  });

  test('guía de remisión by a carrier', () {
    expectGolden(
      'guia_transporte_publico',
      const DespatchAdviceDraft(
        customer: supermercados,
        lines: [
          DraftLine(
            descripcion: 'Sacos de café',
            cantidad: '20',
            precio: '0',
            unidadMedida: 'KGM',
          ),
        ],
        motivo: '13',
        motivoDescripcion: 'Muestras para feria',
        fechaTraslado: '2026-11-14',
        pesoTotal: '20',
        modalidad: ModalidadTraslado.publico,
        transportista: DraftCustomer(
          tipoDocumentoIdentidad: '6',
          numeroDocumentoIdentidad: '20100066603',
          nombre: 'TRANSPORTES RAPIDOS S.A.C.',
        ),
        transportistaMtc: '1523456CNG',
        partida: almacen,
        llegada: tienda,
      ),
      'T001-2',
    );
  });

  test('percepción amounts go to SUNAT with 2 decimals', () {
    final json = jsonDecode(
      const PerceptionRetentionDraft(
        tipoComprobante: '40',
        customer: supermercados,
        tipoRegimen: '01',
        comprobanteSerieNumero: 'F001-1',
        comprobanteFechaEmision: '2026-11-10',
        comprobanteTotal: '1180.004',
        importeOperacion: '100.555',
        fechaOperacion: '2026-11-13',
      ).toDocumentJson(
        company: _company,
        serieNumero: 'P001-1',
        fechaEmision: '2026-11-13',
      ),
    );
    final spec = (json as Map)['spec'] as Map;
    final operacion = spec['operacion'] as Map;
    expect(operacion['importe_operacion'], '100.56');
    expect(
      (operacion['comprobante_afectado'] as Map)['importe_total'],
      '1180.00',
    );
  });

  group('guía problems', () {
    DespatchAdviceDraft guia({
      DraftCustomer customer = supermercados,
      String motivo = '01',
      GuiaPoint partida = almacen,
      GuiaPoint llegada = tienda,
    }) => DespatchAdviceDraft(
      customer: customer,
      lines: const [DraftLine(descripcion: 'Café', cantidad: '1', precio: '0')],
      motivo: motivo,
      fechaTraslado: '2026-11-13',
      pesoTotal: '1',
      modalidad: ModalidadTraslado.privado,
      vehiculoM1L: true,
      partida: partida,
      llegada: llegada,
    );

    test('an identified destinatario', () {
      expect(guia().problem, isNull);
      expect(
        guia(customer: anonymousCustomer).problem,
        DraftProblem.anonymousDestinatario,
      );
    });

    test('transfers between establishments carry their codes', () {
      expect(guia(motivo: '04').problem, DraftProblem.missingCodigoLocal);
      const local = (ubigeo: '150101', direccion: 'AV. 1', codigoLocal: '0001');
      final json = jsonDecode(
        guia(motivo: '04', partida: local, llegada: local).toDocumentJson(
          company: _company,
          serieNumero: 'T001-1',
          fechaEmision: '2026-11-13',
        ),
      );
      final envio = ((json as Map)['spec'] as Map)['envio'] as Map;
      final partida = envio['partida'] as Map;
      expect(partida['codigo_local'], '0001');
      expect(partida['ruc'], _company.ruc);
    });
  });

  test('DraftLine.fromJson reads back what toJson wrote', () {
    const line = DraftLine(
      descripcion: 'Cerveza',
      cantidad: '6',
      precio: '7.50',
      codigo: 'CER-01',
      iscTipo: '01',
      iscTasa: '30',
      esBolsa: true,
    );
    final copy = DraftLine.fromJson(line.toJson());
    expect(copy.toJson(), line.toJson());

    const exonerated = DraftLine(
      descripcion: 'Asesoría',
      cantidad: '1.5',
      precio: '200',
      precioIncluyeIgv: false,
      igvTipo: '20',
      unidadMedida: 'ZZ',
      codigoSunat: '80101500',
      iscTipo: '01',
      iscTasa: '12.5',
    );
    expect(
      DraftLine.fromJson(exonerated.toJson()).toJson(),
      exonerated.toJson(),
    );
  });

  test('DraftCustomer.fromJson reads back what toJson wrote', () {
    const customer = DraftCustomer(
      tipoDocumentoIdentidad: '6',
      numeroDocumentoIdentidad: '20100070970',
      nombre: 'SUPERMERCADOS PERUANOS S.A.',
      direccion: 'CAL. MORELLI 181',
      distrito: 'SAN BORJA',
      provincia: 'LIMA',
      departamento: 'LIMA',
      ubigeo: '150130',
      email: 'compras@example.com',
    );
    for (final original in [customer, anonymousCustomer]) {
      final copy = DraftCustomer.fromJson(original.toJson());
      expect(copy.toJson(), original.toJson());
      expect(copy.isAnonymous, original.isAnonymous);
    }
  });
}
