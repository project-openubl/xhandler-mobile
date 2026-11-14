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

/// RFC 9106's second recommendation: 64 MiB, 3 iterations. The file
/// holds a signing certificate and SOL credentials, and may sit on a cloud
/// drive. Changing it needs a new format version.
final _kdf = Argon2id(
  parallelism: 1,
  memory: 65536,
  iterations: 3,
  hashLength: 32,
);
final _cipher = AesGcm.with256bits();

/// A backup opened with its password, ready to replace this device's data
class OpenedBackup {
  const OpenedBackup(this.database, this.secrets);

  /// The database, already encrypted with this device's key
  final File database;
  final Map<String, String> secrets;
}

/// Encrypted backups of everything: the database and every company's
/// secrets, certificates included (docs/DESIGN.md §9).
///
/// File: "XHB1", salt, nonce, the secrets' length (4 bytes, big endian),
/// the secrets (JSON, AES-256-GCM) and the database. The key comes from
/// the backup password (Argon2id); it also encrypts the database
/// (SQLite3MultipleCiphers `PRAGMA rekey`), which is never on disk in clear.
/// Files are streamed: databases with years of XML and CDRs are large.
class BackupService {
  BackupService(this._secureStore, this._temporary);

  final SecureStore _secureStore;

  /// Where backups are prepared
  final Future<Directory> Function() _temporary;

  Future<String> _deviceKey() => _secureStore.databaseKey(databaseExists: true);

  Future<File> _temporaryFile(String name) async => File(
    '${(await _temporary()).path}/$name-${DateTime.now().microsecondsSinceEpoch}',
  );

  /// Backs up [db], protected by [password], into a temporary file the
  /// caller deletes once saved
  Future<File> create(AppDatabase db, String password) async {
    final snapshot = await _temporaryFile('snapshot');
    final backup = await _temporaryFile('backup');
    try {
      // A consistent copy while the app keeps working, with this device's key
      await db.customStatement(
        "VACUUM INTO '${snapshot.path.replaceAll("'", "''")}'",
      );
      final salt = _random(_saltLength);
      final key = await _key(password, salt);
      final deviceKey = await _deviceKey();
      final path = snapshot.path;
      await _rekeyApart(path, deviceKey, _hex(key));

      final nonce = _random(_nonceLength);
      final secrets = await _cipher.encrypt(
        utf8.encode(
          jsonEncode({
            'schema_version': db.schemaVersion,
            'secrets': await _secureStore.readAllCompanySecrets(),
          }),
        ),
        secretKey: SecretKey(key),
        nonce: nonce,
      );
      final sealed = [...secrets.cipherText, ...secrets.mac.bytes];
      final sink = backup.openWrite()
        ..add(ascii.encode(_magic))
        ..add(salt)
        ..add(nonce)
        ..add((ByteData(4)..setUint32(0, sealed.length)).buffer.asUint8List())
        ..add(sealed);
      await sink.addStream(snapshot.openRead());
      await sink.close();
      return backup;
    } on Object {
      if (backup.existsSync()) await backup.delete();
      rethrow;
    } finally {
      if (snapshot.existsSync()) await snapshot.delete();
    }
  }

  /// Opens a backup made by [create]: checks [password] and prepares the
  /// database for this device. Throws [WrongPasswordError] (also for a
  /// damaged file) or [InvalidBackupError].
  Future<OpenedBackup> open(
    File backup, {
    required String password,
    required int schemaVersion,
  }) async {
    final reader = await backup.open();
    final int databaseOffset;
    final Uint8List salt, nonce, sealed;
    try {
      Future<Uint8List> take(int length) async {
        final part = await reader.read(length);
        if (part.length != length) throw const InvalidBackupError();
        return part;
      }

      if (ascii.decode(await take(4), allowInvalid: true) != _magic) {
        throw const InvalidBackupError();
      }
      salt = await take(_saltLength);
      nonce = await take(_nonceLength);
      final sealedLength = ByteData.sublistView(await take(4)).getUint32(0);
      if (sealedLength < _macLength) throw const InvalidBackupError();
      sealed = await take(sealedLength);
      databaseOffset = await reader.position();
    } finally {
      await reader.close();
    }

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

    final database = await _temporaryFile('restore');
    try {
      await backup.openRead(databaseOffset).pipe(database.openWrite());
      final deviceKey = await _deviceKey();
      final path = database.path;
      await _rekeyApart(path, _hex(key), deviceKey, newDevice: true);
    } on Object catch (error) {
      for (final file in [database, File('${database.path}-journal')]) {
        if (file.existsSync()) await file.delete();
      }
      // Every page is authenticated: a changed or cut database fails here
      if (error is SqliteException) throw const WrongPasswordError();
      rethrow;
    }
    return OpenedBackup(
      database,
      (contents['secrets']! as Map<String, Object?>).cast<String, String>(),
    );
  }

  /// Replaces this device's database and secrets with [backup]. The app's
  /// database (and any other connection) must be closed, and opened again
  /// afterwards. The database is swapped last, in one rename: an
  /// interrupted restore leaves the old one.
  Future<void> install(OpenedBackup backup, File databaseFile) async {
    final incoming = File('${databaseFile.path}.restore');
    await backup.database.copy(incoming.path);
    await backup.database.delete();
    await _secureStore.replaceAllCompanySecrets(backup.secrets);
    for (final suffix in ['-wal', '-shm', '-journal']) {
      final file = File('${databaseFile.path}$suffix');
      if (file.existsSync()) await file.delete();
    }
    await incoming.rename(databaseFile.path);
  }

  static Future<List<int>> _key(String password, List<int> salt) async =>
      (await _kdf.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      )).extractBytes();
}

/// [_rekey] in an isolate. Top-level so the closure captures only these
/// strings (open files can't be sent to isolates).
Future<void> _rekeyApart(
  String path,
  String from,
  String to, {
  bool newDevice = false,
}) => Isolate.run(() => _rekey(path, from, to, newDevice: newDevice));

/// Re-encrypts the database at [path] from [from] to [to]. Runs in an
/// isolate: it rewrites the whole file. A [newDevice] gets its own id
/// and forgets the old phone's last backup
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
      // This phone's own id, and no backup date of another phone
      database.execute(
        "DELETE FROM device_settings WHERE key IN ('device_id', 'last_backup_at')",
      );
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
