import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import 'document_repository.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'emit_flow.dart';
import '../despatch/despatch_advice_form_page.dart';
import 'note_form_page.dart';
import 'voiding.dart';

/// A document: its status, SUNAT's answer and history (docs/DESIGN.md §5)
class DocumentDetailPage extends ConsumerWidget {
  const DocumentDetailPage({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentProvider(documentId)).value;
    if (document == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final events =
        ref.watch(documentEventsProvider(documentId)).value ?? const [];
    final related =
        ref.watch(relatedDocumentsProvider(documentId)).value ?? const [];
    final colors = Theme.of(context).colorScheme;
    final notes = document.sunatNotes == null
        ? const <String>[]
        : (jsonDecode(document.sunatNotes!) as List).cast<String>();
    final localMessage = localCodeMessage(document.sunatCode);
    final answer = [
      // Problems of the app aren't SUNAT's answers
      if (localMessage != null)
        localMessage
      else ...[
        if (document.sunatCode != null)
          '${Strings.sunatAnswer}: ${document.sunatCode}',
        ?document.sunatDescription,
        ...notes,
      ],
    ];
    final action = document.status.actionLabel;
    final company = ref.watch(activeCompanyProvider).value;
    // Documents of the active company in its current environment
    final isActive =
        company != null &&
        company.id == document.companyId &&
        company.sunatEnvironment == document.environment;
    final isAccepted = DocumentService.accepted.contains(document.status);
    // Notas modify accepted facturas and boletas
    final canHaveNotes =
        isActive &&
        isAccepted &&
        const {'01', '03'}.contains(document.tipoComprobante);
    final canVoid =
        isActive &&
        isAccepted &&
        voidableTipos.contains(document.tipoComprobante) &&
        inVoidingTime(document, peruToday());
    final affectedId = document.affectedDocumentId;
    final voidedById = document.voidedByDocumentId;

    return Scaffold(
      appBar: AppBar(title: Text(serieNumero(document.serie, document.numero))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(
              document.status.icon,
              size: 40,
              color: document.status.color(colors),
            ),
            title: Text(
              document.status.label,
              style: TextStyle(color: document.status.color(colors)),
            ),
            subtitle: Text(document.status.help),
          ),
          if (answer.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(answer.join('\n')),
              ),
            ),
          if (action != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SaveButton(
                label: action,
                filled: true,
                onPressed: () async {
                  final status = await ref
                      .read(documentServiceProvider)
                      .send(document.id, manual: true);
                  if (context.mounted) showMessage(context, status.label);
                },
              ),
            ),
          if (canHaveNotes || canVoid)
            Wrap(
              spacing: 8,
              children: [
                if (canHaveNotes)
                  for (final (tipo, label) in const [
                    ('07', Strings.notaCredito),
                    ('08', Strings.notaDebito),
                  ])
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => NoteFormPage(
                            company,
                            affected: document,
                            tipoComprobante: tipo,
                          ),
                        ),
                      ),
                      child: Text(label),
                    ),
                if (canHaveNotes)
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            DespatchAdviceFormPage(company, related: document),
                      ),
                    ),
                    child: const Text(Strings.guia),
                  ),
                if (canVoid)
                  OutlinedButton(
                    onPressed: () => _void(context, ref, document),
                    child: const Text(Strings.voidDocument),
                  ),
              ],
            ),
          ListTile(
            title: Text(tipoComprobanteLabel(document.tipoComprobante)),
            subtitle: Text('${Strings.fechaEmision}: ${document.fechaEmision}'),
          ),
          if (affectedId != null)
            _DocumentLink(
              affectedId,
              label: switch (document.tipoComprobante) {
                final tipo when voidingTipos.contains(tipo) => Strings.voids,
                '09' => Strings.guiaOf,
                _ => Strings.affectedDocument,
              },
            ),
          if (voidedById != null &&
              (document.status == DocumentStatus.voided ||
                  document.status == DocumentStatus.voiding))
            _DocumentLink(voidedById, label: Strings.voidedBy),
          ListTile(
            title: Text(document.clienteNombre),
            subtitle: Text(
              '${Catalogs.tiposDocumentoIdentidad[document.clienteTipoDocumento] ?? ''}'
              ' ${document.clienteNumeroDocumento}',
            ),
          ),
          // Guías have no amounts
          if (document.tipoComprobante != '09')
            ListTile(
              title: const Text(Strings.total),
              trailing: Text(
                formatMoney(document.moneda, document.total),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (related.any(
            (d) => !voidingTipos.contains(d.tipoComprobante),
          )) ...[
            const FormSection(Strings.notes),
            for (final note in related)
              if (!voidingTipos.contains(note.tipoComprobante))
                _DocumentTile(note),
          ],
          const FormSection(Strings.timeline),
          // Merged repeats (e.g. hourly retries) show their last time
          for (final event in events.reversed)
            ListTile(
              dense: true,
              leading: Icon(
                event.status.icon,
                color: event.status.color(colors),
              ),
              title: Text(event.status.label),
              subtitle: Text(
                [
                  MaterialLocalizations.of(context)
                      .formatShortDate(event.updatedAt.toLocal()),
                  TimeOfDay.fromDateTime(event.updatedAt.toLocal())
                      .format(context),
                  ?localCodeMessage(event.code) ?? event.code,
                  ?event.message,
                ].join(' · '),
              ),
            ),
        ],
      ),
    );
  }

  /// Asks why, issues the comunicación de baja or resumen and sends it
  /// (waiting at most 30 s; the outbox finishes slow answers)
  Future<void> _void(
    BuildContext context,
    WidgetRef ref,
    Document document,
  ) async {
    final motivo = await showDialog<String>(
      context: context,
      builder: (_) => const _VoidDialog(),
    );
    if (motivo == null || !context.mounted) return;
    final service = ref.read(documentServiceProvider);
    final String voidingId;
    try {
      voidingId = await service.voidDocument(document.id, motivo: motivo);
    } on Object catch (error) {
      if (context.mounted) showMessage(context, issueErrorMessage(error));
      return;
    }
    final status = await service
        .send(voidingId)
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () => DocumentStatus.pendingSend,
        );
    if (!context.mounted) return;
    showMessage(context, switch (status) {
      DocumentStatus.accepted ||
      DocumentStatus.acceptedWithObservations => DocumentStatus.voided.label,
      DocumentStatus.rejected => Strings.voidingRejected,
      _ => DocumentStatus.voiding.label,
    });
  }
}

/// The reason for voiding, which SUNAT asks for
class _VoidDialog extends StatefulWidget {
  const _VoidDialog();

  @override
  State<_VoidDialog> createState() => _VoidDialogState();
}

class _VoidDialogState extends State<_VoidDialog> {
  final _form = GlobalKey<FormState>();
  final _motivo = TextEditingController();

  @override
  void dispose() {
    _motivo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.voidTitle),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(Strings.voidHelp),
            FormTextField(
              _motivo,
              Strings.motivo,
              maxLength: 100,
              helperText: Strings.motivoHelp,
              // SUNAT observes reasons under 3 characters
              validator: (text) => text.length < 3 ? Strings.required : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(context, _motivo.text.trim());
            }
          },
          child: const Text(Strings.voidDocument),
        ),
      ],
    );
  }
}

/// "Modifica F001-00000001", opening that document
class _DocumentLink extends ConsumerWidget {
  const _DocumentLink(this.documentId, {required this.label});

  final String documentId;
  final String Function(String serieNumero) label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentProvider(documentId)).value;
    if (document == null) return const SizedBox.shrink();
    return ListTile(
      leading: const Icon(Icons.link),
      title: Text(label(serieNumero(document.serie, document.numero))),
      trailing: DocumentStatusChip(document.status),
      onTap: () => openDocument(context, document.id),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile(this.document);

  final Document document;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(serieNumero(document.serie, document.numero)),
      subtitle: Text(tipoComprobanteLabel(document.tipoComprobante)),
      trailing: DocumentStatusChip(document.status),
      onTap: () => openDocument(context, document.id),
    );
  }
}

void openDocument(BuildContext context, String documentId) => unawaited(
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DocumentDetailPage(documentId: documentId),
    ),
  ),
);
