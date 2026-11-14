import 'dart:convert';

import '../../amount_text.dart';
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
    this.codigoSunat,
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
        codigoSunat: product.codigoSunat,
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
  final String? codigoSunat;
  final String? iscTipo;

  /// Percentage, e.g. "17"
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
    codigoSunat: codigoSunat,
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
    'codigo_sunat': ?codigoSunat,
    'isc_tipo': ?iscTipo,
    if (iscTasa case final tasa?) 'isc_tasa': percentToFraction(tasa),
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
    this.distrito,
    this.provincia,
    this.departamento,
    this.ubigeo,
    this.email,
  });

  factory DraftCustomer.fromCustomer(Customer customer) => DraftCustomer(
    tipoDocumentoIdentidad: customer.tipoDocumentoIdentidad,
    numeroDocumentoIdentidad: customer.numeroDocumentoIdentidad,
    nombre: customer.nombre,
    direccion: customer.direccion,
    distrito: customer.distrito,
    provincia: customer.provincia,
    departamento: customer.departamento,
    ubigeo: customer.ubigeo,
    email: customer.email,
  );

  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String nombre;
  final String? direccion;
  final String? distrito;
  final String? provincia;
  final String? departamento;
  final String? ubigeo;
  final String? email;

  /// "Clientes varios": customer type "0" with number "-"
  bool get isAnonymous =>
      tipoDocumentoIdentidad == '0' && numeroDocumentoIdentidad == '-';

  Map<String, Object?> toJson() {
    final address = {
      'direccion': ?direccion,
      'distrito': ?distrito,
      'provincia': ?provincia,
      'departamento': ?departamento,
      'ubigeo': ?ubigeo,
    };
    return {
      'tipo_documento_identidad': tipoDocumentoIdentidad,
      'numero_documento_identidad': numeroDocumentoIdentidad,
      'nombre': nombre,
      if (address.isNotEmpty) 'direccion': address,
      if (email != null) 'contacto': {'email': email},
    };
  }
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
