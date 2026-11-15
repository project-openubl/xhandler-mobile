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
/// service (DESIGN §14): Decolecta
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
}

final customerLookupProvider = Provider((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return CustomerLookup(client);
});
