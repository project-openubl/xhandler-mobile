import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xhandler_mobile/features/diagnostics/sample_invoice.dart';
import 'package:xhandler_mobile/src/rust/frb_generated.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());

  test('builds and signs an invoice through the Rust bridge', () async {
    final signed = await SampleInvoice.buildAndSign();

    expect(signed.xml, contains('<ds:Signature '));
    expect(signed.digestValue, isNotEmpty);
  });
}
