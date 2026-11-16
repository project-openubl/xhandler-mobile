import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'product_repository.dart';

/// Creates a product of [company], or edits [product]
class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage(this.company, {super.key, this.product});

  final Company company;
  final Product? product;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  /// Whether the user typed something, to ask before leaving
  bool _edited = false;

  final _form = GlobalKey<FormState>();
  final _controllers = <TextEditingController>[];
  late final _descripcion = _controller(widget.product?.descripcion);
  late final _codigo = _controller(widget.product?.codigo);
  late final _codigoSunat = _controller(widget.product?.codigoSunat);
  late final _precio = _controller(widget.product?.precio);
  late final _iscTasa = _controller(widget.product?.iscTasa);
  late final _detraccionPorcentaje = _controller(
    widget.product?.detraccionPorcentaje,
  );
  late final _detraccionCodigo = _controller(widget.product?.detraccionCodigo);
  late String _unidadMedida = widget.product?.unidadMedida ?? 'NIU';

  /// `null`: the company's IGV type, which may change later
  late String? _igvTipo = widget.product?.igvTipo;
  late String? _iscTipo = widget.product?.iscTipo;
  late bool _precioIncluyeIgv = widget.product?.precioIncluyeIgv ?? true;
  late bool _esBolsa = widget.product?.esBolsa ?? false;
  late bool _favorito = widget.product?.favorito ?? false;

  TextEditingController _controller(String? text) {
    final controller = TextEditingController(text: text);
    _controllers.add(controller);
    return controller;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
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
      codigoSunat: Value(optionalText(_codigoSunat)),
      unidadMedida: Value(_unidadMedida),
      precio: Value(parseAmount(_precio.text)!),
      precioIncluyeIgv: Value(_precioIncluyeIgv),
      igvTipo: Value(_igvTipo),
      iscTipo: Value(_iscTipo),
      iscTasa: Value(_iscTipo == null ? null : parseAmount(_iscTasa.text)),
      esBolsa: Value(_esBolsa),
      detraccionCodigo: Value(optionalText(_detraccionCodigo)),
      detraccionPorcentaje: Value(
        optionalText(_detraccionCodigo) == null
            ? null
            : parseAmount(_detraccionPorcentaje.text),
      ),
      favorito: Value(_favorito),
    );
    final repository = ref.read(productRepositoryProvider);
    final existing = widget.product;
    if (existing == null) {
      await repository.create(product);
    } else {
      await repository.update(existing.id, product);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Widget _switch(String title, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        value: value,
        // Switches aren't form fields: they mark the form edited themselves
        onChanged: (value) {
          _edited = true;
          onChanged(value);
        },
      );

  @override
  Widget build(BuildContext context) {
    final existing = widget.product;
    final companyIgv = Catalogs.igvTipos[widget.company.igvTipo];
    return UnsavedChangesGuard(
      dirty: _edited,
      child: Scaffold(
        appBar: AppBar(
          title: Text(existing == null ? Strings.newProduct : Strings.product),
          actions: [
            if (existing != null)
              DeleteButton(
                message: Strings.deleteProductConfirm,
                onDelete: () =>
                    ref.read(productRepositoryProvider).delete(existing.id),
              ),
            SaveButton(onPressed: _save),
          ],
        ),
        body: Form(
          onChanged: _edited ? null : () => setState(() => _edited = true),
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
              CatalogDropdown(
                label: Strings.unidadMedida,
                value: _unidadMedida,
                options: Catalogs.unidadesMedida,
                onChanged: (unidad) => setState(() => _unidadMedida = unidad!),
              ),
              FormTextField(
                _precio,
                '${Strings.precio} (${widget.company.moneda})',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (precio) =>
                    parseAmount(precio) == null ? Strings.invalidPrecio : null,
              ),
              _switch(
                Strings.precioIncluyeIgv,
                _precioIncluyeIgv,
                (value) => setState(() => _precioIncluyeIgv = value),
              ),
              CatalogDropdown(
                label: Strings.igvTipo,
                value: _igvTipo,
                options: Catalogs.igvTipos,
                noneLabel: '${Strings.igvTipoDefault} (${companyIgv ?? '-'})',
                onChanged: (tipo) => setState(() => _igvTipo = tipo),
              ),
              _switch(
                Strings.esBolsa,
                _esBolsa,
                (value) => setState(() => _esBolsa = value),
              ),
              _switch(
                Strings.favorito,
                _favorito,
                (value) => setState(() => _favorito = value),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                // Collapsed fields must still be validated
                maintainState: true,
                title: const Text(Strings.moreOptions),
                initiallyExpanded:
                    _iscTipo != null ||
                    _detraccionCodigo.text.isNotEmpty ||
                    _codigoSunat.text.isNotEmpty,
                children: [
                  FormTextField(
                    _codigoSunat,
                    Strings.codigoSunat,
                    digitsOnly: true,
                    maxLength: 8,
                  ),
                  CatalogDropdown(
                    label: Strings.iscTipo,
                    value: _iscTipo,
                    options: Catalogs.iscTipos,
                    noneLabel: '—',
                    onChanged: (tipo) => setState(() => _iscTipo = tipo),
                  ),
                  if (_iscTipo != null)
                    FormTextField(
                      _iscTasa,
                      Strings.iscTasa,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (tasa) => parseAmount(tasa) == null
                          ? Strings.invalidIscTasa
                          : null,
                    ),
                  FormTextField(
                    _detraccionCodigo,
                    Strings.detraccionCodigo,
                    digitsOnly: true,
                    maxLength: 3,
                    validator: (codigo) => codigo.isEmpty || codigo.length == 3
                        ? null
                        : Strings.invalidDetraccionCodigo,
                  ),
                  FormTextField(
                    _detraccionPorcentaje,
                    Strings.detraccionPorcentaje,
                    helperText: Strings.detraccionPorcentajeHelp,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // Needed with a code
                    validator: (tasa) => optionalText(_detraccionCodigo) == null
                        ? null
                        : switch (parseAmount(tasa)) {
                            final rate? when toCents(rate) < toCents('100') =>
                              null,
                            _ => Strings.invalidDetraccionPorcentaje,
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
