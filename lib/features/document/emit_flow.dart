import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app_log.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../notifications.dart';
import '../../src/rust/api/error.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'document_detail_page.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'draft_problem.dart';
import 'invoice_draft.dart';

/// Why a document couldn't be issued, in Spanish
String issueErrorMessage(Object error) => switch (error) {
  InvalidDraftError(:final problem) => draftProblemMessage(problem),
  MissingCertificateError() => Strings.missingCertificate,
  ExpiredCertificateError() => Strings.expiredCertificate,
  BridgeError(:final message) => documentErrorMessage(message),
  _ => Strings.unexpectedError,
};

/// Issues [draft] and sends it (waiting at most 30 s; the outbox finishes
/// slow sends). Shows why when it can't be issued and returns `null`.
Future<({String id, DocumentStatus status})?> issueDocument(
  BuildContext context,
  WidgetRef ref, {
  required Company company,
  required Serie serie,
  required DocumentDraft draft,
}) async {
  final service = ref.read(documentServiceProvider);
  // Read now: the form may be closed by the time SUNAT answers
  final database = ref.read(databaseProvider);
  final String id;
  try {
    id = await service.emit(company: company, serie: serie, draft: draft);
  } on Object catch (error) {
    if (context.mounted) showMessage(context, issueErrorMessage(error));
    return null;
  }
  final status = await service
      .send(id)
      .timeout(
        const Duration(seconds: 30),
        onTimeout: () => DocumentStatus.pendingSend,
      );
  if (status == DocumentStatus.pendingSend ||
      status == DocumentStatus.inProgress) {
    // SUNAT's answer may come in the background: ask to notify it
    unawaited(
      Notifications.requestPermissionOnce(database)
          .catchError((Object error) => AppLog.error('Notifications', error)),
    );
  }
  return (id: id, status: status);
}

/// Issues [draft], shows what happened, and then opens the document or
/// closes the form
Future<void> issueAndShowResult(
  BuildContext context,
  WidgetRef ref, {
  required Company company,
  required Serie serie,
  required DocumentDraft draft,
}) async {
  final issued = await issueDocument(
    context,
    ref,
    company: company,
    serie: serie,
    draft: draft,
  );
  if (issued == null || !context.mounted) return;
  final view = await showModalBottomSheet<bool>(
    context: context,
    builder: (_) => EmitResultSheet(status: issued.status),
  );
  if (!context.mounted) return;
  final navigator = Navigator.of(context);
  if (view ?? false) {
    unawaited(
      navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: issued.id),
        ),
      ),
    );
  } else {
    navigator.pop();
  }
}

/// What happened right after issuing: the document's status and next steps.
/// Pops `true` to view the document.
class EmitResultSheet extends StatelessWidget {
  const EmitResultSheet({
    super.key,
    required this.status,
    this.doneLabel = Strings.done,
  });

  final DocumentStatus status;
  final String doneLabel;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    // A modal sheet reaches the bottom of the screen, behind the navigation bar
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(status.icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              status.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            Text(status.help, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(Strings.viewDocument),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(doneLabel),
            ),
          ],
        ),
      ),
    );
  }
}
