import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'document_detail_page.dart';
import 'document_repository.dart';
import 'document_status.dart';
import 'voiding.dart';

/// The company's documents in its current environment, newest first, with
/// filters by status and type and a search by number or customer
class DocumentsList extends ConsumerStatefulWidget {
  const DocumentsList(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends ConsumerState<DocumentsList> {
  DocumentFilter _filter = DocumentFilter.all;
  String _search = '';

  /// The tipos de comprobante shown; empty shows them all
  Set<String> _tipos = const {};

  /// Whether [document] is of a selected type and its number or customer
  /// contains the search text
  bool _matches(Document document) {
    if (_tipos.isNotEmpty && !_tipos.contains(document.tipoComprobante)) {
      return false;
    }
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

  /// The types to filter by, the voiding documents together: those of
  /// [documents], and the ones selected even if none is left
  List<_TypeOption> _typeOptions(List<Document> documents) {
    final shown = {
      for (final document in documents) document.tipoComprobante,
      ..._tipos,
    };
    final options = <_TypeOption>[
      for (final MapEntry(key: tipo, value: label)
          in Catalogs.tiposComprobanteCortos.entries)
        (label: label, tipos: {tipo}),
      (label: Strings.voidingDocuments, tipos: voidingTipos),
    ];
    return [
      for (final option in options)
        if (option.tipos.any(shown.contains)) option,
    ];
  }

  /// "Tipo", "Factura" or "Factura +2", after the selected types
  String _typeChipLabel(List<_TypeOption> options) {
    final selected = options
        .where((option) => _tipos.containsAll(option.tipos))
        .toList();
    return switch (selected) {
      [] => Strings.filterType,
      [final only] => only.label,
      [final first, ...final rest] => '${first.label} +${rest.length}',
    };
  }

  /// A sheet to pick one or more types; the list follows as they are picked
  Future<void> _pickTypes(List<_TypeOption> options) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: StatefulBuilder(
            builder: (sheetContext, setSheetState) {
              void select(Set<String> tipos) {
                setState(() => _tipos = tipos);
                setSheetState(() {});
              }

              return ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text(Strings.tipoComprobante),
                    trailing: _tipos.isEmpty
                        ? null
                        : TextButton(
                            onPressed: () => select(const {}),
                            child: const Text(Strings.clearFilter),
                          ),
                  ),
                  for (final option in options)
                    CheckboxListTile(
                      title: Text(option.label),
                      value: _tipos.containsAll(option.tipos),
                      onChanged: (checked) => select(
                        checked!
                            ? _tipos.union(option.tipos)
                            : _tipos.difference(option.tipos),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final query = documentsProvider((
      companyId: widget.company.id,
      environment: widget.company.sunatEnvironment,
      filter: _filter,
    ));
    final documents = ref.watch(query);
    final typeOptions = _typeOptions(documents.value ?? const []);
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  // The arrow and the tint tell it's on; a check crowds it
                  showCheckmark: false,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_typeChipLabel(typeOptions)),
                      const Icon(Icons.arrow_drop_down, size: 18),
                    ],
                  ),
                  selected: _tipos.isNotEmpty,
                  // Off while there is no type to pick
                  onSelected: typeOptions.isEmpty
                      ? null
                      : (_) => _pickTypes(typeOptions),
                ),
              ),
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
                // 88 dp clears the FAB; the inset clears the navigation bar
                padding:
                    const EdgeInsets.only(bottom: 88) +
                    MediaQuery.paddingOf(context),
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

/// A type in the type filter, with the tipos de comprobante it covers
typedef _TypeOption = ({String label, Set<String> tipos});

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
    final date = formatDate(context, document.fechaEmision);
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
          // The type is cut before the status, which matters more
          Flexible(
            child: Text(
              // Voiding documents already show their type in the title
              voids
                  ? '$date · '
                  : '${tipoComprobanteShortLabel(document.tipoComprobante)} · '
                        '$date · ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
