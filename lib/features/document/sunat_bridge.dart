import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';

import '../../src/rust/api/document.dart';
import '../../src/rust/api/signer.dart';
import '../../src/rust/api/sunat.dart';

/// The Rust bridge calls the document flow uses, as one object so tests can
/// replace them
class SunatBridge {
  const SunatBridge();

  Future<BuiltDocument> build(String documentJson, DocumentDefaults defaults) =>
      buildDocument(documentJson: documentJson, defaults: defaults);

  Future<SignedDocument> sign(
    String xml,
    Uint8List certificate,
    String password,
  ) => signDocument(xml: xml, certificate: certificate, password: password);

  Future<SunatResponse> send(
    String xml,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) => sendDocument(
    xml: xml,
    environment: environment,
    credentials: credentials,
  );

  Future<SunatResponse> verify(
    String xml,
    String ticket,
    SunatEnvironment environment,
    SunatCredentials credentials,
  ) => verifyTicket(
    xml: xml,
    ticket: ticket,
    environment: environment,
    credentials: credentials,
  );

  /// The CDR of a document SUNAT already has (production only)
  Future<SunatResponse> recover(
    Document document,
    String ruc,
    SunatCredentials credentials,
  ) => getStatusCdr(
    ruc: ruc,
    tipoComprobante: document.tipoComprobante,
    serie: document.serie,
    numero: document.numero,
    credentials: credentials,
  );
}

final sunatBridgeProvider = Provider((ref) => const SunatBridge());
