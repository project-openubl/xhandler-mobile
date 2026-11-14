import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import 'company_repository.dart';

/// Builds a page of the active company: waits for it, goes home when there
/// is none (e.g. it was just deleted), and rebuilds the page from scratch
/// when the user switches company
class ActiveCompanyPage extends ConsumerWidget {
  const ActiveCompanyPage({super.key, required this.builder});

  final Widget Function(Company company) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(activeCompanyProvider);
    if (company case AsyncData(value: final company?)) {
      return KeyedSubtree(key: ValueKey(company.id), child: builder(company));
    }
    if (company case AsyncData() || AsyncError()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(Routes.home);
      });
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
