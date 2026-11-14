import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../customer/customer_form_page.dart';
import '../customer/customers_page.dart';
import '../product/products_page.dart';
import 'document_service.dart';
import 'invoice_draft.dart';

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
/// new one, or "Clientes varios" for boletas
Future<DraftCustomer?> pickCustomer(
  BuildContext context, {
  required Company company,
  required bool forFactura,
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
        if (!forFactura)
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
