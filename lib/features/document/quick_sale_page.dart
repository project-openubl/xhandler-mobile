import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../data/database.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../product/product_repository.dart';
import '../series/series_repository.dart';
import 'document_detail_page.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';

/// Counter sales: boletas to "Clientes varios" in a few taps
/// (docs/DESIGN.md §6.1)
class QuickSalePage extends ConsumerStatefulWidget {
  const QuickSalePage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<QuickSalePage> createState() => _QuickSalePageState();
}

class _QuickSalePageState extends ConsumerState<QuickSalePage> {
  /// Product id → quantity, in the order they were added
  final _cart = <String, ({Product product, int cantidad})>{};
  DraftCustomer _customer = anonymousCustomer;
  final _received = TextEditingController();
  String? _total;
  Timer? _previewTimer;
  int _previewRun = 0;

  @override
  void dispose() {
    _previewTimer?.cancel();
    _received.dispose();
    super.dispose();
  }

  InvoiceDraft? get _draft => _cart.isEmpty
      ? null
      : InvoiceDraft(
          tipoComprobante: '03',
          customer: _customer,
          moneda: widget.company.moneda,
          lines: [
            for (final (:product, :cantidad) in _cart.values)
              DraftLine.fromProduct(
                product,
                igvTipo: widget.company.igvTipo,
              ).copyWith(cantidad: '$cantidad'),
          ],
        );

  void _add(Product product, int delta) {
    final cantidad = (_cart[product.id]?.cantidad ?? 0) + delta;
    if (cantidad <= 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = (product: product, cantidad: cantidad);
    }
    _changed();
  }

  /// Recomputes the total with xbuilder, shortly after the last change
  void _changed() {
    setState(() {});
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(milliseconds: 300), () async {
      final run = ++_previewRun;
      final draft = _draft;
      final serie = _serie;
      String? total;
      if (draft != null && serie != null) {
        try {
          total =
              (await ref
                      .read(documentServiceProvider)
                      .preview(
                        company: widget.company,
                        serie: serie,
                        draft: draft,
                      ))
                  .total;
        } on Object {
          total = null;
        }
      }
      if (mounted && run == _previewRun) setState(() => _total = total);
    });
  }

  Serie? get _serie {
    final series =
        ref.read(seriesProvider(widget.company.id)).value ?? const [];
    return series
        .where((s) => s.tipoComprobante == '03' && s.active)
        .sortedByDefault
        .firstOrNull;
  }

  bool get _needsCustomer =>
      _customer == anonymousCustomer &&
      _total != null &&
      toCents(_total!) > toCents('700');

  Future<void> _charge() async {
    final draft = _draft;
    final serie = _serie;
    if (draft == null || serie == null) return;
    final issued = await issueDocument(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
    if (issued == null || !mounted) return;
    final view = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) =>
          EmitResultSheet(status: issued.status, doneLabel: Strings.newSale),
    );
    if (!mounted) return;
    setState(() {
      _cart.clear();
      _customer = anonymousCustomer;
      _received.clear();
      _total = null;
    });
    if (view ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: issued.id),
        ),
      );
    }
  }

  Future<void> _identifyCustomer() async {
    final customer = await pickCustomer(
      context,
      company: widget.company,
      forFactura: false,
    );
    if (customer != null) {
      _customer = customer;
      _changed();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the series loaded for [_serie]
    ref.watch(seriesProvider(widget.company.id));
    final favorites =
        (ref
                    .watch(
                      productsProvider((
                        companyId: widget.company.id,
                        search: '',
                      )),
                    )
                    .value ??
                const <Product>[])
            .where((p) => p.favorito)
            .toList();
    final moneda = widget.company.moneda;
    final total = _total;
    final received = parseAmount(_received.text);
    final change = total == null || received == null
        ? null
        : toCents(received) - toCents(total);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.quickSale),
        actions: [
          IconButton(
            tooltip: Strings.search,
            icon: const Icon(Icons.search),
            onPressed: () async {
              final product = await pickProduct(context, widget.company);
              if (product != null) _add(product, 1);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.company.sunatEnvironment == SunatEnvironment.beta)
            const TestModeBanner(),
          Expanded(
            flex: 3,
            child: favorites.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        Strings.noFavorites,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : GridView.extent(
                    maxCrossAxisExtent: 160,
                    padding: const EdgeInsets.all(8),
                    childAspectRatio: 1.4,
                    children: [
                      for (final product in favorites)
                        Card(
                          child: InkWell(
                            onTap: () => _add(product, 1),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.descripcion,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(formatMoney(moneda, product.precio)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 4,
            child: _cart.isEmpty
                ? const Center(child: Text(Strings.cartEmpty))
                : ListView(
                    children: [
                      for (final (:product, :cantidad) in _cart.values)
                        ListTile(
                          title: Text(product.descripcion),
                          subtitle: Text(formatMoney(moneda, product.precio)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: Strings.delete,
                                icon: const Icon(Icons.remove),
                                onPressed: () => _add(product, -1),
                              ),
                              Text('$cantidad'),
                              IconButton(
                                tooltip: Strings.add,
                                icon: const Icon(Icons.add),
                                onPressed: () => _add(product, 1),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          Material(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person),
                    title: Text(_customer.nombre),
                    subtitle: _needsCustomer
                        ? Text(
                            draftProblemMessage(DraftProblem.anonymousOver700),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          )
                        : null,
                    trailing: TextButton(
                      onPressed: _identifyCustomer,
                      child: const Text(Strings.identifyCustomer),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _received,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: Strings.received,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        change == null || change.isNegative
                            ? ''
                            : '${Strings.change}: '
                                  '${formatMoney(moneda, fromCents(change))}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SaveButton(
                    label: total == null
                        ? Strings.charge
                        : '${Strings.charge} ${formatMoney(moneda, total)}',
                    filled: true,
                    onPressed: _cart.isEmpty || _needsCustomer ? null : _charge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Iterable<Serie> {
  /// The default serie first
  List<Serie> get sortedByDefault => [
    ...where((s) => s.isDefault),
    ...where((s) => !s.isDefault),
  ];
}
