import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum CompanySecret {
  /// PKCS#12 keystore (.pfx), base64
  certificate,
  certificatePassword,
  solUsername,
  solPassword,
  greClientId,
  greClientSecret,
  lookupToken,

  /// The company's email account (SMTP) to send documents to customers
  smtpHost,
  smtpPort,
  smtpUsername,
  smtpPassword,
}

/// Secrets of a company, kept in the Android Keystore / iOS Keychain
class CompanySecrets {
  const CompanySecrets(this._values);

  final Map<CompanySecret, String> _values;

  Uint8List? get certificate {
    final certificate = _values[CompanySecret.certificate];
    return certificate == null ? null : base64Decode(certificate);
  }

  String? get certificatePassword => _values[CompanySecret.certificatePassword];
  String? get solUsername => _values[CompanySecret.solUsername];
  String? get solPassword => _values[CompanySecret.solPassword];
  String? get greClientId => _values[CompanySecret.greClientId];
  String? get greClientSecret => _values[CompanySecret.greClientSecret];
  String? get lookupToken => _values[CompanySecret.lookupToken];
  String? get smtpHost => _values[CompanySecret.smtpHost];
  int? get smtpPort => int.tryParse(_values[CompanySecret.smtpPort] ?? '');
  String? get smtpUsername => _values[CompanySecret.smtpUsername];
  String? get smtpPassword => _values[CompanySecret.smtpPassword];
}

/// The database exists but its key is gone (e.g. the secure storage was
/// wiped): the database can't be opened anymore
class DatabaseKeyLostError implements Exception {
  const DatabaseKeyLostError();
}

class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Fail instead of silently wiping everything
            aOptions: AndroidOptions(resetOnError: false),
            // Readable by background backups after the first unlock, and
            // kept out of iCloud: the app's own backup carries the secrets
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  static const _databaseKey = 'database_key';

  /// Key of the encrypted database. Call it once, at startup.
  ///
  /// Without a database this is a fresh install: what a previous install
  /// left (iOS keeps the keychain after uninstalling) is deleted and a new
  /// key is generated. Throws [DatabaseKeyLostError] when the database
  /// exists but its key doesn't.
  Future<String> databaseKey({required bool databaseExists}) async {
    if (databaseExists) {
      final key = await _storage.read(key: _databaseKey);
      if (key == null) throw const DatabaseKeyLostError();
      return key;
    }

    await _storage.deleteAll();
    final random = Random.secure();
    final key = List.generate(
      32,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    await _storage.write(key: _databaseKey, value: key);
    return key;
  }

  Future<CompanySecrets> readCompanySecrets(String companyId) async {
    final values = <CompanySecret, String>{};
    for (final secret in CompanySecret.values) {
      final value = await _storage.read(key: _key(companyId, secret));
      if (value != null) values[secret] = value;
    }
    return CompanySecrets(values);
  }

  /// Writes the given secrets; a `null` value deletes that secret and the
  /// ones not given are left as they are
  Future<void> writeCompanySecrets(
    String companyId,
    Map<CompanySecret, String?> secrets,
  ) async {
    for (final MapEntry(:key, :value) in secrets.entries) {
      await _storage.write(key: _key(companyId, key), value: value);
    }
  }

  /// Deletes every secret of the company, including any added in later
  /// versions
  Future<void> deleteCompanySecrets(String companyId) async {
    final prefix = 'company/$companyId/';
    for (final key in (await _storage.readAll()).keys.toList()) {
      if (key.startsWith(prefix)) await _storage.delete(key: key);
    }
  }

  static const _companyPrefix = 'company/';

  /// Every company's secrets, as stored: what a backup carries
  Future<Map<String, String>> readAllCompanySecrets() async => {
    for (final MapEntry(:key, :value) in (await _storage.readAll()).entries)
      if (key.startsWith(_companyPrefix)) key: value,
  };

  /// Replaces every company's secrets with [secrets] (from a backup); the
  /// database key stays
  Future<void> replaceAllCompanySecrets(Map<String, String> secrets) async {
    for (final key in (await readAllCompanySecrets()).keys) {
      await _storage.delete(key: key);
    }
    for (final MapEntry(:key, :value) in secrets.entries) {
      if (key.startsWith(_companyPrefix)) {
        await _storage.write(key: key, value: value);
      }
    }
  }

  /// Adds companies' [secrets], as stored (from a backup), keeping the rest;
  /// only `company/...` keys are written
  Future<void> addCompanySecrets(Map<String, String> secrets) async {
    for (final MapEntry(:key, :value) in secrets.entries) {
      if (key.startsWith(_companyPrefix)) {
        await _storage.write(key: key, value: value);
      }
    }
  }

  static String _key(String companyId, CompanySecret secret) =>
      'company/$companyId/${secret.name}';
}
