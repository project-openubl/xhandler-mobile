import 'package:go_router/go_router.dart';

import 'features/company/certificate_page.dart';
import 'features/company/company_form_page.dart';
import 'features/company/company_settings_page.dart';
import 'features/company/credentials_page.dart';
import 'features/diagnostics/sunat_beta_check_page.dart';
import 'features/home/home_page.dart';
import 'features/series/series_page.dart';

/// Routes of the app. Pages under `/company` work on the active company.
abstract final class Routes {
  static const home = '/';
  static const newCompany = '/company/new';
  static const companySettings = '/company';
  static const editCompany = '/company/edit';
  static const certificate = '/company/certificate';
  static const credentials = '/company/credentials';
  static const series = '/series';
  static const diagnostics = '/diagnostics';
}

final router = GoRouter(
  routes: [
    GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
    GoRoute(
      path: Routes.newCompany,
      builder: (_, _) => const CompanyFormPage(),
    ),
    GoRoute(
      path: Routes.companySettings,
      builder: (_, _) => const CompanySettingsPage(),
    ),
    GoRoute(
      path: Routes.editCompany,
      builder: (_, _) => const CompanyFormPage(editActive: true),
    ),
    GoRoute(
      path: Routes.certificate,
      builder: (_, _) => const CertificatePage(),
    ),
    GoRoute(
      path: Routes.credentials,
      builder: (_, _) => const CredentialsPage(),
    ),
    GoRoute(path: Routes.series, builder: (_, _) => const SeriesPage()),
    GoRoute(
      path: Routes.diagnostics,
      builder: (_, _) => const SunatBetaCheckPage(),
    ),
  ],
);
