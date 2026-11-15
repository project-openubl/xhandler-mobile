import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../../app_log.dart';
import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../notifications.dart';
import '../../src/rust/frb_generated.dart';
import 'document_repository.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'sunat_bridge.dart';

/// The outbox task; also registered in ios/Runner (AppDelegate, Info.plist)
const outboxTask = 'io.github.projectopenubl.xhandler.outbox';

/// Statuses worth a notification: SUNAT's final answers
const _notified = {
  DocumentStatus.accepted,
  DocumentStatus.acceptedWithObservations,
  DocumentStatus.rejected,
  DocumentStatus.exception,
  DocumentStatus.unknown,
};

/// Sends pending documents while the app is closed, about every 15 minutes
/// with network (DESIGN §5), and notifies SUNAT's answers. iOS ignores
/// `frequency` and `constraints` and decides itself when to run it.
Future<void> scheduleBackgroundOutbox() async {
  await Workmanager().initialize(backgroundDispatcher);
  await Workmanager().registerPeriodicTask(
    outboxTask,
    outboxTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
  );
}

/// One background round: sends what's due within [budget] and calls
/// [notify] for each document SUNAT answered meanwhile
Future<void> runBackgroundOutbox(
  DocumentRepository documents,
  DocumentService service,
  Future<void> Function(Document document) notify, {
  Duration budget = const Duration(seconds: 20),
}) async {
  final waiting = await documents.due(nowUtc());
  await service.sendDue(budget: budget);
  for (final before in waiting) {
    final after = await documents.find(before.id);
    if (after.status != before.status && _notified.contains(after.status)) {
      await notify(after);
    }
  }
}

@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((_, _) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await AppLog.init();
    try {
      return await _sendInBackground();
    } on Object catch (error, stack) {
      // Workmanager would only say the task failed
      AppLog.error('Background outbox', error, stack);
      return false;
    }
  });
}

Future<bool> _sendInBackground() async {
  final file = await databaseFile();
  if (!file.existsSync()) return true;
  // The isolate may be reused for another run
  if (!RustLib.instance.initialized) await RustLib.init();
  final secureStore = SecureStore();
  final database = AppDatabase(
    openEncryptedDatabase(
      file,
      await secureStore.databaseKey(databaseExists: true),
    ),
  );
  try {
    final documents = DocumentRepository(database);
    await Notifications.initialize();
    await runBackgroundOutbox(
      documents,
      DocumentService(database, documents, secureStore, const SunatBridge()),
      (document) => Notifications.show(
        // Stable enough: it only groups notifications of one document
        document.id.hashCode,
        '${serieNumero(document.serie, document.numero)} · '
        '${document.status.label}',
        [document.clienteNombre, ?document.sunatCode].join(' · '),
        documentId: document.id,
      ),
    );
  } finally {
    await database.close();
  }
  return true;
}
