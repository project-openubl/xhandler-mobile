import 'package:material_ui/material_ui.dart';

import '../../src/rust/api/error.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import 'sample_invoice.dart';

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
    String result;
    try {
      final signed = await SampleInvoice.buildAndSign();
      if (!mounted) return;
      setState(() => _progress = Strings.sunatBetaCheckSending);
      final response = await sendDocument(
        xml: signed.xml,
        environment: SunatEnvironment.beta,
        credentials: const SunatCredentials(
          username: '${SampleInvoice.ruc}MODDATOS',
          password: 'MODDATOS',
        ),
      );
      result =
          '${response.status.name} ${response.code ?? ''}\n'
          '${response.description ?? ''}\n'
          'Hash: ${signed.digestValue}';
    } on BridgeError catch (error) {
      result = '${error.kind.name}: ${error.message}';
    }
    if (!mounted) return;
    setState(() {
      _progress = null;
      _result = result;
    });
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
