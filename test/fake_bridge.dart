import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/sunat_bridge.dart';
import 'package:xhandler_mobile/src/rust/api/document.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/signer.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

/// Answers like the bridge without the native library
class FakeBridge implements SunatBridge {
  /// A call without a queued response fails the test (the service would
  /// otherwise record it quietly as an exception)
  FakeBridge() {
    addTearDown(
      () => expect(
        missingResponses,
        0,
        reason: 'SUNAT calls without a queued response',
      ),
    );
  }

  var missingResponses = 0;

  SunatResponse _next() {
    if (responses.isEmpty) {
      missingResponses++;
      throw StateError('No SUNAT response queued');
    }
    return responses.removeAt(0);
  }

  final builtJson = <String>[];
  String total = '118.000000000000';
  final responses = <SunatResponse>[];
  final calls = <String>[];
  BridgeError? buildError;

  @override
  Future<BuiltDocument> build(
    String documentJson,
    DocumentDefaults defaults,
  ) async {
    if (buildError != null) throw buildError!;
    builtJson.add(documentJson);
    final spec = (jsonDecode(documentJson) as Map)['spec'] as Map;
    return BuiltDocument(
      xml: '<Invoice>${spec['serie_numero']}</Invoice>',
      enrichedJson: jsonEncode({
        'kind': 'Invoice',
        'spec': {
          ...spec,
          'total_importe': {'importe': total},
        },
      }),
    );
  }

  @override
  Future<SignedDocument> sign(
    String xml,
    Uint8List certificate,
    String password,
  ) async => SignedDocument(xml: '$xml<Signed/>', digestValue: 'hash');

  @override
  Future<SunatResponse> send(
    String xml,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) async {
    calls.add('send ${credentials.username}');
    return _next();
  }

  @override
  Future<SunatResponse> recover(
    Document document,
    String ruc,
    SunatCredentials credentials,
  ) async {
    calls.add('recover ${document.serie}-${document.numero}');
    return _next();
  }

  @override
  Future<SunatResponse> verify(
    String xml,
    String ticket,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) async {
    calls.add('verify $ticket');
    return _next();
  }
}
