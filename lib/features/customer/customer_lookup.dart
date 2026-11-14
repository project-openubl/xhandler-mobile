import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/database.dart';
import '../../data/secure_store.dart';

/// What a lookup service knows about a RUC or DNI
class LookupResult {
  const LookupResult({
    required this.nombre,
    this.direccion,
    this.distrito,
    this.provincia,
    this.departamento,
    this.ubigeo,
  });

  final String nombre;
  final String? direccion;
  final String? distrito;
  final String? provincia;
  final String? departamento;
  final String? ubigeo;
}

enum LookupErrorKind {
  /// Wrong token, user or password
  authentication,

  /// The plan's requests are used up
  quota,

  /// Network, timeout, unexpected answer
  other,
}

class LookupError implements Exception {
  const LookupError(this.kind);

  final LookupErrorKind kind;
}

/// Looks up the name and address of a RUC or DNI with the company's lookup
/// service (DESIGN §14): Decolecta, or a self-hosted searchpe
class CustomerLookup {
  CustomerLookup(this._client);

  final http.Client _client;

  static final decolectaUrl = Uri.parse('https://api.decolecta.com/v1/');
  static const timeout = Duration(seconds: 15);

  /// `null` when the service doesn't know the number; throws [LookupError]
  Future<LookupResult?> lookup({
    required Company company,
    required CompanySecrets secrets,
    required String tipoDocumentoIdentidad,
    required String numero,
  }) async {
    final token = secrets.lookupToken ?? '';
    try {
      return switch (company.lookupProvider) {
        LookupProvider.none => null,
        LookupProvider.decolecta => await _decolecta(
          tipoDocumentoIdentidad,
          numero,
          token,
        ),
        LookupProvider.searchpe => await _searchpe(
          company.lookupUrl ?? '',
          numero,
          token,
        ),
      };
    } on LookupError {
      rethrow;
    } on Exception {
      // Network errors, timeouts, bodies that aren't what we expect
      throw const LookupError(LookupErrorKind.other);
    }
  }

  Future<LookupResult?> _decolecta(
    String tipo,
    String numero,
    String token,
  ) async {
    final isRuc = tipo == '6';
    final json = await _get(
      decolectaUrl.resolve(
        isRuc ? 'sunat/ruc?numero=$numero' : 'reniec/dni?numero=$numero',
      ),
      'Bearer $token',
    );
    if (json == null) return null;
    final nombre = _text(json[isRuc ? 'razon_social' : 'full_name']);
    if (nombre == null) return null;
    return LookupResult(
      nombre: nombre,
      direccion: _text(json['direccion']),
      distrito: _text(json['distrito']),
      provincia: _text(json['provincia']),
      departamento: _text(json['departamento']),
      ubigeo: _text(json['ubigeo']),
    );
  }

  /// [credentials] is "user:password" of searchpe's basic authentication.
  /// searchpe has SUNAT's padrón: DNIs are only found for RUC 10 holders.
  Future<LookupResult?> _searchpe(
    String url,
    String numero,
    String credentials,
  ) async {
    final base = Uri.parse(url.endsWith('/') ? url : '$url/');
    final json = await _get(
      base.resolve('api/contribuyentes/$numero'),
      'Basic ${base64Encode(utf8.encode(credentials))}',
    );
    if (json == null) return null;
    final nombre = _text(json['nombre']);
    if (nombre == null) return null;
    // As SUNAT's padrón writes it; searchpe's "departamento" is the
    // apartment, not the region
    final parts = [
      _text(json['tipoVia']),
      _text(json['nombreVia']),
      _labeled('NRO.', json['numero']),
      _labeled('DPTO.', json['departamento']),
      _labeled('INT.', json['interior']),
      _labeled('MZA.', json['manzana']),
      _labeled('LOTE', json['lote']),
      _labeled('KM.', json['kilometro']),
      _text(json['tipoZona']),
      _text(json['codigoZona']),
    ].nonNulls;
    return LookupResult(
      nombre: nombre,
      direccion: parts.isEmpty ? null : parts.join(' '),
      ubigeo: _text(json['ubigeo']),
    );
  }

  Future<Map<String, dynamic>?> _get(Uri uri, String authorization) async {
    final response = await _client
        .get(
          uri,
          headers: {
            'Authorization': authorization,
            'Accept': 'application/json',
          },
        )
        .timeout(timeout);
    switch (response.statusCode) {
      case 200:
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json is! Map<String, dynamic>) {
          throw const FormatException('Not a JSON object');
        }
        return json;
      case 404 || 422:
        return null; // unknown or invalid number
      case 401 || 403:
        throw const LookupError(LookupErrorKind.authentication);
      case 429:
        throw const LookupError(LookupErrorKind.quota);
      default:
        throw const LookupError(LookupErrorKind.other);
    }
  }

  /// Text of a JSON value; the services write "-" for empty values
  static String? _text(Object? value) {
    final text = value is String ? value.trim() : null;
    return text == null || text.isEmpty || text == '-' ? null : text;
  }

  static String? _labeled(String label, Object? value) {
    final text = _text(value);
    return text == null ? null : '$label $text';
  }
}

final customerLookupProvider = Provider((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return CustomerLookup(client);
});
