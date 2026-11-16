import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../series/series_repository.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'document_totals.dart';
import 'draft_problem.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';

/// Writes and issues a factura ("01") or boleta ("03") (docs/DESIGN.md §6.2),
/// in soles, dollars or euros with the exchange rate the user types.
class InvoiceFormPage extends ConsumerStatefulWidget {
  const InvoiceFormPage(
    this.company, {
    super.key,
    required this.tipoComprobante,
  });

  final Company company;
  final String tipoComprobante;

  @override
  ConsumerState<InvoiceFormPage> createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends ConsumerState<InvoiceFormPage> {
  /// The chosen serie; its row (and next number) is read on every build
  String? _serieId;
  Serie? _serie;
  late DraftCustomer? _customer = _isFactura ? null : anonymousCustomer;
  final _lines = <DraftLine>[];
  bool _credito = false;
  final _cuotas = <DraftCuota>[];
  late String _moneda = widget.company.moneda;
  final _tipoCambio = TextEditingController();

  /// The rate when its field got the focus
  String _rateBefore = '';
  DocumentTotals? _totals;
  String? _previewError;
  late final _preview = TotalsPreview((totals, error) {
    if (mounted) {
      setState(() {
        _totals = totals;
        _previewError = error;
      });
    }
  });

  bool get _isFactura => widget.tipoComprobante == '01';

  @override
  void dispose() {
    _preview.dispose();
    _tipoCambio.dispose();
    super.dispose();
  }

  /// Soles per unit of the document's currency; `null` in soles or while
  /// not typed (or unusable)
  String? get _rate {
    if (_moneda == 'PEN') return null;
    final rate = parseAmount(_tipoCambio.text);
    return isValidRate(rate) ? rate : null;
  }

  /// `null` while something required is missing
  InvoiceDraft? get _draft {
    final customer = _customer;
    if (customer == null || _lines.isEmpty || (_credito && _cuotas.isEmpty)) {
      return null;
    }
    return InvoiceDraft(
      tipoComprobante: widget.tipoComprobante,
      customer: customer,
      lines: List.of(_lines),
      moneda: _moneda,
      tipoCambio: _rate,
      cuotas: _credito ? List.of(_cuotas) : const [],
    );
  }

  /// Recomputes the totals with xbuilder, shortly after the last change
  void _changed() {
    setState(() {});
    final customer = _customer;
    final serie = _serie;
    _preview.request(
      customer == null || serie == null || _lines.isEmpty
          ? null
          : () => ref
                .read(documentServiceProvider)
                .preview(
                  company: widget.company,
                  serie: serie,
                  draft: InvoiceDraft(
                    tipoComprobante: widget.tipoComprobante,
                    customer: customer,
                    lines: List.of(_lines),
                    moneda: _moneda,
                    tipoCambio: _rate,
                  ),
                ),
    );
  }

  Future<void> _emit() async {
    final draft = _draft;
    final serie = _serie;
    if (draft == null || serie == null) return;
    await issueAndShowResult(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
  }

  Future<void> _pickCustomer() async {
    final customer = await pickCustomer(
      context,
      company: widget.company,
      forFactura: _isFactura,
    );
    if (customer != null) {
      _customer = customer;
      _changed();
    }
  }

  Future<void> _addProduct() async {
    final rate = _rate;
    // Catalog prices are in soles: converted at the rate, then editable
    // like any line. Without the rate they'd go in unconverted.
    if (_moneda != 'PEN' && rate == null) {
      showMessage(context, draftProblemMessage(DraftProblem.missingTipoCambio));
      return;
    }
    final product = await pickProduct(context, widget.company);
    if (product == null) return;
    var line = DraftLine.fromProduct(product, igvTipo: widget.company.igvTipo);
    if (rate != null) {
      line = line.copyWith(precio: divideAmounts(line.precio, rate, 4));
    }
    _lines.add(line);
    _changed();
  }

  /// Lines already added keep their prices: says so when the currency or
  /// rate changes under them
  void _currencyChanged() {
    if (_lines.isNotEmpty) showMessage(context, Strings.linesNotConverted);
    _changed();
  }

  Future<void> _editLine({int? index}) async {
    final line = await showDialog<DraftLine>(
      context: context,
      builder: (_) => LineDialog(
        line: index == null ? null : _lines[index],
        igvTipo: widget.company.igvTipo,
      ),
    );
    if (line == null) return;
    if (index == null) {
      _lines.add(line);
    } else {
      _lines[index] = line;
    }
    _changed();
  }

  Future<void> _addCuota() async {
    final total = _totals?.total;
    final paid = _cuotas.fold(
      BigInt.zero,
      (sum, c) => sum + toCents(c.importe),
    );
    // What's owed: the total less the detracción the customer deposits
    final remaining = total == null
        ? null
        : toCents(total) - toCents(_totals!.detraccion) - paid;
    final cuota = await showDialog<DraftCuota>(
      context: context,
      builder: (_) => CuotaDialog(
        remaining: remaining == null || remaining <= BigInt.zero
            ? null
            : fromCents(remaining),
      ),
    );
    if (cuota != null) {
      _cuotas.add(cuota);
      _changed();
    }
  }

  /// What still stops issuing, or would make SUNAT reject it
  String? get _warning {
    final total = _totals?.total;
    final customer = _customer;
    if (customer != null &&
        total != null &&
        exceedsAnonymousLimit(customer, _moneda, total, tipoCambio: _rate)) {
      return draftProblemMessage(DraftProblem.anonymousOver700);
    }
    if (_credito && _cuotas.isEmpty) return Strings.creditoWithoutCuotas;
    if (_moneda != 'PEN' && _rate == null) {
      return draftProblemMessage(DraftProblem.missingTipoCambio);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final seriesValue = ref.watch(seriesProvider(widget.company.id)).value;
    final series = activeSeries(
      seriesValue ?? const [],
      widget.tipoComprobante,
    );
    _serieId = chosenSerieId(series, _serieId, widget.tipoComprobante);
    _serie = series.where((s) => s.id == _serieId).firstOrNull;
    final customer = _customer;
    final totals = _totals;
    final warning = _warning;
    final moneda = _moneda;
    final title = _isFactura ? Strings.factura : Strings.boleta;

    return UnsavedChangesGuard(
      dirty: _lines.isNotEmpty,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.company.sunatEnvironment == SunatEnvironment.beta)
              const TestModeBanner(),
            if (seriesValue != null && series.isEmpty)
              MissingSerieWarning(Strings.noSerie(title.toLowerCase())),
            Row(
              children: [
                Expanded(
                  child: SerieDropdown(
                    series: series,
                    value: _serie?.id,
                    onChanged: (id) {
                      _serieId = id;
                      _changed();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${Strings.fechaEmision}\n${formatDate(context, peruToday())}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person),
              title: Text(customer?.nombre ?? Strings.selectCustomer),
              subtitle: customer == null || customer.isAnonymous
                  ? null
                  : Text(
                      '${Catalogs.tiposDocumentoIdentidad[customer.tipoDocumentoIdentidad] ?? ''}'
                      ' ${customer.numeroDocumentoIdentidad}',
                    ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickCustomer,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CatalogDropdown(
                    label: Strings.moneda,
                    value: _moneda,
                    options: Catalogs.monedas,
                    onChanged: (moneda) {
                      if (moneda == _moneda) return;
                      _moneda = moneda!;
                      _currencyChanged();
                    },
                  ),
                ),
                if (moneda != 'PEN') ...[
                  const SizedBox(width: 16),
                  Expanded(
                    // Told once the field is left with another rate, not on
                    // every key
                    child: Focus(
                      onFocusChange: (focused) {
                        if (focused) {
                          _rateBefore = _tipoCambio.text;
                        } else if (_tipoCambio.text != _rateBefore) {
                          _currencyChanged();
                        }
                      },
                      child: TextField(
                        controller: _tipoCambio,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: Strings.tipoCambio,
                          helperText: Strings.tipoCambioHelp,
                          helperMaxLines: 2,
                        ),
                        onChanged: (_) => _changed(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const FormSection(Strings.lines),
            DraftLinesList(
              lines: _lines,
              moneda: moneda,
              onEdit: (index) => _editLine(index: index),
              onRemove: (index) {
                _lines.removeAt(index);
                _changed();
              },
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.inventory_2),
                  label: const Text(Strings.addProduct),
                ),
                OutlinedButton.icon(
                  onPressed: _editLine,
                  icon: const Icon(Icons.edit_note),
                  label: const Text(Strings.freeLine),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.credito),
              value: _credito,
              onChanged: (credito) {
                _credito = credito;
                _changed();
              },
            ),
            if (_credito) ...[
              for (final (index, cuota) in _cuotas.indexed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(formatMoney(moneda, cuota.importe)),
                  subtitle: Text('${Strings.fechaPago}: ${cuota.fechaPago}'),
                  trailing: IconButton(
                    tooltip: Strings.delete,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _cuotas.removeAt(index);
                      _changed();
                    },
                  ),
                ),
              TextButton.icon(
                onPressed: _addCuota,
                icon: const Icon(Icons.add),
                label: const Text(Strings.addCuota),
              ),
            ],
            TotalsSection(totals: totals, error: _previewError, moneda: moneda),
            if (warning != null) DraftWarning(warning),
            const SizedBox(height: 24),
            SaveButton(
              label: Strings.emit,
              filled: true,
              onPressed: _draft == null || _serie == null || warning != null
                  ? null
                  : _emit,
            ),
          ],
        ),
      ),
    );
  }
}
