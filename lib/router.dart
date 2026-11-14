import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'data/database.dart';

import 'features/company/active_company_page.dart';
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
  static const newCompany = '/new-company';
  static const companySettings = '/company';
  static const editCompany = '/company/edit';
  static const certificate = '/company/certificate';
  static const credentials = '/company/credentials';
  static const series = '/company/series';
  static const diagnostics = '/company/diagnostics';
}

GoRoute _companyRoute(String path, Widget Function(Company) page) => GoRoute(
  path: path,
  builder: (_, _) => ActiveCompanyPage(builder: page),
);

GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
    GoRoute(
      path: Routes.newCompany,
      builder: (_, _) => const CompanyFormPage(),
    ),
    _companyRoute(Routes.companySettings, CompanySettingsPage.new),
    _companyRoute(
      Routes.editCompany,
      (company) => CompanyFormPage(company: company),
    ),
    _companyRoute(Routes.certificate, CertificatePage.new),
    _companyRoute(Routes.credentials, CredentialsPage.new),
    _companyRoute(Routes.series, SeriesPage.new),
    GoRoute(
      path: Routes.diagnostics,
      builder: (_, _) => const SunatBetaCheckPage(),
    ),
  ],
);
