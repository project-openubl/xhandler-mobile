import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secrets of a company, kept in the Android Keystore / iOS Keychain
class CompanySecrets {
  const CompanySecrets({
    this.certificate,
    this.certificatePassword,
    this.solUsername,
    this.solPassword,
    this.greClientId,
    this.greClientSecret,
    this.lookupToken,
  });

  /// PKCS#12 keystore (.pfx)
  final Uint8List? certificate;
  final String? certificatePassword;
  final String? solUsername;
  final String? solPassword;
  final String? greClientId;
  final String? greClientSecret;
  final String? lookupToken;
}

class SecureStore {
  SecureStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _databaseKey = 'database_key';

  /// Key of the encrypted database, generated the first time
  Future<String> databaseKey() async {
    final existing = await _storage.read(key: _databaseKey);
    if (existing != null) return existing;

    final random = Random.secure();
    final key = List.generate(
      32,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    await _storage.write(key: _databaseKey, value: key);
    return key;
  }

  Future<CompanySecrets> readCompanySecrets(String companyId) async {
    Future<String?> read(String name) =>
        _storage.read(key: _companyKey(companyId, name));
    final certificate = await read('certificate');
    return CompanySecrets(
      certificate: certificate == null ? null : base64Decode(certificate),
      certificatePassword: await read('certificate_password'),
      solUsername: await read('sol_username'),
      solPassword: await read('sol_password'),
      greClientId: await read('gre_client_id'),
      greClientSecret: await read('gre_client_secret'),
      lookupToken: await read('lookup_token'),
    );
  }

  /// Replaces all the secrets of the company; `null` values are deleted
  Future<void> writeCompanySecrets(
    String companyId,
    CompanySecrets secrets,
  ) async {
    final values = {
      'certificate': secrets.certificate == null
          ? null
          : base64Encode(secrets.certificate!),
      'certificate_password': secrets.certificatePassword,
      'sol_username': secrets.solUsername,
      'sol_password': secrets.solPassword,
      'gre_client_id': secrets.greClientId,
      'gre_client_secret': secrets.greClientSecret,
      'lookup_token': secrets.lookupToken,
    };
    for (final MapEntry(:key, :value) in values.entries) {
      await _storage.write(key: _companyKey(companyId, key), value: value);
    }
  }

  Future<void> deleteCompanySecrets(String companyId) =>
      writeCompanySecrets(companyId, const CompanySecrets());

  static String _companyKey(String companyId, String name) =>
      'company/$companyId/$name';
}
