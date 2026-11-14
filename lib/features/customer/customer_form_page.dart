import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../src/rust/api/ruc.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import 'customer_lookup.dart';
import 'customer_repository.dart';

/// Creates a customer of [company], or edits [customer]
class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage(this.company, {super.key, this.customer});

  final Company company;
  final Customer? customer;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _form = GlobalKey<FormState>();
  late String _tipo = widget.customer?.tipoDocumentoIdentidad ?? '6';
  late final _numero = TextEditingController(
    text: widget.customer?.numeroDocumentoIdentidad,
  );
  late final _nombre = TextEditingController(text: widget.customer?.nombre);
  late final _direccion = TextEditingController(
    text: widget.customer?.direccion,
  );
  late final _email = TextEditingController(text: widget.customer?.email);
  late final _telefono = TextEditingController(text: widget.customer?.telefono);
  bool _lookingUp = false;

  @override
  void dispose() {
    for (final controller in [
      _numero,
      _nombre,
      _direccion,
      _email,
      _telefono,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  bool get _canLookUp =>
      widget.company.lookupProvider != LookupProvider.none &&
      (_tipo == '6' || _tipo == '1');

  String? _validateNumero(String numero) => switch (_tipo) {
    '6' => isRuc(digits: numero) ? null : Strings.invalidRuc,
    '1' => RegExp(r'^\d{8}$').hasMatch(numero) ? null : Strings.invalidDni,
    _ => numero.isEmpty ? Strings.required : null,
  };

  Future<void> _lookUp() async {
    final numero = _numero.text.trim();
    if (_validateNumero(numero) != null) {
      _form.currentState!.validate();
      return;
    }
    final secrets = ref
        .read(companyRepositoryProvider)
        .readSecrets(widget.company.id);
    final lookup = ref.read(customerLookupProvider);
    setState(() => _lookingUp = true);
    String? message;
    try {
      final result = await lookup.lookup(
        company: widget.company,
        secrets: await secrets,
        tipoDocumentoIdentidad: _tipo,
        numero: numero,
      );
      if (result == null) {
        message = Strings.lookupNotFound;
      } else {
        _nombre.text = result.nombre;
        if (result.direccion != null) _direccion.text = result.direccion!;
      }
    } on Exception {
      message = Strings.lookupFailed;
    }
    if (!mounted) return;
    setState(() => _lookingUp = false);
    if (message != null) showMessage(context, message);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(customerRepositoryProvider);
    final numero = _numero.text.trim();
    final duplicate = await repository.findByDocument(
      widget.company.id,
      _tipo,
      numero,
    );
    if (duplicate != null && duplicate.id != widget.customer?.id) {
      if (mounted) showMessage(context, Strings.customerExists);
      return;
    }
    final customer = CustomersCompanion(
      companyId: Value(widget.company.id),
      tipoDocumentoIdentidad: Value(_tipo),
      numeroDocumentoIdentidad: Value(numero),
      nombre: Value(_nombre.text.trim()),
      direccion: Value(optionalText(_direccion)),
      email: Value(optionalText(_email)),
      telefono: Value(optionalText(_telefono)),
    );
    final existing = widget.customer;
    if (existing == null) {
      await repository.create(customer);
    } else {
      await repository.update(existing.id, customer);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final repository = ref.read(customerRepositoryProvider);
    if (!await confirm(
      context,
      message: Strings.deleteCustomerConfirm,
      accept: Strings.delete,
    )) {
      return;
    }
    await repository.delete(widget.customer!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer == null ? Strings.newCustomer : Strings.customer,
        ),
        actions: [
          if (widget.customer != null)
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
            DropdownButtonFormField(
              initialValue: _tipo,
              decoration: const InputDecoration(
                labelText: Strings.tipoDocumentoIdentidad,
              ),
              items: [
                for (final MapEntry(:key, :value)
                    in Catalogs.tiposDocumentoIdentidad.entries)
                  DropdownMenuItem(value: key, child: Text(value)),
              ],
              onChanged: (tipo) => setState(() => _tipo = tipo!),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormTextField(
                    _numero,
                    Strings.numeroDocumento,
                    digitsOnly: _tipo == '6' || _tipo == '1',
                    maxLength: 15,
                    validator: _validateNumero,
                  ),
                ),
                if (_canLookUp)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: _lookingUp
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton.filledTonal(
                            tooltip: Strings.lookup,
                            icon: const Icon(Icons.travel_explore),
                            onPressed: _lookUp,
                          ),
                  ),
              ],
            ),
            FormTextField(
              _nombre,
              Strings.nombre,
              validator: (nombre) => nombre.isEmpty ? Strings.required : null,
            ),
            FormTextField(_direccion, Strings.direccion),
            FormTextField(
              _email,
              Strings.email,
              keyboardType: TextInputType.emailAddress,
            ),
            FormTextField(
              _telefono,
              Strings.telefono,
              helperText: Strings.telefonoHelp,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
