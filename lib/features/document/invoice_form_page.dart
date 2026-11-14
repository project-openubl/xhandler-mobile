import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../src/rust/api/error.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../customer/customer_form_page.dart';
import '../customer/customer_repository.dart';
import '../product/product_repository.dart';
import '../series/series_repository.dart';
import 'document_detail_page.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'invoice_draft.dart';

/// Writes and issues a factura ("01") or boleta ("03") (docs/DESIGN.md §6.2)
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
  late DraftCustomer? _customer = widget.tipoComprobante == '03'
      ? anonymousCustomer
      : null;
  late String _moneda = widget.company.moneda;
  final _lines = <DraftLine>[];
  bool _credito = false;
  final _cuotas = <DraftCuota>[];
  DocumentTotals? _totals;
  Timer? _previewTimer;

  bool get _isFactura => widget.tipoComprobante == '01';

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
  }

  InvoiceDraft? get _draft {
    final customer = _customer;
    if (customer == null || _lines.isEmpty) return null;
    return InvoiceDraft(
      tipoComprobante: widget.tipoComprobante,
      customer: customer,
      lines: List.of(_lines),
      moneda: _moneda,
      cuotas: _credito ? List.of(_cuotas) : const [],
    );
  }

  /// Recomputes the totals with xbuilder, shortly after the last change
  void _changed() {
    setState(() {});
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(milliseconds: 300), () async {
      final draft = _draft;
      final serie = _serie;
      if (draft == null || serie == null) {
        if (mounted) setState(() => _totals = null);
        return;
      }
      try {
        final totals = await ref
            .read(documentServiceProvider)
            .preview(company: widget.company, serie: serie, draft: draft);
        if (mounted) setState(() => _totals = totals);
      } on BridgeError {
        if (mounted) setState(() => _totals = null);
      }
    });
  }

  Future<void> _emit() async {
    final draft = _draft;
    final serie = _serie;
    if (draft == null || serie == null) return;
    final service = ref.read(documentServiceProvider);
    final String id;
    try {
      id = await service.emit(
        company: widget.company,
        serie: serie,
        draft: draft,
      );
    } on InvalidDraftError catch (error) {
      if (mounted) showMessage(context, draftProblemMessage(error.problem));
      return;
    } on MissingCertificateError {
      if (mounted) showMessage(context, Strings.missingCertificate);
      return;
    } on BridgeError catch (error) {
      if (mounted) showMessage(context, Strings.invalidDocument(error.message));
      return;
    }
    final status = await service.send(id);
    if (!mounted) return;
    final view = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => EmitResultSheet(status: status),
    );
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (view ?? false) {
      navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: id),
        ),
      );
    } else {
      navigator.pop();
    }
  }

  Future<void> _pickCustomer() async {
    final customer = await showModalBottomSheet<DraftCustomer>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _CustomerPicker(company: widget.company, allowAnonymous: !_isFactura),
    );
    if (customer != null) {
      _customer = customer;
      _changed();
    }
  }

  Future<void> _addProduct() async {
    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ProductPicker(company: widget.company),
    );
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
      builder: (_) => _LineDialog(
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
    final cuota = await showDialog<DraftCuota>(
      context: context,
      builder: (_) => const _CuotaDialog(),
    );
    if (cuota != null) {
      _cuotas.add(cuota);
      _changed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final series =
        (ref.watch(seriesProvider(widget.company.id)).value ?? const [])
            .where(
              (s) => s.tipoComprobante == widget.tipoComprobante && s.active,
            )
            .toList();
    _serieId ??= series
        .where((s) => s.isDefault)
        .followedBy(series)
        .firstOrNull
        ?.id;
    _serie = series.where((s) => s.id == _serieId).firstOrNull;
    final customer = _customer;
    final totals = _totals;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isFactura ? Strings.factura : Strings.boleta),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                        child: Text(
                          '${serie.serie}-${serie.nextNumber.toString().padLeft(8, '0')}',
                        ),
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
            subtitle: customer == null
                ? null
                : Text(
                    '${Catalogs.tiposDocumentoIdentidad[customer.tipoDocumentoIdentidad] ?? ''}'
                    ' ${customer.numeroDocumentoIdentidad}',
                  ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _pickCustomer,
          ),
          CatalogDropdown(
            label: Strings.moneda,
            value: _moneda,
            options: const {'PEN': 'Soles (PEN)', 'USD': 'Dólares (USD)'},
            onChanged: (moneda) {
              _moneda = moneda!;
              _changed();
            },
          ),
          const FormSection(Strings.lines),
          for (final (index, line) in _lines.indexed)
            Dismissible(
              key: ObjectKey(line),
              onDismissed: (_) {
                _lines.removeAt(index);
                _changed();
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(line.descripcion),
                subtitle: Text(
                  '${line.cantidad} × ${line.precio}'
                  '${line.precioIncluyeIgv ? '' : ' + IGV'}',
                ),
                onTap: () => _editLine(index: index),
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
                title: Text('${cuota.importe} · ${cuota.fechaPago}'),
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
          if (totals != null) _TotalsCard(totals, moneda: _moneda),
          const SizedBox(height: 24),
          SaveButton(
            label: Strings.emit,
            filled: true,
            onPressed: _draft == null || _serie == null ? null : _emit,
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
                children: [Text(label), Text('$moneda $amount')],
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Strings.total, style: bold),
                Text('$moneda ${totals.total}', style: bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Picks a customer of the company, a new one, or "Clientes varios"
class _CustomerPicker extends ConsumerStatefulWidget {
  const _CustomerPicker({required this.company, required this.allowAnonymous});

  final Company company;
  final bool allowAnonymous;

  @override
  ConsumerState<_CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends ConsumerState<_CustomerPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final customers =
        ref
            .watch(
              customersProvider((
                companyId: widget.company.id,
                search: _search,
              )),
            )
            .value ??
        const [];
    return _PickerSheet(
      onSearch: (search) => setState(() => _search = search),
      children: [
        if (widget.allowAnonymous)
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text(Strings.anonymousCustomer),
            onTap: () => Navigator.pop(context, anonymousCustomer),
          ),
        ListTile(
          leading: const Icon(Icons.person_add),
          title: const Text(Strings.newCustomer),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CustomerFormPage(widget.company),
            ),
          ),
        ),
        for (final customer in customers)
          ListTile(
            title: Text(customer.nombre),
            subtitle: Text(customer.numeroDocumentoIdentidad),
            onTap: () =>
                Navigator.pop(context, DraftCustomer.fromCustomer(customer)),
          ),
      ],
    );
  }
}

class _ProductPicker extends ConsumerStatefulWidget {
  const _ProductPicker({required this.company});

  final Company company;

  @override
  ConsumerState<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends ConsumerState<_ProductPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final products =
        ref
            .watch(
              productsProvider((companyId: widget.company.id, search: _search)),
            )
            .value ??
        const [];
    return _PickerSheet(
      onSearch: (search) => setState(() => _search = search),
      children: [
        for (final product in products)
          ListTile(
            title: Text(product.descripcion),
            subtitle: Text('${widget.company.moneda} ${product.precio}'),
            onTap: () => Navigator.pop(context, product),
          ),
      ],
    );
  }
}

/// Bottom sheet with a search box over a list
class _PickerSheet extends StatelessWidget {
  const _PickerSheet({required this.onSearch, required this.children});

  final ValueChanged<String> onSearch;
  final List<Widget> children;

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
              onChanged: (text) => onSearch(text.trim()),
            ),
          ),
          Expanded(
            child: ListView(controller: controller, children: children),
          ),
        ],
      ),
    );
  }
}

/// A free-text line, or the quantity and price of an existing one
class _LineDialog extends StatefulWidget {
  const _LineDialog({required this.line, required this.igvTipo});

  final DraftLine? line;
  final String igvTipo;

  @override
  State<_LineDialog> createState() => _LineDialogState();
}

class _LineDialogState extends State<_LineDialog> {
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
    return AlertDialog(
      title: Text(widget.line?.descripcion ?? Strings.freeLine),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.line == null)
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
            if (widget.line == null)
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
        TextButton(onPressed: _save, child: const Text(Strings.add)),
      ],
    );
  }
}

class _CuotaDialog extends StatefulWidget {
  const _CuotaDialog();

  @override
  State<_CuotaDialog> createState() => _CuotaDialogState();
}

class _CuotaDialogState extends State<_CuotaDialog> {
  final _form = GlobalKey<FormState>();
  final _importe = TextEditingController();
  DateTime _fechaPago = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _importe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fecha = isoDate(_fechaPago);
    return AlertDialog(
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
              subtitle: Text(fecha),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaPago,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
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
                fechaPago: fecha,
              ),
            );
          },
          child: const Text(Strings.add),
        ),
      ],
    );
  }
}

/// What happened right after issuing: the document's status and next steps.
/// Pops `true` to view the document.
class EmitResultSheet extends StatelessWidget {
  const EmitResultSheet({super.key, required this.status});

  final DocumentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(Theme.of(context).colorScheme);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(status.icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(
            status.label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text(status.help, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(Strings.viewDocument),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Strings.done),
          ),
        ],
      ),
    );
  }
}
