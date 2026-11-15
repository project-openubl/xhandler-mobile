import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/customer/customer_lookup.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

Company _company(LookupProvider provider) => Company(
  id: '1',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  ruc: '20123456789',
  razonSocial: 'Empresa',
  sunatEnvironment: SunatEnvironment.beta,
  moneda: 'PEN',
  igvTipo: '10',
  esAgentePercepcion: false,
  esAgenteRetencion: false,
  lookupProvider: provider,
);

void main() {
  late http.Request request;

  CustomerLookup answering(int status, Object body) => CustomerLookup(
    MockClient((r) async {
      request = r;
      final text = body is String ? body : jsonEncode(body);
      return http.Response.bytes(utf8.encode(text), status);
    }),
  );

  Future<LookupResult?> lookUp(
    CustomerLookup lookup, {
    LookupProvider provider = LookupProvider.decolecta,
    String tipo = '6',
    String numero = '20601030013',
    String? token,
  }) => lookup.lookup(
    company: _company(provider),
    secrets: CompanySecrets({CompanySecret.lookupToken: ?token}),
    tipoDocumentoIdentidad: tipo,
    numero: numero,
  );

  test('Decolecta RUC: name and address parts, "-" dropped', () async {
    final result = await lookUp(
      answering(200, {
        'razon_social': 'REXTIE S.A.C.',
        'direccion': 'AV. CANAVAL Y MOREYRA 380',
        'distrito': 'SAN ISIDRO',
        'provincia': 'LIMA',
        'departamento': 'LIMA',
        'ubigeo': '150131',
        'interior': '-',
      }),
      token: 't0k',
    );

    expect(
      request.url.toString(),
      'https://api.decolecta.com/v1/sunat/ruc?numero=20601030013',
    );
    expect(request.headers['Authorization'], 'Bearer t0k');
    expect(result?.nombre, 'REXTIE S.A.C.');
    expect(result?.distrito, 'SAN ISIDRO');
    expect(result?.ubigeo, '150131');
  });

  test('Decolecta DNI', () async {
    final result = await lookUp(
      answering(200, {'full_name': 'DELGADO HUAMANI ROXANA'}),
      tipo: '1',
      numero: '46027897',
    );
    expect(request.url.path, '/v1/reniec/dni');
    expect(result?.nombre, 'DELGADO HUAMANI ROXANA');
  });

  test('unknown numbers and answers without a name are not found', () async {
    expect(await lookUp(answering(422, {'message': 'ruc no valido'})), isNull);
    expect(await lookUp(answering(404, {})), isNull);
    expect(await lookUp(answering(200, {'razon_social': '-'})), isNull);
  });

  test('errors say whether to fix the token or wait', () async {
    Matcher kind(LookupErrorKind kind) =>
        throwsA(isA<LookupError>().having((e) => e.kind, 'kind', kind));

    expect(lookUp(answering(401, {})), kind(LookupErrorKind.authentication));
    expect(lookUp(answering(429, {})), kind(LookupErrorKind.quota));
    expect(
      lookUp(answering(400, {'error': 'Invalid request'})),
      kind(LookupErrorKind.other),
    );
    expect(lookUp(answering(200, '[1, 2]')), kind(LookupErrorKind.other));
    expect(lookUp(answering(200, 'not json')), kind(LookupErrorKind.other));
  });

  test('no service, no lookup', () async {
    expect(
      await lookUp(answering(200, {}), provider: LookupProvider.none),
      isNull,
    );
  });
}
