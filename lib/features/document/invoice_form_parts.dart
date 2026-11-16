import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../src/rust/api/error.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../customer/customer_form_page.dart';
import '../customer/customers_page.dart';
import '../product/products_page.dart';
import '../series/series_repository.dart';
import 'document_status.dart';
import 'document_totals.dart';
import 'draft_problem.dart';
import 'invoice_draft.dart';

/// Totals of a draft computed by xbuilder shortly after the last change.
/// Only the latest request counts, even if an older one ends later.
class TotalsPreview {
  TotalsPreview(this._onResult);

  /// Totals, or a Spanish error message; both `null` when cleared
  final void Function(DocumentTotals? totals, String? error) _onResult;
  Timer? _timer;
  int _run = 0;

  /// Recomputes with [compute] after a short pause; `null` clears
  void request(Future<DocumentTotals> Function()? compute) {
    _timer?.cancel();
    final run = ++_run;
    if (compute == null) {
      _onResult(null, null);
      return;
    }
    _timer = Timer(const Duration(milliseconds: 300), () async {
      DocumentTotals? totals;
      String? error;
      try {
        totals = await compute();
      } on BridgeError catch (bridgeError) {
        error = documentErrorMessage(bridgeError.message);
      } on InvalidDraftError catch (invalid) {
        error = draftProblemMessage(invalid.problem);
      } on Object {
        error = Strings.unexpectedError;
      }
      if (run == _run) _onResult(totals, error);
    });
  }

  void dispose() {
    _timer?.cancel();
    _run++;
  }
}

/// Bottom sheet with a search box over a list built for the search text
class _PickerSheet extends StatefulWidget {
  const _PickerSheet({required this.list});

  final Widget Function(String search, ScrollController controller) list;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: Strings.search,
              leading: const Icon(Icons.search),
              onChanged: (text) => setState(() => _search = text.trim()),
            ),
          ),
          Expanded(child: widget.list(_search, controller)),
        ],
      ),
    );
  }
}

/// Picks a customer: one of the company's (only RUC ones for facturas), a
/// new one, or "Clientes varios" for boletas ([allowAnonymous])
Future<DraftCustomer?> pickCustomer(
  BuildContext context, {
  required Company company,
  required bool forFactura,
  bool? allowAnonymous,
}) => showModalBottomSheet<DraftCustomer>(
  context: context,
  isScrollControlled: true,
  builder: (sheetContext) => _PickerSheet(
    list: (search, controller) => CustomerList(
      company,
      search: search,
      onlyRuc: forFactura,
      controller: controller,
      onTap: (customer) =>
          Navigator.pop(sheetContext, DraftCustomer.fromCustomer(customer)),
      leading: [
        if (allowAnonymous ?? !forFactura)
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text(Strings.anonymousCustomer),
            onTap: () => Navigator.pop(sheetContext, anonymousCustomer),
          ),
        ListTile(
          leading: const Icon(Icons.person_add),
          title: const Text(Strings.newCustomer),
          onTap: () async {
            final created = await Navigator.of(sheetContext).push<Customer>(
              MaterialPageRoute(builder: (_) => CustomerFormPage(company)),
            );
            if (created != null && sheetContext.mounted) {
              Navigator.pop(sheetContext, DraftCustomer.fromCustomer(created));
            }
          },
        ),
      ],
    ),
  ),
);

Future<Product?> pickProduct(BuildContext context, Company company) =>
    showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _PickerSheet(
        list: (search, controller) => ProductList(
          company,
          search: search,
          showFavorite: false,
          controller: controller,
          onTap: (product) => Navigator.pop(sheetContext, product),
        ),
      ),
    );

/// A free-text line, or the quantity and price of an existing one
class LineDialog extends StatefulWidget {
  const LineDialog({super.key, required this.line, required this.igvTipo});

  final DraftLine? line;
  final String igvTipo;

  @override
  State<LineDialog> createState() => _LineDialogState();
}

class _LineDialogState extends State<LineDialog> {
  final _form = GlobalKey<FormState>();
  late final _descripcion = TextEditingController(
    text: widget.line?.descripcion,
  );
  late final _cantidad = TextEditingController(
    text: widget.line?.cantidad ?? '1',
  );
  late final _precio = TextEditingController(text: widget.line?.precio);
  late bool _precioIncluyeIgv = widget.line?.precioIncluyeIgv ?? true;

  @override
  void dispose() {
    _descripcion.dispose();
    _cantidad.dispose();
    _precio.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final line = widget.line;
    final cantidad = parseAmount(_cantidad.text)!;
    final precio = parseAmount(_precio.text)!;
    Navigator.pop(
      context,
      line == null
          ? DraftLine(
              descripcion: _descripcion.text.trim(),
              cantidad: cantidad,
              precio: precio,
              precioIncluyeIgv: _precioIncluyeIgv,
              igvTipo: widget.igvTipo,
            )
          : line.copyWith(cantidad: cantidad, precio: precio),
    );
  }

  @override
  Widget build(BuildContext context) {
    const decimal = TextInputType.numberWithOptions(decimal: true);
    final editing = widget.line != null;
    return AlertDialog(
      scrollable: true,
      title: Text(widget.line?.descripcion ?? Strings.freeLine),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!editing)
              FormTextField(
                _descripcion,
                Strings.descripcion,
                validator: (text) => text.isEmpty ? Strings.required : null,
              ),
            FormTextField(
              _cantidad,
              Strings.cantidad,
              keyboardType: decimal,
              validator: (text) =>
                  parseAmount(text) == null ? Strings.invalidCantidad : null,
            ),
            FormTextField(
              _precio,
              Strings.precio,
              keyboardType: decimal,
              validator: (text) =>
                  parseAmount(text) == null ? Strings.invalidPrecio : null,
            ),
            if (!editing)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(Strings.precioIncluyeIgv),
                value: _precioIncluyeIgv,
                onChanged: (value) => setState(() => _precioIncluyeIgv = value),
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
          onPressed: _save,
          child: Text(editing ? Strings.save : Strings.add),
        ),
      ],
    );
  }
}

/// An installment; [remaining] (what's left of the total) is suggested
class CuotaDialog extends StatefulWidget {
  const CuotaDialog({super.key, this.remaining});

  final String? remaining;

  @override
  State<CuotaDialog> createState() => _CuotaDialogState();
}

class _CuotaDialogState extends State<CuotaDialog> {
  final _form = GlobalKey<FormState>();
  late final _importe = TextEditingController(text: widget.remaining);

  /// Dates are Peru's, like the issue date the service compares them with
  final _today = DateTime.parse(peruToday());
  late DateTime _fechaPago = _today.add(const Duration(days: 30));

  @override
  void dispose() {
    _importe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(Strings.addCuota),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormTextField(
              _importe,
              Strings.importe,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (text) =>
                  parseAmount(text) == null ? Strings.invalidPrecio : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.fechaPago),
              subtitle: Text(isoDate(_fechaPago)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaPago,
                  firstDate: _today.add(const Duration(days: 1)),
                  lastDate: _today.add(const Duration(days: 3650)),
                );
                if (picked != null) setState(() => _fechaPago = picked);
              },
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
            if (!_form.currentState!.validate()) return;
            Navigator.pop(
              context,
              DraftCuota(
                importe: parseAmount(_importe.text)!,
                fechaPago: isoDate(_fechaPago),
              ),
            );
          },
          child: const Text(Strings.add),
        ),
      ],
    );
  }
}

/// The serie to issue with, showing the number it will take
class SerieDropdown extends StatelessWidget {
  const SerieDropdown({
    super.key,
    required this.series,
    required this.value,
    required this.onChanged,
  });

  final List<Serie> series;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: Strings.serie),
      items: [
        for (final serie in series)
          DropdownMenuItem(
            value: serie.id,
            child: Text(serieNumero(serie.serie, serie.nextNumber)),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

/// The active series of [tipoComprobante] whose name starts with [prefix]
List<Serie> activeSeries(
  List<Serie> series,
  String tipoComprobante, {
  String prefix = '',
}) => [
  for (final serie in series)
    if (serie.active &&
        serie.tipoComprobante == tipoComprobante &&
        serie.serie.startsWith(prefix))
      serie,
];

/// The default serie among [series], or the one the user chose
String? chosenSerieId(List<Serie> series, String? chosen, String tipo) =>
    series.any((s) => s.id == chosen) ? chosen : defaultSerie(series, tipo)?.id;

class MissingSerieWarning extends StatelessWidget {
  const MissingSerieWarning(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
      title: Text(message),
    );
  }
}

/// The lines of a draft; tapping one edits it. Without [onEdit] and
/// [onRemove] they are read-only.
class DraftLinesList extends StatelessWidget {
  const DraftLinesList({
    super.key,
    required this.lines,
    required this.moneda,
    this.showPrices = true,
    this.onEdit,
    this.onRemove,
  });

  final List<DraftLine> lines;
  final String moneda;

  /// Guías show only quantities
  final bool showPrices;
  final void Function(int index)? onEdit;
  final void Function(int index)? onRemove;

  @override
  Widget build(BuildContext context) {
    final onEdit = this.onEdit;
    final onRemove = this.onRemove;
    return Column(
      children: [
        for (final (index, line) in lines.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(line.descripcion),
            subtitle: Text(
              showPrices
                  ? '${line.cantidad} × ${formatMoney(moneda, line.precio)}'
                        '${line.precioIncluyeIgv ? '' : Strings.plusIgv}'
                  : '${line.cantidad} '
                        '${Catalogs.unidadesMedida[line.unidadMedida] ?? line.unidadMedida}',
            ),
            onTap: onEdit == null ? null : () => onEdit(index),
            trailing: onRemove == null
                ? null
                : IconButton(
                    tooltip: Strings.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => onRemove(index),
                  ),
          ),
      ],
    );
  }
}

/// The totals xbuilder computed, or why it couldn't
class TotalsSection extends StatelessWidget {
  const TotalsSection({
    super.key,
    required this.totals,
    required this.error,
    required this.moneda,
  });

  final DocumentTotals? totals;
  final String? error;
  final String moneda;

  @override
  Widget build(BuildContext context) {
    final totals = this.totals;
    final error = this.error;
    if (error != null) {
      return ListTile(
        leading: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        title: Text(error),
      );
    }
    if (totals == null) return const SizedBox.shrink();
    final rows = [
      (Strings.opGravada, totals.gravado),
      (Strings.opExonerada, totals.exonerado),
      (Strings.opInafecta, totals.inafecto),
      (Strings.opExportacion, totals.exportacion),
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
            // Part of the total the customer deposits for SUNAT
            if (toCents(totals.detraccion) != BigInt.zero)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(Strings.detraccion),
                  Text(formatMoney(moneda, totals.detraccion)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// A warning in the error color, under the totals
class DraftWarning extends StatelessWidget {
  const DraftWarning(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ErrorText(message),
    );
  }
}
