import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'data/database.dart';

import 'features/backup/backup_page.dart';
import 'features/company/active_company_page.dart';
import 'features/company/certificate_page.dart';
import 'features/company/company_form_page.dart';
import 'features/company/company_settings_page.dart';
import 'features/company/credentials_page.dart';
import 'features/customer/customers_page.dart';
import 'features/customer/lookup_settings_page.dart';
import 'features/delivery/email_settings_page.dart';
import 'features/diagnostics/sunat_beta_check_page.dart';
import 'features/home/home_page.dart';
import 'features/product/products_page.dart';
import 'features/reports/reports_page.dart';
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
  static const lookupSettings = '/company/lookup';
  static const customers = '/company/customers';
  static const products = '/company/products';
  static const emailSettings = '/company/email';
  static const backup = '/backup';
  static const reports = '/company/reports';
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
    _companyRoute(Routes.lookupSettings, LookupSettingsPage.new),
    _companyRoute(Routes.customers, CustomersPage.new),
    _companyRoute(Routes.products, ProductsPage.new),
    _companyRoute(Routes.emailSettings, EmailSettingsPage.new),
    _companyRoute(Routes.reports, ReportsPage.new),
    GoRoute(path: Routes.backup, builder: (_, _) => const BackupPage()),
    GoRoute(
      path: Routes.diagnostics,
      builder: (_, _) => const SunatBetaCheckPage(),
    ),
  ],
);
