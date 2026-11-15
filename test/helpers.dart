import 'dart:async';

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
import 'package:xhandler_mobile/widgets/form_widgets.dart';

/// In-memory database and mock secure storage for a test. Create it inside
/// the test body: Drift's stream timers must live in the tester's zone.
class TestData {
  TestData() {
    FlutterSecureStorage.setMockInitialValues({});
    addTearDown(database.close);
  }

  final database = AppDatabase(NativeDatabase.memory());
  final secureStore = SecureStore();
  late final companies = CompanyRepository(database, secureStore);

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
  /// themselves when saved). Pages that wait for a database stream show a
  /// spinner that never settles: pass `settle: false` and [waitFor] them.
  Future<void> pump(
    WidgetTester tester,
    Widget page, {
    bool settle = true,
  }) async {
    // A tall phone, so whole forms fit on screen
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(navigatorKey: navigator, home: const Scaffold()),
      ),
    );
    unawaited(
      navigator.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => page),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump(const Duration(milliseconds: 500)); // the transition
    }
  }

  /// Pumps until [finder] finds something. Database work needs real time,
  /// which the tester's fake clock lacks, so real time and frames alternate.
  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var wait = 0; wait < 100; wait++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Never found $finder');
  }

  /// Taps [label] (by default "Guardar") and waits until the save button
  /// stops showing progress. Database work needs real time, which the
  /// tester's fake clock lacks, so real time and frames alternate.
  Future<void> tapAndWait(
    WidgetTester tester, [
    String label = 'Guardar',
  ]) async {
    final saving = find.descendant(
      of: find.byType(SaveButton),
      matching: find.byType(CircularProgressIndicator),
    );
    await tester.tap(find.text(label));
    for (var wait = 0; wait < 100; wait++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
      if (saving.evaluate().isEmpty) {
        await tester.pumpAndSettle();
        return;
      }
    }
    fail('Saving did not finish');
  }

  /// Unmounts the app and runs the timer Drift schedules when its stream
  /// queries close, so no timer is left pending
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }
}
