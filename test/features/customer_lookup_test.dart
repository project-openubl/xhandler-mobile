import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/customer/customer_lookup.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

Company _company(LookupProvider provider, [String? url]) => Company(
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
  lookupUrl: url,
);

void main() {
  late http.Request request;

  CustomerLookup lookupAnswering(int status, Object body) => CustomerLookup(
    MockClient((r) async {
      request = r;
      return http.Response.bytes(utf8.encode(jsonEncode(body)), status);
    }),
  );

  test('Decolecta: RUC', () async {
    final lookup = lookupAnswering(200, {
      'razon_social': 'REXTIE S.A.C.',
      'direccion': 'AV. CANAVAL Y MOREYRA 380',
    });

    final result = await lookup.lookup(
      company: _company(LookupProvider.commercial),
      secrets: const CompanySecrets({CompanySecret.lookupToken: 't0k'}),
      tipoDocumentoIdentidad: '6',
      numero: '20601030013',
    );

    expect(
      request.url.toString(),
      'https://api.decolecta.com/v1/sunat/ruc?numero=20601030013',
    );
    expect(request.headers['Authorization'], 'Bearer t0k');
    expect(result?.nombre, 'REXTIE S.A.C.');
    expect(result?.direccion, 'AV. CANAVAL Y MOREYRA 380');
  });

  test('Decolecta: DNI, and unknown numbers', () async {
    var lookup = lookupAnswering(200, {'full_name': 'DELGADO HUAMANI ROXANA'});
    final result = await lookup.lookup(
      company: _company(LookupProvider.commercial),
      secrets: const CompanySecrets({}),
      tipoDocumentoIdentidad: '1',
      numero: '46027897',
    );
    expect(request.url.path, '/v1/reniec/dni');
    expect(result?.nombre, 'DELGADO HUAMANI ROXANA');

    lookup = lookupAnswering(422, {'message': 'ruc no valido'});
    expect(
      await lookup.lookup(
        company: _company(LookupProvider.commercial),
        secrets: const CompanySecrets({}),
        tipoDocumentoIdentidad: '6',
        numero: '20601030010',
      ),
      isNull,
    );
  });

  test('searchpe: basic authentication and its split address', () async {
    final lookup = lookupAnswering(200, {
      'nombre': 'EMPRESA S.A.C.',
      'tipoVia': 'AV.',
      'nombreVia': 'LARCO',
      'numero': '123',
      'interior': '-',
    });

    final result = await lookup.lookup(
      company: _company(
        LookupProvider.searchpe,
        'https://searchpe.example.com/',
      ),
      secrets: const CompanySecrets({CompanySecret.lookupToken: 'user:pass'}),
      tipoDocumentoIdentidad: '6',
      numero: '20123456789',
    );

    expect(
      request.url.toString(),
      'https://searchpe.example.com/api/contribuyentes/20123456789',
    );
    expect(
      request.headers['Authorization'],
      'Basic ${base64Encode(utf8.encode('user:pass'))}',
    );
    expect(result?.direccion, 'AV. LARCO 123');
  });

  test('other HTTP errors are reported', () {
    final lookup = lookupAnswering(401, {});
    expect(
      lookup.lookup(
        company: _company(LookupProvider.commercial),
        secrets: const CompanySecrets({}),
        tipoDocumentoIdentidad: '6',
        numero: '20601030013',
      ),
      throwsA(isA<http.ClientException>()),
    );
  });
}
