import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/backup/backup_page.dart';
import 'package:xhandler_mobile/features/backup/backup_service.dart';
import 'package:xhandler_mobile/features/home/home_page.dart';
import 'package:xhandler_mobile/features/reports/reports_page.dart';
import 'package:xhandler_mobile/strings.dart';

import '../helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('welcomes a new user', (tester) async {
      final data = TestData();
      await data.pump(tester, const HomePage(), settle: false);
      await data.waitFor(tester, find.text(Strings.welcomeTitle));

      expect(find.text(Strings.createCompany), findsOneWidget);
      expect(find.text(Strings.restoreBackup), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('shows the active company in test mode, without documents', (
      tester,
    ) async {
      final data = TestData();
      await tester.runAsync(data.createCompany);
      await data.pump(tester, const HomePage(), settle: false);
      await data.waitFor(tester, find.text(Strings.noDocuments));

      expect(find.text('Empresa 20123456789'), findsOneWidget);
      expect(find.text(Strings.testMode), findsOneWidget);
      await data.unmount(tester);
    });

    Future<void> openNewDocumentSheet(
      WidgetTester tester,
      TestData data,
    ) async {
      await data.pump(tester, const HomePage(), settle: false);
      await data.waitFor(tester, find.text(Strings.noDocuments));
      await tester.tap(find.text(Strings.newDocument));
      await data.waitFor(tester, find.text(Strings.quickSale));
    }

    testWidgets('offers no percepciones or retenciones to other companies', (
      tester,
    ) async {
      final data = TestData();
      await tester.runAsync(data.createCompany);
      await openNewDocumentSheet(tester, data);

      expect(find.text(Strings.percepcion), findsNothing);
      expect(find.text(Strings.retencion), findsNothing);
      await data.unmount(tester);
    });

    testWidgets('offers percepciones to agentes de percepción', (tester) async {
      final data = TestData();
      await tester.runAsync(() async {
        final company = await data.createCompany();
        await data.companies.update(
          company.id,
          const CompaniesCompanion(esAgentePercepcion: Value(true)),
        );
      });
      await openNewDocumentSheet(tester, data);

      expect(find.text(Strings.percepcion), findsOneWidget);
      expect(find.text(Strings.retencion), findsNothing);
      await data.unmount(tester);
    });
  });

  testWidgets('ReportsPage shows an empty month', (tester) async {
    final data = TestData();
    final company = (await tester.runAsync(data.createCompany))!;
    await data.pump(tester, ReportsPage(company), settle: false);
    await data.waitFor(tester, find.text(Strings.noSales));
    await data.unmount(tester);
  });

  group('BackupPage', () {
    testWidgets('says no backup was made yet', (tester) async {
      final data = TestData();
      await data.pump(tester, const BackupPage(), settle: false);
      await data.waitFor(tester, find.text(Strings.noBackupYet));
      await data.unmount(tester);
    });

    testWidgets('needs a password of 8 characters, typed twice', (
      tester,
    ) async {
      final data = TestData();
      await data.pump(tester, const BackupPage(), settle: false);
      await data.waitFor(tester, find.text(Strings.noBackupYet));

      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.backupPassword),
        'short',
      );
      await tester.tap(find.text(Strings.createBackup));
      await tester.pump();
      expect(find.text(Strings.backupPasswordTooShort), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.backupPassword),
        'long enough',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.backupPasswordConfirmation),
        'something else',
      );
      await tester.tap(find.text(Strings.createBackup));
      await tester.pump();
      expect(find.text(Strings.backupPasswordTooShort), findsNothing);
      expect(find.text(Strings.passwordsDiffer), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('shows when the last backup was made', (tester) async {
      final data = TestData();
      final last = DateTime.utc(2026, 11, 2, 15);
      await tester.runAsync(
        () => data.database.setSetting(lastBackupKey, last.toIso8601String()),
      );
      await data.pump(tester, const BackupPage(), settle: false);
      final date = const DefaultMaterialLocalizations().formatMediumDate(
        last.toLocal(),
      );
      await data.waitFor(tester, find.text(Strings.lastBackup(date)));
      expect(find.text(Strings.noBackupYet), findsNothing);
      await data.unmount(tester);
    });
  });
}
