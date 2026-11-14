import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../strings.dart';
import 'document_detail_page.dart';
import 'document_repository.dart';
import 'document_status.dart';

/// The company's documents in its current environment, newest first, with
/// filters by status
class DocumentsList extends ConsumerStatefulWidget {
  const DocumentsList(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends ConsumerState<DocumentsList> {
  DocumentFilter _filter = DocumentFilter.all;

  static const _filterLabels = {
    DocumentFilter.all: Strings.filterAll,
    DocumentFilter.pending: 'Por enviar',
    DocumentFilter.accepted: 'Aceptados',
    DocumentFilter.problems: Strings.filterProblems,
  };

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(
      documentsProvider((company: widget.company, filter: _filter)),
    );
    return Column(
      children: [
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
            AsyncData(:final value) => ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [for (final document in value) _DocumentTile(document)],
            ),
            AsyncError() => const Center(child: Text(Strings.unexpectedError)),
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
    return ListTile(
      title: Text(
        '${document.serie}-${document.numero.toString().padLeft(8, '0')}'
        ' · ${document.clienteNombre}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: DocumentStatusChip(document.status),
      trailing: Text('${document.moneda} ${document.total}'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: document.id),
        ),
      ),
    );
  }
}
