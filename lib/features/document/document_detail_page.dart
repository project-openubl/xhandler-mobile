import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'document_repository.dart';
import 'document_service.dart';
import 'document_status.dart';

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
          ListTile(
            title: Text(
              Catalogs.tiposComprobante[document.tipoComprobante] ??
                  document.tipoComprobante,
            ),
            subtitle: Text('${Strings.fechaEmision}: ${document.fechaEmision}'),
          ),
          ListTile(
            title: Text(document.clienteNombre),
            subtitle: Text(
              '${Catalogs.tiposDocumentoIdentidad[document.clienteTipoDocumento] ?? ''}'
              ' ${document.clienteNumeroDocumento}',
            ),
          ),
          ListTile(
            title: const Text(Strings.total),
            trailing: Text(
              formatMoney(document.moneda, document.total),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
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
}
