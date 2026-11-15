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
import 'document_totals.dart';
import 'draft_problem.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';

/// Counter sales: boletas to "Clientes varios" in a few taps
/// (docs/DESIGN.md §6.1). Quantities are whole units.
class QuickSalePage extends ConsumerStatefulWidget {
  const QuickSalePage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<QuickSalePage> createState() => _QuickSalePageState();
}

class _QuickSalePageState extends ConsumerState<QuickSalePage> {
  /// Product id → the product as first added and its quantity
  final _cart = <String, ({Product product, int cantidad})>{};
  DraftCustomer _customer = anonymousCustomer;
  final _received = TextEditingController();
  DocumentTotals? _totals;
  late final _preview = TotalsPreview((totals, _) {
    if (mounted) setState(() => _totals = totals);
  });

  @override
  void dispose() {
    _preview.dispose();
    _received.dispose();
    super.dispose();
  }

  String get _moneda => widget.company.moneda;

  Serie? get _serie => defaultSerie(
    ref.read(seriesProvider(widget.company.id)).value ?? const [],
    '03',
  );

  InvoiceDraft? get _draft => _cart.isEmpty
      ? null
      : InvoiceDraft(
          tipoComprobante: '03',
          customer: _customer,
          moneda: _moneda,
          lines: [
            for (final (:product, :cantidad) in _cart.values)
              DraftLine.fromProduct(
                product,
                igvTipo: widget.company.igvTipo,
              ).copyWith(cantidad: '$cantidad'),
          ],
        );

  void _add(Product product, int delta) {
    final current = _cart[product.id];
    final cantidad = (current?.cantidad ?? 0) + delta;
    if (cantidad <= 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = (
        product: current?.product ?? product,
        cantidad: cantidad,
      );
    }
    _changed();
  }

  /// The total is cleared at once, so an old one is never charged, and
  /// recomputed by xbuilder shortly after
  void _changed() {
    setState(() => _totals = null);
    final draft = _draft;
    final serie = _serie;
    _preview.request(
      draft == null || serie == null
          ? null
          : () => ref
                .read(documentServiceProvider)
                .preview(company: widget.company, serie: serie, draft: draft),
    );
  }

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
    _cart.clear();
    _customer = anonymousCustomer;
    _received.clear();
    _changed();
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
    final series = ref.watch(seriesProvider(widget.company.id)).value;
    final noSerie = series != null && defaultSerie(series, '03') == null;
    final favorites =
        ref.watch(favoriteProductsProvider(widget.company.id)).value ??
        const <Product>[];
    final total = _totals?.total;
    final needsCustomer =
        total != null && exceedsAnonymousLimit(_customer, _moneda, total);
    final received = parseAmount(_received.text);
    final change = total == null || received == null
        ? null
        : toCents(received) - toCents(total);
    final errorColor = Theme.of(context).colorScheme.error;

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
      body: CustomScrollView(
        slivers: [
          if (widget.company.sunatEnvironment == SunatEnvironment.beta)
            const SliverToBoxAdapter(child: TestModeBanner()),
          if (noSerie)
            SliverToBoxAdapter(
              child: ListTile(
                leading: Icon(Icons.warning, color: errorColor),
                title: Text(Strings.noSerie(Strings.boleta.toLowerCase())),
              ),
            ),
          if (favorites.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(Strings.noFavorites, textAlign: TextAlign.center),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid.extent(
                maxCrossAxisExtent: 160,
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
                              Text(formatMoney(_moneda, product.precio)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          if (_cart.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(Strings.cartEmpty, textAlign: TextAlign.center),
              ),
            )
          else
            SliverList.list(
              children: [
                for (final (:product, :cantidad) in _cart.values)
                  ListTile(
                    title: Text(product.descripcion),
                    subtitle: Text(formatMoney(_moneda, product.precio)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: Strings.removeOne,
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.list(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person),
                  title: Text(_customer.nombre),
                  subtitle: needsCustomer
                      ? ErrorText(
                          draftProblemMessage(DraftProblem.anonymousOver700),
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
                    if (change != null)
                      Text(
                        change.isNegative
                            ? '${Strings.missing}: '
                                  '${formatMoney(_moneda, fromCents(-change))}'
                            : '${Strings.change}: '
                                  '${formatMoney(_moneda, fromCents(change))}',
                        style: change.isNegative
                            ? TextStyle(color: errorColor)
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SaveButton(
            label: total == null
                ? Strings.charge
                : '${Strings.charge} ${formatMoney(_moneda, total)}',
            filled: true,
            onPressed: total == null || needsCustomer || noSerie
                ? null
                : _charge,
          ),
        ),
      ),
    );
  }
}
