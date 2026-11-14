import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';

/// The backup password is wrong, or the file was changed
class WrongPasswordError implements Exception {
  const WrongPasswordError();
}

/// The file isn't a backup of this app, or comes from a newer version
class InvalidBackupError implements Exception {
  const InvalidBackupError({this.newerVersion = false});

  /// Made by a newer version of the app: update it to restore
  final bool newerVersion;
}

/// Beginning of every backup file, with the format version
const _magic = 'XHB1';
const _saltLength = 16;
const _nonceLength = 12;
const _macLength = 16;

/// OWASP's minimum for Argon2id: 19 MiB, 2 iterations
final _kdf = Argon2id(
  parallelism: 1,
  memory: 19456,
  iterations: 2,
  hashLength: 32,
);
final _cipher = AesGcm.with256bits();

/// A backup opened with its password, ready to replace this device's data
class OpenedBackup {
  const OpenedBackup(this.database, this.secrets, this.createdAt);

  /// The database, already encrypted with this device's key
  final File database;
  final Map<String, String> secrets;
  final DateTime createdAt;
}

/// Encrypted backups of everything: the database and every company's
/// secrets, certificates included (docs/DESIGN.md §9).
///
/// File: "XHB1", salt, nonce, the secrets' length (4 bytes, big endian),
/// the secrets (JSON, AES-256-GCM) and the database. The key comes from
/// the backup password (Argon2id); it also encrypts the database
/// (SQLite3MultipleCiphers `PRAGMA rekey`), which is never on disk in clear.
class BackupService {
  BackupService(this._secureStore, this._temporary);

  final SecureStore _secureStore;

  /// Where snapshots are prepared
  final Future<Directory> Function() _temporary;

  Future<String> _deviceKey() => _secureStore.databaseKey(databaseExists: true);

  /// Backs up [db], protected by [password]
  Future<Uint8List> create(AppDatabase db, String password) async {
    final folder = await _temporary();
    final snapshot = File(
      '${folder.path}/snapshot-${DateTime.now().microsecondsSinceEpoch}.db',
    );
    try {
      // A consistent copy while the app keeps working, with this device's key
      await db.customStatement(
        "VACUUM INTO '${snapshot.path.replaceAll("'", "''")}'",
      );
      final salt = _random(_saltLength);
      final key = await _key(password, salt);
      final deviceKey = await _deviceKey();
      final path = snapshot.path;
      await Isolate.run(() => _rekey(path, deviceKey, _hex(key)));

      final nonce = _random(_nonceLength);
      final secrets = await _cipher.encrypt(
        utf8.encode(
          jsonEncode({
            'created_at': DateTime.now().toUtc().toIso8601String(),
            'schema_version': db.schemaVersion,
            'secrets': await _secureStore.readAllCompanySecrets(),
          }),
        ),
        secretKey: SecretKey(key),
        nonce: nonce,
      );
      final sealed = [...secrets.cipherText, ...secrets.mac.bytes];
      return (BytesBuilder(copy: false)
            ..add(ascii.encode(_magic))
            ..add(salt)
            ..add(nonce)
            ..add(
              (ByteData(4)..setUint32(0, sealed.length)).buffer.asUint8List(),
            )
            ..add(sealed)
            ..add(await snapshot.readAsBytes()))
          .takeBytes();
    } finally {
      if (snapshot.existsSync()) await snapshot.delete();
    }
  }

  /// Opens a backup made by [create]: checks [password] and prepares the
  /// database for this device. Throws [WrongPasswordError] or
  /// [InvalidBackupError].
  Future<OpenedBackup> open(
    Uint8List bytes, {
    required String password,
    required int schemaVersion,
  }) async {
    const header = 4 + _saltLength + _nonceLength + 4;
    if (bytes.length < header ||
        ascii.decode(bytes.sublist(0, 4), allowInvalid: true) != _magic) {
      throw const InvalidBackupError();
    }
    var offset = 4;
    Uint8List take(int length) {
      if (offset + length > bytes.length) throw const InvalidBackupError();
      final part = bytes.sublist(offset, offset + length);
      offset += length;
      return part;
    }

    final salt = take(_saltLength);
    final nonce = take(_nonceLength);
    final sealedLength = ByteData.sublistView(take(4)).getUint32(0);
    if (sealedLength < _macLength) throw const InvalidBackupError();
    final sealed = take(sealedLength);
    final database = bytes.sublist(offset);

    final key = await _key(password, salt);
    final Map<String, Object?> contents;
    try {
      contents = jsonDecode(
        utf8.decode(
          await _cipher.decrypt(
            SecretBox(
              sealed.sublist(0, sealed.length - _macLength),
              nonce: nonce,
              mac: Mac(sealed.sublist(sealed.length - _macLength)),
            ),
            secretKey: SecretKey(key),
          ),
        ),
      ) as Map<String, Object?>;
    } on SecretBoxAuthenticationError {
      throw const WrongPasswordError();
    }
    if ((contents['schema_version'] as int? ?? 0) > schemaVersion) {
      throw const InvalidBackupError(newerVersion: true);
    }

    final file = File(
      '${(await _temporary()).path}/restore-${DateTime.now().microsecondsSinceEpoch}.db',
    );
    await file.writeAsBytes(database, flush: true);
    final deviceKey = await _deviceKey();
    final path = file.path;
    try {
      await Isolate.run(
        () => _rekey(path, _hex(key), deviceKey, newDevice: true),
      );
    } on SqliteException {
      await file.delete();
      throw const InvalidBackupError();
    }
    return OpenedBackup(
      file,
      (contents['secrets']! as Map<String, Object?>).cast<String, String>(),
      DateTime.parse(contents['created_at']! as String),
    );
  }

  /// Replaces this device's database and secrets with [backup]. The app's
  /// database must be closed, and opened again afterwards.
  Future<void> install(OpenedBackup backup, File databaseFile) async {
    for (final suffix in ['-wal', '-shm', '-journal']) {
      final file = File('${databaseFile.path}$suffix');
      if (file.existsSync()) await file.delete();
    }
    await backup.database.copy(databaseFile.path);
    await backup.database.delete();
    await _secureStore.replaceAllCompanySecrets(backup.secrets);
  }

  static Future<List<int>> _key(String password, List<int> salt) async =>
      (await _kdf.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      )).extractBytes();
}

/// Re-encrypts the database at [path] from [from] to [to]. Runs in an
/// isolate: it rewrites the whole file. A [newDevice] gets its own id
/// (docs/DESIGN.md §3.1); documents keep the one that issued them.
void _rekey(String path, String from, String to, {bool newDevice = false}) {
  final database = sqlite3.open(path);
  try {
    database
      ..execute("PRAGMA key = '$from'")
      // Fails here when [from] isn't its key
      ..select('SELECT count(*) FROM sqlite_master')
      ..execute("PRAGMA rekey = '$to'");
    if (newDevice) {
      database.execute("DELETE FROM device_settings WHERE key = 'device_id'");
    }
  } finally {
    database.close();
  }
}

Uint8List _random(int length) {
  final random = Random.secure();
  return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
}

String _hex(List<int> bytes) =>
    bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
