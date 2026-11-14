import 'dart:convert';

import '../../data/database.dart';
import '../document/document_service.dart';
import '../document/invoice_draft.dart';

/// Where goods leave from or arrive at
typedef GuiaPoint = ({String ubigeo, String direccion, String? codigoLocal});

/// Catalog 18
abstract final class ModalidadTraslado {
  static const publico = '01';
  static const privado = '02';
}

/// SUNAT's indicator of a transfer in an M1 or L vehicle (cars, motorbikes),
/// which needs no vehicle or driver data
const indicadorVehiculoM1L = 'SUNAT_Envio_IndicadorTrasladoVehiculoM1L';

/// A guía de remisión remitente ("09"): the company moves goods it sends
/// (docs/DESIGN.md §6)
class DespatchAdviceDraft implements DocumentDraft {
  const DespatchAdviceDraft({
    required this.customer,
    required this.lines,
    required this.motivo,
    required this.fechaTraslado,
    required this.pesoTotal,
    required this.modalidad,
    required this.partida,
    required this.llegada,
    this.motivoDescripcion,
    this.numeroBultos,
    this.vehiculoM1L = false,
    this.vehicle,
    this.driver,
    this.transportista,
    this.transportistaMtc,
    this.related,
    this.observaciones,
  });

  /// The destinatario
  @override
  final DraftCustomer customer;

  /// What moves; only the description, quantity, unit and code are used
  final List<DraftLine> lines;

  /// Catalog 20, e.g. "01" venta; "13" otros needs [motivoDescripcion]
  final String motivo;
  final String? motivoDescripcion;
  final String fechaTraslado;

  /// Gross weight in kilograms
  final String pesoTotal;
  final int? numeroBultos;

  /// [ModalidadTraslado]
  final String modalidad;

  /// Transporte privado in a car or motorbike
  final bool vehiculoM1L;
  final Vehicle? vehicle;
  final Driver? driver;

  /// The carrier of transporte público, with a RUC
  final DraftCustomer? transportista;

  /// The carrier's registration at the MTC
  final String? transportistaMtc;
  final GuiaPoint? partida;
  final GuiaPoint? llegada;

  /// The factura or boleta of the goods
  final Document? related;
  final String? observaciones;

  @override
  String get tipoComprobante => '09';

  /// Guías have no amounts
  @override
  String get moneda => 'PEN';

  @override
  String? get affectedDocumentId => related?.id;

  bool get _isPrivado => modalidad == ModalidadTraslado.privado;

  @override
  DraftProblem? get problem {
    if (lines.isEmpty) return DraftProblem.noLines;
    if (customer.isAnonymous) return DraftProblem.anonymousDestinatario;
    if (partida == null || llegada == null) {
      return DraftProblem.missingAddresses;
    }
    if (motivo == '04' &&
        (partida?.codigoLocal == null || llegada?.codigoLocal == null)) {
      return DraftProblem.missingCodigoLocal;
    }
    final hasTransport = _isPrivado
        ? vehiculoM1L || (vehicle != null && driver != null)
        : transportista?.tipoDocumentoIdentidad == '6';
    if (!hasTransport) return DraftProblem.missingTransport;
    if (motivo == '13' && (motivoDescripcion ?? '').isEmpty) {
      return DraftProblem.missingMotivo;
    }
    return null;
  }

  @override
  String totalOf(Map<String, Object?> enrichedSpec) => '0';

  Map<String, Object?> _point(GuiaPoint point, Company company) => {
    'ubigeo': point.ubigeo,
    'direccion': point.direccion,
    if (point.codigoLocal != null) ...{
      'codigo_local': point.codigoLocal,
      'ruc': company.ruc,
    },
  };

  @override
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  }) {
    final related = this.related;
    final vehicle = this.vehicle;
    final driver = this.driver;
    final transportista = this.transportista;
    return jsonEncode({
      'kind': 'DespatchAdvice',
      'spec': {
        'serie_numero': serieNumero,
        'fecha_emision': fechaEmision,
        'tipo_comprobante': tipoComprobante,
        'observaciones': ?observaciones,
        if (related != null)
          'documentos_adicionales': [
            {
              // Catalog 61, the same codes as catalog 1 for these
              'tipo_documento': related.tipoComprobante,
              'numero': '${related.serie}-${related.numero}',
              'ruc_emisor': company.ruc,
            },
          ],
        'remitente': {'ruc': company.ruc, 'razon_social': company.razonSocial},
        'destinatario': {
          'tipo_documento_identidad': customer.tipoDocumentoIdentidad,
          'numero_documento_identidad': customer.numeroDocumentoIdentidad,
          'nombre': customer.nombre,
        },
        'envio': {
          'tipo_traslado': motivo,
          'motivo_traslado': ?motivoDescripcion,
          'peso_total': pesoTotal,
          'peso_total_unidad_medida': 'KGM',
          'numero_bultos': ?numeroBultos,
          'indicadores': [if (_isPrivado && vehiculoM1L) indicadorVehiculoM1L],
          'tipo_modalidad_traslado': modalidad,
          'fecha_traslado': fechaTraslado,
          if (!_isPrivado && transportista != null)
            'transportista': {
              'tipo_documento_identidad': transportista.tipoDocumentoIdentidad,
              'numero_documento_identidad':
                  transportista.numeroDocumentoIdentidad,
              'nombre': transportista.nombre,
              'numero_registro_mtc': ?transportistaMtc,
            },
          if (_isPrivado && !vehiculoM1L && driver != null)
            'choferes': [
              {
                'tipo': 'Principal',
                'tipo_documento_identidad': driver.tipoDocumentoIdentidad,
                'numero_documento_identidad': driver.numeroDocumentoIdentidad,
                'nombres': driver.nombres,
                'apellidos': driver.apellidos,
                'licencia': driver.licencia,
              },
            ],
          if (_isPrivado && !vehiculoM1L && vehicle != null)
            'vehiculo': {
              'placa': vehicle.placa,
              'numero_circulacion': ?vehicle.numeroCirculacion,
            },
          if (partida case final partida?) 'partida': _point(partida, company),
          if (llegada case final llegada?) 'destino': _point(llegada, company),
        },
        'detalles': [
          for (final (index, line) in lines.indexed)
            {
              'unidad_medida': line.unidadMedida,
              'cantidad': line.cantidad,
              'descripcion': line.descripcion,
              // SUNAT asks for a code; free lines get their position
              'codigo': line.codigo ?? '${index + 1}',
              'codigo_sunat': ?line.codigoSunat,
            },
        ],
      },
    });
  }
}
