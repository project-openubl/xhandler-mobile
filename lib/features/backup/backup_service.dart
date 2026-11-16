import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
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
  /// caller deletes once saved. With [onlyCompanyId], the file holds that
  /// company alone (its data and secrets), to move it to another phone.
  Future<File> create(
    AppDatabase db,
    String password, {
    String? onlyCompanyId,
  }) async {
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
      await _rekeyApart(path, deviceKey, _hex(key), keep: onlyCompanyId);
      final secrets = await _secureStore.readAllCompanySecrets();
      if (onlyCompanyId != null) {
        secrets.removeWhere(
          (key, _) => !key.startsWith('company/$onlyCompanyId/'),
        );
      }

      final nonce = _random(_nonceLength);
      final sealedSecrets = await _cipher.encrypt(
        utf8.encode(
          jsonEncode({'schema_version': db.schemaVersion, 'secrets': secrets}),
        ),
        secretKey: SecretKey(key),
        nonce: nonce,
      );
      final sealed = [...sealedSecrets.cipherText, ...sealedSecrets.mac.bytes];
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

  /// Adds to [db] the companies of [backup] this device doesn't have (by
  /// RUC), with their data and secrets, and returns their names. Opened
  /// databases of older versions are upgraded first. [db] stays open.
  Future<List<String>> merge(OpenedBackup backup, AppDatabase db) async {
    final deviceKey = await _deviceKey();
    try {
      // A second AppDatabase on purpose (Drift warns about it in debug):
      // opening it upgrades an older backup's schema
      final incoming = AppDatabase(
        openEncryptedDatabase(backup.database, deviceKey),
      );
      final List<Company> offered;
      try {
        offered = await (incoming.select(
          incoming.companies,
        )..where((c) => c.deletedAt.isNull())).get();
      } finally {
        await incoming.close();
      }
      final here = await db.select(db.companies).get();
      final rucs = {
        for (final company in here)
          if (company.deletedAt == null) company.ruc,
      };
      final ids = {for (final company in here) company.id};
      // A company deleted here keeps its id: one coming back with it is
      // skipped too (rare; the message then says it's already here)
      final added = [
        for (final company in offered)
          if (!rucs.contains(company.ruc) && !ids.contains(company.id)) company,
      ];
      if (added.isEmpty) return const [];

      // Secrets first: if copying fails they're taken back, so a company is
      // never here without its certificate and credentials
      await _secureStore.addCompanySecrets({
        for (final MapEntry(:key, :value) in backup.secrets.entries)
          if (added.any((c) => key.startsWith('company/${c.id}/'))) key: value,
      });
      try {
        await _copyRows(db, backup.database, deviceKey, [
          for (final company in added) company.id,
        ]);
      } on Object {
        for (final company in added) {
          await _secureStore.deleteCompanySecrets(company.id);
        }
        rethrow;
      }
      db.markTablesUpdated(db.allTables);
      return [
        for (final company in added)
          company.nombreComercial ?? company.razonSocial,
      ];
    } finally {
      if (backup.database.existsSync()) await backup.database.delete();
    }
  }

  /// Copies the rows of the companies [ids] from the database [file] into
  /// [db], in one transaction. Values are bound: the file came from outside.
  static Future<void> _copyRows(
    AppDatabase db,
    File file,
    String key,
    List<String> ids,
  ) async {
    await db.customStatement('ATTACH DATABASE ? AS incoming KEY ?', [
      file.path,
      key,
    ]);
    try {
      await db.transaction(() async {
        for (final (table, filter) in _companyRows(ids.length)) {
          // By name: a migrated database orders columns differently
          final columns =
              (await db.customSelect('PRAGMA main.table_info($table)').get())
                  .map((row) => '"${row.read<String>('name')}"')
                  .join(', ');
          await db.customStatement(
            'INSERT INTO main.$table ($columns) '
            'SELECT $columns FROM incoming.$table WHERE $filter',
            ids,
          );
        }
      });
    } finally {
      await db.customStatement('DETACH DATABASE incoming');
    }
  }

  /// Every table with rows of some companies, parents first, and how to
  /// select those rows given the [count] company ids as parameters
  static List<(String, String)> _companyRows(int count) {
    final ids = List.filled(count, '?').join(', ');
    final documents =
        'document_id IN (SELECT id FROM incoming.documents '
        'WHERE company_id IN ($ids))';
    return [
      ('companies', 'id IN ($ids)'),
      for (final table in _companyTables) (table, 'company_id IN ($ids)'),
      for (final table in _documentTables) (table, documents),
    ];
  }

  /// Every table the export and the import know about
  @visibleForTesting
  static Set<String> get knownTables => {
    'companies',
    'device_settings',
    ..._companyTables,
    ..._documentTables,
  };

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
  String? keep,
}) =>
    Isolate.run(() => _rekey(path, from, to, newDevice: newDevice, keep: keep));

/// Tables with a `company_id`, after `companies`. Every table must be here,
/// in [_documentTables], or be `companies`/`device_settings` (a test checks):
/// one left out would be exported for every company
const _companyTables = [
  'series',
  'customers',
  'products',
  'documents',
  'vehicles',
  'drivers',
  'addresses',
];

/// Tables of a document's files and history, after `documents`
const _documentTables = ['document_files', 'document_events', 'deliveries'];

/// Re-encrypts the database at [path] from [from] to [to]. Runs in an
/// isolate: it rewrites the whole file. A [newDevice] gets its own id
/// and forgets the old phone's last backup
/// (docs/DESIGN.md §3.1); documents keep the one that issued them. With
/// [keep], only that company's rows stay, and none of the others' remain
/// in the file's free pages.
void _rekey(
  String path,
  String from,
  String to, {
  bool newDevice = false,
  String? keep,
}) {
  final database = sqlite3.open(path);
  try {
    database
      ..execute("PRAGMA key = '$from'")
      // Fails here when [from] isn't its key
      ..select('SELECT count(*) FROM sqlite_master');
    if (keep != null) {
      for (final table in _documentTables) {
        database.execute(
          'DELETE FROM $table WHERE document_id IN '
          '(SELECT id FROM documents WHERE company_id != ?)',
          [keep],
        );
      }
      for (final table in _companyTables.reversed) {
        database.execute('DELETE FROM $table WHERE company_id != ?', [keep]);
      }
      database
        ..execute('DELETE FROM companies WHERE id != ?', [keep])
        // This phone's settings mean nothing elsewhere
        ..execute('DELETE FROM device_settings')
        ..execute('VACUUM');
    }
    database.execute("PRAGMA rekey = '$to'");
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

final backupServiceProvider = Provider(
  (ref) => BackupService(ref.watch(secureStoreProvider), getTemporaryDirectory),
);

/// Device setting with when this device last made a backup
const lastBackupKey = 'last_backup_at';

final lastBackupProvider = StreamProvider.autoDispose<DateTime?>(
  (ref) => ref
      .watch(databaseProvider)
      .watchSetting(lastBackupKey)
      .map((value) => value == null ? null : DateTime.parse(value)),
);
