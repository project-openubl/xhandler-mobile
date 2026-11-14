import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'product_repository.dart';

final _decimal = RegExp(r'^\d+(\.\d{1,10})?$');

/// Creates a product of [company], or edits [product]
class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage(this.company, {super.key, this.product});

  final Company company;
  final Product? product;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _form = GlobalKey<FormState>();
  late final Product? _product = widget.product;
  late final _descripcion = TextEditingController(text: _product?.descripcion);
  late final _codigo = TextEditingController(text: _product?.codigo);
  late final _precio = TextEditingController(text: _product?.precio);
  late final _iscTasa = TextEditingController(text: _product?.iscTasa);
  late final _detraccionCodigo = TextEditingController(
    text: _product?.detraccionCodigo,
  );
  late String _unidadMedida = _product?.unidadMedida ?? 'NIU';
  late String _igvTipo = _product?.igvTipo ?? widget.company.igvTipo;
  late String? _iscTipo = _product?.iscTipo;
  late bool _precioIncluyeIgv = _product?.precioIncluyeIgv ?? true;
  late bool _esBolsa = _product?.esBolsa ?? false;
  late bool _favorito = _product?.favorito ?? false;

  @override
  void dispose() {
    for (final controller in [
      _descripcion,
      _codigo,
      _precio,
      _iscTasa,
      _detraccionCodigo,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final product = ProductsCompanion(
      companyId: Value(widget.company.id),
      descripcion: Value(_descripcion.text.trim()),
      codigo: Value(optionalText(_codigo)),
      unidadMedida: Value(_unidadMedida),
      precio: Value(_precio.text.trim()),
      precioIncluyeIgv: Value(_precioIncluyeIgv),
      igvTipo: Value(_igvTipo),
      iscTipo: Value(_iscTipo),
      iscTasa: Value(_iscTipo == null ? null : optionalText(_iscTasa)),
      esBolsa: Value(_esBolsa),
      detraccionCodigo: Value(optionalText(_detraccionCodigo)),
      favorito: Value(_favorito),
    );
    final repository = ref.read(productRepositoryProvider);
    final existing = _product;
    if (existing == null) {
      await repository.create(product);
    } else {
      await repository.update(existing.id, product);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final repository = ref.read(productRepositoryProvider);
    if (!await confirm(
      context,
      message: Strings.deleteProductConfirm,
      accept: Strings.delete,
    )) {
      return;
    }
    await repository.delete(_product!.id);
    if (mounted) Navigator.of(context).pop();
  }

  Widget _dropdown(
    String label,
    String? value,
    Map<String, String> options,
    ValueChanged<String?> onChanged, {
    bool optional = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String?>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        if (optional) const DropdownMenuItem(child: Text('—')),
        for (final MapEntry(:key, :value) in options.entries)
          DropdownMenuItem(value: key, child: Text(value)),
      ],
      onChanged: onChanged,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product == null ? Strings.newProduct : Strings.product),
        actions: [
          if (_product != null)
            IconButton(
              tooltip: Strings.delete,
              icon: const Icon(Icons.delete),
              onPressed: _delete,
            ),
          SaveButton(onPressed: _save),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormTextField(
              _descripcion,
              Strings.descripcion,
              validator: (text) => text.isEmpty ? Strings.required : null,
            ),
            FormTextField(_codigo, Strings.codigo),
            _dropdown(
              Strings.unidadMedida,
              _unidadMedida,
              Catalogs.unidadesMedida,
              (unidad) => setState(() => _unidadMedida = unidad!),
            ),
            FormTextField(
              _precio,
              '${Strings.precio} (${widget.company.moneda})',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (precio) =>
                  _decimal.hasMatch(precio) ? null : Strings.invalidPrecio,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.precioIncluyeIgv),
              value: _precioIncluyeIgv,
              onChanged: (value) => setState(() => _precioIncluyeIgv = value),
            ),
            _dropdown(
              Strings.igvTipo,
              _igvTipo,
              Catalogs.igvTipos,
              (tipo) => setState(() => _igvTipo = tipo!),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.esBolsa),
              value: _esBolsa,
              onChanged: (value) => setState(() => _esBolsa = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.favorito),
              value: _favorito,
              onChanged: (value) => setState(() => _favorito = value),
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(Strings.moreOptions),
              initiallyExpanded:
                  _iscTipo != null || _detraccionCodigo.text.isNotEmpty,
              children: [
                _dropdown(
                  Strings.iscTipo,
                  _iscTipo,
                  Catalogs.iscTipos,
                  (tipo) => setState(() => _iscTipo = tipo),
                  optional: true,
                ),
                if (_iscTipo != null)
                  FormTextField(
                    _iscTasa,
                    Strings.iscTasa,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (tasa) =>
                        _decimal.hasMatch(tasa) ? null : Strings.invalidPrecio,
                  ),
                FormTextField(
                  _detraccionCodigo,
                  Strings.detraccionCodigo,
                  digitsOnly: true,
                  maxLength: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
