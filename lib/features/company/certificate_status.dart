import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../router.dart';
import '../../src/rust/api/signer.dart';
import '../../strings.dart';
import '../document/sunat_bridge.dart';
import 'company_repository.dart';

/// The company's saved certificate, `null` without one. Fails with a
/// `BridgeError` when it can't be opened (e.g. its password no longer works).
final savedCertificateProvider = FutureProvider.autoDispose
    .family<CertificateInfo?, String>((ref, companyId) async {
      final secrets = await ref
          .watch(companyRepositoryProvider)
          .readSecrets(companyId);
      final certificate = secrets.certificate;
      if (certificate == null) return null;
      return ref
          .watch(sunatBridgeProvider)
          .inspect(certificate, secrets.certificatePassword ?? '');
    });

/// Why a certificate valid until [validUntil] needs attention: it expired, or
/// expires within 30 days (DESIGN §11)
String? certificateWarning(DateTime validUntil, {DateTime? now}) {
  final today = now ?? DateTime.now();
  if (validUntil.isBefore(today)) return Strings.certificateExpired;
  if (validUntil.isBefore(today.add(const Duration(days: 30)))) {
    return Strings.certificateExpiresSoon;
  }
  return null;
}

/// Warns on the company's home when its certificate expired or expires soon
class CertificateWarningBanner extends ConsumerWidget {
  const CertificateWarningBanner(this.companyId, {super.key});

  final String companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warning = switch (ref.watch(savedCertificateProvider(companyId))) {
      AsyncData(value: final info?) => certificateWarning(info.validUntil),
      // Signing would fail too
      AsyncError() => Strings.certificateUnreadable,
      _ => null,
    };
    if (warning == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.errorContainer,
      child: ListTile(
        leading: Icon(Icons.warning, color: colors.onErrorContainer),
        title: Text(warning, style: TextStyle(color: colors.onErrorContainer)),
        trailing: TextButton(
          onPressed: () => context.push(Routes.certificate),
          child: const Text(Strings.viewCertificate),
        ),
      ),
    );
  }
}
