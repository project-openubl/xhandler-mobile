import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';

/// In-memory database and mock secure storage for a test. Create it inside
/// the test body: Drift's stream timers must live in the tester's zone.
class TestData {
  TestData() {
    FlutterSecureStorage.setMockInitialValues({});
    addTearDown(database.close);
  }

  final database = AppDatabase(NativeDatabase.memory());
  late final companies = CompanyRepository(database, SecureStore());

  Future<Company> createCompany({
    String ruc = '20123456789',
    LookupProvider lookupProvider = LookupProvider.none,
  }) async {
    await companies.create(
      CompaniesCompanion.insert(
        ruc: ruc,
        razonSocial: 'Empresa $ruc',
        lookupProvider: Value(lookupProvider),
      ),
    );
    return (await companies.watchActive().first)!;
  }

  /// Shows [page] pushed over an empty page, as the app does (forms pop
  /// themselves when saved)
  Future<void> pump(WidgetTester tester, Widget page) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(navigatorKey: navigator, home: const Scaffold()),
      ),
    );
    navigator.currentState!.push(MaterialPageRoute<void>(builder: (_) => page));
    await tester.pumpAndSettle();
  }

  /// Taps [label] (by default "Guardar") and waits until the save is done.
  /// Database work needs real time, which the tester's fake clock lacks, so
  /// real time and frames alternate while a progress indicator shows.
  Future<void> tapAndWait(
    WidgetTester tester, [
    String label = 'Guardar',
  ]) async {
    await tester.tap(find.text(label));
    var waits = 0;
    do {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    } while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty &&
        ++waits < 100);
    await tester.pumpAndSettle();
  }

  /// Unmounts the app and runs the timer Drift schedules when its stream
  /// queries close, so no timer is left pending
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }
}
