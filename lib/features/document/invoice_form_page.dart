import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../series/series_repository.dart';
import 'document_detail_page.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';

/// Writes and issues a factura ("01") or boleta ("03") (docs/DESIGN.md §6.2).
/// Amounts are in the company's currency (no exchange rate yet).
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
  DocumentTotals? _totals;
  String? _previewError;
  Timer? _previewTimer;

  /// Only the latest preview is shown, even if an older one ends later
  int _previewRun = 0;

  bool get _isFactura => widget.tipoComprobante == '01';

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
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
      moneda: widget.company.moneda,
      cuotas: _credito ? List.of(_cuotas) : const [],
    );
  }

  /// Recomputes the totals with xbuilder, shortly after the last change
  void _changed() {
    setState(() {});
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(milliseconds: 300), _preview);
  }

  Future<void> _preview() async {
    final run = ++_previewRun;
    final customer = _customer;
    final serie = _serie;
    DocumentTotals? totals;
    String? error;
    if (customer != null && serie != null && _lines.isNotEmpty) {
      try {
        totals = await ref
            .read(documentServiceProvider)
            .preview(
              company: widget.company,
              serie: serie,
              draft: InvoiceDraft(
                tipoComprobante: widget.tipoComprobante,
                customer: customer,
                lines: List.of(_lines),
                moneda: widget.company.moneda,
              ),
            );
      } on BridgeError catch (bridgeError) {
        error = documentErrorMessage(bridgeError.message);
      } on Object {
        error = Strings.unexpectedError;
      }
    }
    if (!mounted || run != _previewRun) return;
    setState(() {
      _totals = totals;
      _previewError = error;
    });
  }

  Future<void> _emit() async {
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
      builder: (_) => EmitResultSheet(status: issued.status),
    );
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (view ?? false) {
      navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: issued.id),
        ),
      );
    } else {
      navigator.pop();
    }
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
    final product = await pickProduct(context, widget.company);
    if (product != null) {
      _lines.add(
        DraftLine.fromProduct(product, igvTipo: widget.company.igvTipo),
      );
      _changed();
    }
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
    final remaining = total == null ? null : toCents(total) - paid;
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
    if (_customer == anonymousCustomer &&
        total != null &&
        toCents(total) > toCents('700')) {
      return draftProblemMessage(DraftProblem.anonymousOver700);
    }
    if (_credito && _cuotas.isEmpty) return Strings.creditoWithoutCuotas;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final seriesValue = ref.watch(seriesProvider(widget.company.id)).value;
    final series = (seriesValue ?? const <Serie>[])
        .where((s) => s.tipoComprobante == widget.tipoComprobante && s.active)
        .toList();
    _serieId ??= series
        .where((s) => s.isDefault)
        .followedBy(series)
        .firstOrNull
        ?.id;
    _serie = series.where((s) => s.id == _serieId).firstOrNull;
    final customer = _customer;
    final totals = _totals;
    final warning = _warning;
    final moneda = widget.company.moneda;
    final title = _isFactura ? Strings.factura : Strings.boleta;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.company.sunatEnvironment == SunatEnvironment.beta)
            const TestModeBanner(),
          if (seriesValue != null && series.isEmpty)
            ListTile(
              leading: Icon(
                Icons.warning,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(Strings.noSerie(title.toLowerCase())),
            ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _serie?.id,
                  decoration: const InputDecoration(labelText: Strings.serie),
                  items: [
                    for (final serie in series)
                      DropdownMenuItem(
                        value: serie.id,
                        child: Text(serieNumero(serie.serie, serie.nextNumber)),
                      ),
                  ],
                  onChanged: (id) {
                    _serieId = id;
                    _changed();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Text('${Strings.fechaEmision}\n${peruToday()}'),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person),
            title: Text(customer?.nombre ?? Strings.selectCustomer),
            subtitle: customer == null || customer == anonymousCustomer
                ? null
                : Text(
                    '${Catalogs.tiposDocumentoIdentidad[customer.tipoDocumentoIdentidad] ?? ''}'
                    ' ${customer.numeroDocumentoIdentidad}',
                  ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _pickCustomer,
          ),
          const FormSection(Strings.lines),
          for (final (index, line) in _lines.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(line.descripcion),
              subtitle: Text(
                '${line.cantidad} × ${formatMoney(moneda, line.precio)}'
                '${line.precioIncluyeIgv ? '' : ' + IGV'}',
              ),
              onTap: () => _editLine(index: index),
              trailing: IconButton(
                tooltip: Strings.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  _lines.removeAt(index);
                  _changed();
                },
              ),
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
          if (_previewError != null)
            ListTile(
              leading: Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(_previewError!),
            )
          else if (totals != null)
            _TotalsCard(totals, moneda: moneda),
          if (warning != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                warning,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
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
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard(this.totals, {required this.moneda});

  final DocumentTotals totals;
  final String moneda;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (Strings.opGravada, totals.gravado),
      (Strings.opExonerada, totals.exonerado),
      (Strings.opInafecta, totals.inafecto),
      (Strings.isc, totals.isc),
      (Strings.igv, totals.igv),
      (Strings.icbper, totals.icb),
    ].where((row) => toCents(row.$2) != BigInt.zero);
    final bold = Theme.of(context).textTheme.titleMedium;
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final (label, amount) in rows)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(label), Text(formatMoney(moneda, amount))],
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Strings.total, style: bold),
                Text(formatMoney(moneda, totals.total), style: bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
