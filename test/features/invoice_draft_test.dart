import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
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
  void expectGolden(String name, InvoiceDraft draft, String serieNumero) {
    final json = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(
        draft.toDocumentJson(
          company: _company,
          serieNumero: serieNumero,
          fechaEmision: '2026-11-13',
        ),
      ),
    );
    final file = File('$_drafts/$name.json');
    if (Platform.environment['UPDATE_GOLDEN'] == 'true') {
      file.writeAsStringSync('$json\n');
    }
    expect(json, file.readAsStringSync().trim());
  }

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
}
