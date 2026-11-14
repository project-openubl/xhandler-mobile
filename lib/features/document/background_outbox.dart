import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:workmanager/workmanager.dart';

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

/// Sends pending documents while the app is closed, about every 15 minutes
/// with network (DESIGN §5), and notifies SUNAT's answers
Future<void> scheduleBackgroundOutbox() async {
  await Workmanager().initialize(backgroundDispatcher);
  await Workmanager().registerPeriodicTask(
    outboxTask,
    outboxTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((_, _) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    final file = await databaseFile();
    if (!file.existsSync()) return true;
    await RustLib.init();
    final secureStore = SecureStore();
    final database = AppDatabase(
      openEncryptedDatabase(
        file,
        await secureStore.databaseKey(databaseExists: true),
      ),
    );
    try {
      final documents = DocumentRepository(database);
      final waiting = await documents.due(nowUtc());
      await DocumentService(
        database,
        documents,
        secureStore,
        const SunatBridge(),
      ).sendDue();
      await Notifications.initialize();
      for (final before in waiting) {
        final after = await documents.find(before.id);
        if (after.status == before.status) continue;
        await Notifications.show(
          after.id.hashCode,
          serieNumero(after.serie, after.numero),
          after.status.label,
        );
      }
    } finally {
      await database.close();
    }
    return true;
  });
}
