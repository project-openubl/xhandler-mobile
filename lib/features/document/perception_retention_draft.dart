import 'dart:convert';

import '../../amount_text.dart';
import '../../data/database.dart';
import 'draft_problem.dart';
import 'invoice_draft.dart';

/// Percent of each régimen de percepción (catalog 22)
const tasasPercepcion = {'01': '2', '02': '1', '03': '0.5'};

/// Percent of each régimen de retención (catalog 23)
const tasasRetencion = {'01': '3'};

/// A comprobante de percepción ("40", charged to a customer paying a
/// factura) or retención ("20", withheld from a supplier's factura): one
/// collection or payment of one factura in soles (the document's amounts
/// are always in soles; facturas in other currencies need an exchange rate,
/// not supported yet)
/// (docs/DESIGN.md §6)
class PerceptionRetentionDraft implements DocumentDraft {
  const PerceptionRetentionDraft({
    required this.tipoComprobante,
    required this.customer,
    required this.tipoRegimen,
    required this.comprobanteSerieNumero,
    required this.comprobanteFechaEmision,
    required this.comprobanteTotal,
    required this.importeOperacion,
    required this.fechaOperacion,
    this.observaciones,
  }) : assert(tipoComprobante == '40' || tipoComprobante == '20');

  @override
  final String tipoComprobante;

  /// The customer (percepción) or supplier (retención), with a RUC
  @override
  final DraftCustomer customer;

  /// Catalog 22 (percepción) or 23 (retención)
  final String tipoRegimen;

  /// The factura collected or paid: "F001-1"
  final String comprobanteSerieNumero;
  final String comprobanteFechaEmision;
  final String comprobanteTotal;

  /// What was collected or paid of the factura, and when
  final String importeOperacion;
  final String fechaOperacion;
  final String? observaciones;

  bool get isPercepcion => tipoComprobante == '40';

  String get porcentaje =>
      (isPercepcion ? tasasPercepcion : tasasRetencion)[tipoRegimen]!;

  /// The amount perceived or withheld, rounded half up to cents
  String get importe {
    final percentCents = toCents(porcentaje);
    final cents =
        (toCents(importeOperacion) * percentCents + BigInt.from(5000)) ~/
        BigInt.from(10000);
    return fromCents(cents);
  }

  /// What the customer pays in total (percepción) or the supplier receives
  /// (retención)
  String get importeNeto {
    final operacion = toCents(importeOperacion);
    final amount = toCents(importe);
    return fromCents(isPercepcion ? operacion + amount : operacion - amount);
  }

  @override
  String get moneda => 'PEN';

  @override
  String? get tipoCambio => null;

  @override
  String? get affectedDocumentId => null;

  @override
  DraftProblem? get problem {
    if (customer.tipoDocumentoIdentidad != '6') {
      return DraftProblem.customerWithoutRuc;
    }
    final operacion = toCents(importeOperacion);
    if (operacion <= BigInt.zero || operacion > toCents(comprobanteTotal)) {
      return DraftProblem.operacionOverTotal;
    }
    return null;
  }

  @override
  String totalOf(Map<String, Object?> enrichedSpec) => importe;

  @override
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  }) {
    final separator = serieNumero.lastIndexOf('-');
    return jsonEncode({
      'kind': isPercepcion ? 'Perception' : 'Retention',
      'spec': {
        'serie': serieNumero.substring(0, separator),
        'numero': int.parse(serieNumero.substring(separator + 1)),
        'fecha_emision': fechaEmision,
        'moneda': moneda,
        'proveedor': proveedorJson(company),
        'cliente': customer.toJson(),
        'tipo_regimen': tipoRegimen,
        'tipo_regimen_porcentaje': porcentaje,
        if (isPercepcion) ...{
          'importe_total_percibido': importe,
          'importe_total_cobrado': importeNeto,
        } else ...{
          'importe_total_retenido': importe,
          'importe_total_pagado': importeNeto,
        },
        'observaciones': ?observaciones,
        'operacion': {
          'numero_operacion': 1,
          'fecha_operacion': fechaOperacion,
          // SUNAT takes 2 decimals
          'importe_operacion': fromCents(toCents(importeOperacion)),
          'comprobante_afectado': {
            'tipo_comprobante': '01',
            'serie_numero': comprobanteSerieNumero,
            'fecha_emision': comprobanteFechaEmision,
            'importe_total': fromCents(toCents(comprobanteTotal)),
            'moneda': moneda,
          },
        },
      },
    });
  }
}
