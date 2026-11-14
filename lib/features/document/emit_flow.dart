import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../src/rust/api/error.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'invoice_draft.dart';

/// Issues [draft] and sends it (waiting at most 30 s; the outbox finishes
/// slow sends). Shows why when it can't be issued and returns `null`.
Future<({String id, DocumentStatus status})?> issueDocument(
  BuildContext context,
  WidgetRef ref, {
  required Company company,
  required Serie serie,
  required InvoiceDraft draft,
}) async {
  final service = ref.read(documentServiceProvider);
  final String id;
  try {
    id = await service.emit(company: company, serie: serie, draft: draft);
  } on Object catch (error) {
    if (context.mounted) {
      showMessage(context, switch (error) {
        InvalidDraftError(:final problem) => draftProblemMessage(problem),
        MissingCertificateError() => Strings.missingCertificate,
        BridgeError(:final message) => documentErrorMessage(message),
        _ => Strings.unexpectedError,
      });
    }
    return null;
  }
  final status = await service
      .send(id)
      .timeout(
        const Duration(seconds: 30),
        onTimeout: () => DocumentStatus.pendingSend,
      );
  return (id: id, status: status);
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
    final color = status.color(Theme.of(context).colorScheme);
    return Padding(
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
    );
  }
}
