import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_log.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'sample_invoice.dart';

/// Checks the whole chain against SUNAT beta (build, sign and send a sample
/// invoice with SUNAT's demo certificate) and shares the error log
class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
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

  Future<void> _shareLog(BuildContext anchor) async {
    final log = AppLog.file;
    if (log == null || !log.existsSync() || log.lengthSync() == 0) {
      showMessage(anchor, Strings.noErrorLog);
      return;
    }
    final box = anchor.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(log.path, mimeType: 'text/plain')],
        fileNameOverrides: ['xhandler-errores.log'],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.diagnostics)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Strings.sunatBetaCheckTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(Strings.sunatBetaCheckHelp),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _progress == null ? _run : null,
              child: const Text(Strings.sunatBetaCheckRun),
            ),
            const SizedBox(height: 16),
            if (_progress != null) Text(_progress!),
            if (_result != null) SelectableText(_result!),
            const Divider(height: 48),
            const Text(Strings.shareErrorLogHelp),
            const SizedBox(height: 16),
            Builder(
              // Its own context anchors the share sheet on iPads
              builder: (anchor) => OutlinedButton(
                onPressed: () => _shareLog(anchor),
                child: const Text(Strings.shareErrorLog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
