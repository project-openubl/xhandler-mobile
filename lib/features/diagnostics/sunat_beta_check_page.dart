import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../src/rust/api/document.dart';
import '../../src/rust/api/signer.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';

/// Checks the whole chain against SUNAT beta: build, sign and send a sample
/// invoice with SUNAT's demo certificate.
class SunatBetaCheckPage extends StatefulWidget {
  const SunatBetaCheckPage({super.key});

  @override
  State<SunatBetaCheckPage> createState() => _SunatBetaCheckPageState();
}

class _SunatBetaCheckPageState extends State<SunatBetaCheckPage> {
  String? _progress;
  String? _result;

  Future<void> _run() async {
    setState(() {
      _progress = Strings.sunatBetaCheckBuilding;
      _result = null;
    });
    try {
      final signed = await buildAndSignSampleInvoice();
      setState(() => _progress = Strings.sunatBetaCheckSending);
      final response = await sendDocument(
        xml: signed.xml,
        environment: SunatEnvironment.beta,
        credentials: const SunatCredentials(
          username: '${SampleInvoice.ruc}MODDATOS',
          password: 'MODDATOS',
        ),
      );
      _result =
          '${response.status.name} ${response.code ?? ''}\n'
          '${response.description ?? ''}\n'
          'Hash: ${signed.digestValue}';
    } catch (error) {
      _result = '$error';
    }
    setState(() => _progress = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.sunatBetaCheckTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(Strings.sunatBetaCheckHelp),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _progress == null ? _run : null,
              child: const Text(Strings.sunatBetaCheckRun),
            ),
            const SizedBox(height: 16),
            if (_progress != null) Text(_progress!),
            if (_result != null) SelectableText(_result!),
          ],
        ),
      ),
    );
  }
}

/// Sample invoice of SUNAT's demo certificate owner
abstract final class SampleInvoice {
  static const ruc = '10467793549';
  static const certificateAsset = 'assets/demo/certificado_demo.pfx';
  static const certificatePassword = 'password';

  static String json(DateTime now) => jsonEncode({
    'kind': 'Invoice',
    'spec': {
      'serie_numero': 'F001-${now.millisecondsSinceEpoch % 100000000}',
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
}

Future<SignedDocument> buildAndSignSampleInvoice() async {
  final now = DateTime.now();
  final built = await buildDocument(
    documentJson: SampleInvoice.json(now),
    defaults: DocumentDefaults(
      igvTasa: '0.18',
      icbTasa: '0.50',
      ivapTasa: '0.04',
      fechaEmision: now.toIso8601String().substring(0, 10),
    ),
  );
  final certificate = await rootBundle.load(SampleInvoice.certificateAsset);
  return signDocument(
    xml: built.xml,
    certificate: certificate.buffer.asUint8List(),
    password: SampleInvoice.certificatePassword,
  );
}
