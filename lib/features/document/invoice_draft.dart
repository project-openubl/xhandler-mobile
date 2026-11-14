import 'dart:convert';

import '../../data/database.dart';

/// Tax rates the enrichment uses when a line doesn't set them
abstract final class TaxRates {
  static const igv = '0.18';

  /// ICBPER per plastic bag since 2023
  static const icb = '0.50';
  static const ivap = '0.04';
}

/// A line of an invoice being written
class DraftLine {
  const DraftLine({
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    this.precioIncluyeIgv = true,
    this.unidadMedida = 'NIU',
    this.igvTipo = '10',
    this.codigo,
    this.iscTipo,
    this.iscTasa,
    this.esBolsa = false,
  });

  factory DraftLine.fromProduct(Product product, {required String igvTipo}) =>
      DraftLine(
        descripcion: product.descripcion,
        cantidad: '1',
        precio: product.precio,
        precioIncluyeIgv: product.precioIncluyeIgv,
        unidadMedida: product.unidadMedida,
        igvTipo: product.igvTipo ?? igvTipo,
        codigo: product.codigo,
        iscTipo: product.iscTipo,
        iscTasa: product.iscTasa,
        esBolsa: product.esBolsa,
      );

  final String descripcion;

  /// Decimals as text, to keep them exact
  final String cantidad;
  final String precio;
  final bool precioIncluyeIgv;
  final String unidadMedida;
  final String igvTipo;
  final String? codigo;
  final String? iscTipo;
  final String? iscTasa;
  final bool esBolsa;

  DraftLine copyWith({String? cantidad, String? precio}) => DraftLine(
    descripcion: descripcion,
    cantidad: cantidad ?? this.cantidad,
    precio: precio ?? this.precio,
    precioIncluyeIgv: precioIncluyeIgv,
    unidadMedida: unidadMedida,
    igvTipo: igvTipo,
    codigo: codigo,
    iscTipo: iscTipo,
    iscTasa: iscTasa,
    esBolsa: esBolsa,
  );

  Map<String, Object?> toJson() => {
    'descripcion': descripcion,
    'cantidad': cantidad,
    'unidad_medida': unidadMedida,
    if (precioIncluyeIgv) 'precio_con_impuestos': precio else 'precio': precio,
    'igv_tipo': igvTipo,
    'codigo': ?codigo,
    'isc_tipo': ?iscTipo,
    'isc_tasa': ?iscTasa,
    'icb_aplica': esBolsa,
  };
}

/// Who the invoice is for
class DraftCustomer {
  const DraftCustomer({
    required this.tipoDocumentoIdentidad,
    required this.numeroDocumentoIdentidad,
    required this.nombre,
    this.direccion,
    this.email,
  });

  factory DraftCustomer.fromCustomer(Customer customer) => DraftCustomer(
    tipoDocumentoIdentidad: customer.tipoDocumentoIdentidad,
    numeroDocumentoIdentidad: customer.numeroDocumentoIdentidad,
    nombre: customer.nombre,
    direccion: customer.direccion,
    email: customer.email,
  );

  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String nombre;
  final String? direccion;
  final String? email;

  Map<String, Object?> toJson() => {
    'tipo_documento_identidad': tipoDocumentoIdentidad,
    'numero_documento_identidad': numeroDocumentoIdentidad,
    'nombre': nombre,
    if (direccion != null) 'direccion': {'direccion': direccion},
    if (email != null) 'contacto': {'email': email},
  };
}

/// Payment in installments ("crédito")
class DraftCuota {
  const DraftCuota({required this.importe, required this.fechaPago});

  final String importe;

  /// "YYYY-MM-DD"
  final String fechaPago;
}

/// An invoice (factura or boleta) being written
class InvoiceDraft {
  const InvoiceDraft({
    required this.tipoComprobante,
    required this.customer,
    required this.lines,
    required this.moneda,
    this.cuotas = const [],
  });

  /// Catalog 1: "01" factura, "03" boleta
  final String tipoComprobante;
  final DraftCustomer customer;
  final List<DraftLine> lines;
  final String moneda;

  /// Empty for payment in full ("contado")
  final List<DraftCuota> cuotas;

  /// The xbuilder document (`{"kind": "Invoice", "spec": {...}}`)
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  }) {
    String? text(String? value) =>
        value == null || value.isEmpty ? null : value;
    final direccion = {
      'ubigeo': text(company.ubigeo),
      'departamento': text(company.departamento),
      'provincia': text(company.provincia),
      'distrito': text(company.distrito),
      'direccion': text(company.direccion),
      'urbanizacion': text(company.urbanizacion),
      'codigo_local': text(company.codigoLocal),
    }..removeWhere((_, value) => value == null);
    final contacto = {
      'telefono': text(company.telefono),
      'email': text(company.email),
    }..removeWhere((_, value) => value == null);
    return jsonEncode({
      'kind': 'Invoice',
      'spec': {
        'serie_numero': serieNumero,
        'tipo_comprobante': tipoComprobante,
        'fecha_emision': fechaEmision,
        'moneda': moneda,
        'proveedor': {
          'ruc': company.ruc,
          'razon_social': company.razonSocial,
          'nombre_comercial': ?text(company.nombreComercial),
          if (direccion.isNotEmpty) 'direccion': direccion,
          if (contacto.isNotEmpty) 'contacto': contacto,
        },
        'cliente': customer.toJson(),
        'detalles': [for (final line in lines) line.toJson()],
        'forma_pago': cuotas.isEmpty
            ? {'tipo': 'Contado'}
            : {
                'tipo': 'Credito',
                'cuotas': [
                  for (final cuota in cuotas)
                    {'importe': cuota.importe, 'fecha_pago': cuota.fechaPago},
                ],
              },
      },
    });
  }
}
