import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/deadlines.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

void main() {
  Document document(String tipo, String serie) => Document(
    id: 'id',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
    companyId: 'company',
    environment: SunatEnvironment.production,
    tipoComprobante: tipo,
    serie: serie,
    numero: 1,
    fechaEmision: '2026-11-28',
    clienteTipoDocumento: '6',
    clienteNumeroDocumento: '20100070970',
    clienteNombre: 'Cliente',
    moneda: 'PEN',
    total: '118.00',
    status: DocumentStatus.pendingSend,
    digestValue: 'hash',
    attempts: 0,
    inputJson: '{}',
    enrichedJson: '{}',
    deviceId: 'device',
  );

  test('facturas and their notas have 3 days, boletas and theirs 7', () {
    expect(sendingDeadline(document('01', 'F001')), '2026-12-01');
    expect(sendingDeadline(document('07', 'FC01')), '2026-12-01');
    expect(sendingDeadline(document('03', 'B001')), '2026-12-05');
    expect(sendingDeadline(document('08', 'BD01')), '2026-12-05');
    expect(sendingDeadline(document('09', 'T001')), isNull);
  });

  test('the last day still counts, across months and years', () {
    final factura = document('01', 'F001');
    expect(pastSendingDeadline(factura, '2026-12-01'), isFalse);
    expect(pastSendingDeadline(factura, '2026-12-02'), isTrue);
    final boleta = document('03', 'B001');
    expect(pastSendingDeadline(boleta, '2026-12-05'), isFalse);
    expect(pastSendingDeadline(boleta, '2026-12-06'), isTrue);
    expect(
      sendingDeadline(factura.copyWith(fechaEmision: '2026-12-30')),
      '2027-01-02',
    );
    expect(pastSendingDeadline(document('20', 'R001'), '2030-01-01'), isFalse);
  });
}
