import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'document_detail_page.dart';
import 'document_repository.dart';
import 'document_status.dart';
import 'voiding.dart';

/// The company's documents in its current environment, newest first, with
/// filters by status and a search by number or customer
class DocumentsList extends ConsumerStatefulWidget {
  const DocumentsList(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends ConsumerState<DocumentsList> {
  DocumentFilter _filter = DocumentFilter.all;
  String _search = '';

  /// Whether [document]'s number or customer contains the search text
  bool _matches(Document document) {
    final search = _search.toLowerCase();
    return search.isEmpty ||
        // "F001-00000025" or how people type it, "F001-25"
        serieNumero(
          document.serie,
          document.numero,
        ).toLowerCase().contains(search) ||
        '${document.serie}-${document.numero}'.toLowerCase().contains(search) ||
        document.clienteNombre.toLowerCase().contains(search) ||
        document.clienteNumeroDocumento.contains(search);
  }

  static const _filterLabels = {
    DocumentFilter.all: Strings.filterAll,
    DocumentFilter.pending: Strings.pendingDocuments,
    DocumentFilter.accepted: Strings.acceptedDocuments,
    DocumentFilter.problems: Strings.filterProblems,
  };

  @override
  Widget build(BuildContext context) {
    final query = documentsProvider((
      companyId: widget.company.id,
      environment: widget.company.sunatEnvironment,
      filter: _filter,
    ));
    final documents = ref.watch(query);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SearchBar(
            hintText: Strings.searchDocuments,
            leading: const Icon(Icons.search),
            onChanged: (text) => setState(() => _search = text.trim()),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              for (final MapEntry(key: filter, value: label)
                  in _filterLabels.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: switch (documents) {
            AsyncData(value: []) => const Center(
              child: Text(Strings.noDocuments),
            ),
            AsyncData(:final value) => switch (value.where(_matches)) {
              final found when found.isEmpty => const Center(
                child: Text(Strings.noResults),
              ),
              final found => ListView(
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  for (final document in found) _DocumentTile(document),
                ],
              ),
            },
            AsyncError() => ErrorRetry(onRetry: () => ref.invalidate(query)),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile(this.document);

  final Document document;

  @override
  Widget build(BuildContext context) {
    final number = serieNumero(document.serie, document.numero);
    // A comunicación de baja, resumen or reversión voids a sale: it has
    // neither a customer nor an amount of its own
    final voids = voidingTipos.contains(document.tipoComprobante);
    final amount = formatMoney(document.moneda, document.total);
    return ListTile(
      title: Text(
        voids
            ? '${tipoComprobanteLabel(document.tipoComprobante)} $number'
            : '$number · ${document.clienteNombre}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text('${formatDate(context, document.fechaEmision)} · '),
          DocumentStatusChip(document.status),
        ],
      ),
      trailing: voids
          ? null
          // Notas de crédito subtract (U+2212, the minus sign)
          : Text(document.tipoComprobante == '07' ? '−$amount' : amount),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: document.id),
        ),
      ),
    );
  }
}
