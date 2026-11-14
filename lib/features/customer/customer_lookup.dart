import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/database.dart';
import '../../data/secure_store.dart';

/// What a lookup service knows about a RUC or DNI
class LookupResult {
  const LookupResult({required this.nombre, this.direccion});

  final String nombre;
  final String? direccion;
}

/// Looks up the name (and address) of a RUC or DNI with the company's
/// lookup service (DESIGN §14): Decolecta, or a self-hosted searchpe
class CustomerLookup {
  CustomerLookup(this._client);

  final http.Client _client;

  static const decolectaUrl = 'https://api.decolecta.com/v1';

  /// `null` when the service doesn't know the number. Throws on network or
  /// authentication errors.
  Future<LookupResult?> lookup({
    required Company company,
    required CompanySecrets secrets,
    required String tipoDocumentoIdentidad,
    required String numero,
  }) {
    final token = secrets.lookupToken ?? '';
    return switch (company.lookupProvider) {
      LookupProvider.none => Future.value(),
      LookupProvider.commercial => _decolecta(
        tipoDocumentoIdentidad,
        numero,
        token,
      ),
      LookupProvider.searchpe => _searchpe(
        company.lookupUrl ?? '',
        numero,
        token,
      ),
    };
  }

  Future<LookupResult?> _decolecta(
    String tipo,
    String numero,
    String token,
  ) async {
    final path = tipo == '6' ? 'sunat/ruc' : 'reniec/dni';
    final json = await _get(
      Uri.parse('$decolectaUrl/$path?numero=$numero'),
      'Bearer $token',
    );
    if (json == null) return null;
    return tipo == '6'
        ? LookupResult(
            nombre: json['razon_social'] as String,
            direccion: json['direccion'] as String?,
          )
        : LookupResult(nombre: json['full_name'] as String);
  }

  /// [credentials] is "user:password" of searchpe's basic authentication
  Future<LookupResult?> _searchpe(
    String url,
    String numero,
    String credentials,
  ) async {
    final json = await _get(
      Uri.parse(
        '${url.replaceAll(RegExp(r'/+$'), '')}/api/contribuyentes/$numero',
      ),
      'Basic ${base64Encode(utf8.encode(credentials))}',
    );
    if (json == null) return null;
    // searchpe's padrón splits the address; "-" means empty
    final parts = [
      json['tipoVia'],
      json['nombreVia'],
      json['numero'],
      json['interior'],
    ].whereType<String>().where((part) => part.isNotEmpty && part != '-');
    return LookupResult(
      nombre: json['nombre'] as String,
      direccion: parts.isEmpty ? null : parts.join(' '),
    );
  }

  Future<Map<String, dynamic>?> _get(Uri uri, String authorization) async {
    final response = await _client.get(
      uri,
      headers: {'Authorization': authorization, 'Accept': 'application/json'},
    );
    // Unknown or invalid numbers
    if (const {400, 404, 422}.contains(response.statusCode)) return null;
    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', uri);
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}

final customerLookupProvider = Provider((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return CustomerLookup(client);
});
