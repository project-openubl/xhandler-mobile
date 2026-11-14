import 'dart:convert';

import 'package:flutter/services.dart';

import '../../peru_date.dart';
import '../../src/rust/api/document.dart';
import '../../src/rust/api/signer.dart';

/// Invoice of SUNAT's demo certificate owner, to check the whole chain
abstract final class SampleInvoice {
  static const ruc = '10467793549';
  static const certificateAsset = 'assets/demo/certificado_demo.pfx';
  static const certificatePassword = 'password';

  /// A number that doesn't repeat for years, so SUNAT beta never answers
  /// "registered previously"
  static String serieNumero(DateTime now) =>
      'F001-${1 + (now.millisecondsSinceEpoch ~/ 1000) % 99999999}';

  static String json(DateTime now) => jsonEncode({
    'kind': 'Invoice',
    'spec': {
      'serie_numero': serieNumero(now),
      'proveedor': {'ruc': ruc, 'razon_social': 'Empresa de prueba'},
      'cliente': {
        'nombre': 'Cliente de prueba',
        'numero_documento_identidad': '20123456789',
        'tipo_documento_identidad': '6',
      },
      'detalles': [
        {'descripcion': 'Producto de prueba', 'cantidad': 1, 'precio': 100},
      ],
    },
  });

  static Future<SignedDocument> buildAndSign() async {
    final now = DateTime.now();
    final built = await buildDocument(
      documentJson: json(now),
      defaults: DocumentDefaults(
        igvTasa: '0.18',
        icbTasa: '0.50',
        ivapTasa: '0.04',
        fechaEmision: peruToday(now),
      ),
    );
    final certificate = await rootBundle.load(certificateAsset);
    return signDocument(
      xml: built.xml,
      certificate: certificate.buffer.asUint8List(),
      password: certificatePassword,
    );
  }
}
