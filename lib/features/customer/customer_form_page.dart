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

/// Creates a customer of [company], or edits [customer]; pops the saved
/// customer
class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage(this.company, {super.key, this.customer});

  final Company company;
  final Customer? customer;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _form = GlobalKey<FormState>();
  final _controllers = <TextEditingController>[];
  late String _tipo = widget.customer?.tipoDocumentoIdentidad ?? '6';
  late final _numero = _controller(widget.customer?.numeroDocumentoIdentidad);
  late final _nombre = _controller(widget.customer?.nombre);
  late final _direccion = _controller(widget.customer?.direccion);
  late final _distrito = _controller(widget.customer?.distrito);
  late final _provincia = _controller(widget.customer?.provincia);
  late final _departamento = _controller(widget.customer?.departamento);
  late final _ubigeo = _controller(widget.customer?.ubigeo);
  late final _email = _controller(widget.customer?.email);
  late final _telefono = _controller(widget.customer?.telefono);
  bool _lookingUp = false;

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

  bool get _numeric => _tipo == '6' || _tipo == '1';

  bool get _canLookUp =>
      widget.company.lookupProvider != LookupProvider.none && _numeric;

  String? _validateNumero(String numero) {
    final length = Catalogs.numeroDocumentoLength[_tipo] ?? 15;
    return switch (_tipo) {
      '6' => isRuc(digits: numero) ? null : Strings.invalidRuc,
      '1' => RegExp(r'^\d{8}$').hasMatch(numero) ? null : Strings.invalidDni,
      _ =>
        RegExp('^[A-Za-z0-9]{1,$length}\$').hasMatch(numero)
            ? null
            : Strings.invalidNumeroDocumento(length),
    };
  }

  Future<void> _lookUp() async {
    final numero = _numero.text.trim();
    if (_validateNumero(numero) != null) {
      _form.currentState!.validate();
      return;
    }
    final repository = ref.read(companyRepositoryProvider);
    final lookup = ref.read(customerLookupProvider);
    setState(() => _lookingUp = true);
    String? message;
    try {
      final result = await lookup.lookup(
        company: widget.company,
        secrets: await repository.readSecrets(widget.company.id),
        tipoDocumentoIdentidad: _tipo,
        numero: numero,
      );
      // The user may have typed another number meanwhile
      if (_numero.text.trim() != numero) return;
      if (result == null) {
        message = Strings.lookupNotFound;
      } else {
        _nombre.text = result.nombre;
        _direccion.text = result.direccion ?? '';
        _distrito.text = result.distrito ?? '';
        _provincia.text = result.provincia ?? '';
        _departamento.text = result.departamento ?? '';
        _ubigeo.text = result.ubigeo ?? '';
      }
    } on LookupError catch (error) {
      message = switch (error.kind) {
        LookupErrorKind.authentication => Strings.lookupAuthentication,
        LookupErrorKind.quota => Strings.lookupQuota,
        LookupErrorKind.other => Strings.lookupFailed,
      };
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
    if (mounted && message != null) showMessage(context, message);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(customerRepositoryProvider);
    final numero = _numero.text.trim().toUpperCase();
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
      distrito: Value(optionalText(_distrito)),
      provincia: Value(optionalText(_provincia)),
      departamento: Value(optionalText(_departamento)),
      ubigeo: Value(optionalText(_ubigeo)),
      email: Value(optionalText(_email)),
      telefono: Value(optionalText(_telefono)),
    );
    final existing = widget.customer;
    final Customer saved;
    if (existing == null) {
      saved = await repository.create(customer);
    } else {
      await repository.update(existing.id, customer);
      saved = await repository.find(existing.id);
    }
    // The invoice form's picker selects the customer it just created
    if (mounted) Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.customer;
    return Scaffold(
      appBar: AppBar(
        title: Text(existing == null ? Strings.newCustomer : Strings.customer),
        actions: [
          if (existing != null)
            DeleteButton(
              message: Strings.deleteCustomerConfirm,
              onDelete: () =>
                  ref.read(customerRepositoryProvider).delete(existing.id),
            ),
          SaveButton(onPressed: _lookingUp ? null : _save),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CatalogDropdown(
              label: Strings.tipoDocumentoIdentidad,
              value: _tipo,
              options: Catalogs.tiposDocumentoIdentidad,
              onChanged: (tipo) {
                setState(() => _tipo = tipo!);
                if (_numero.text.isNotEmpty) _form.currentState!.validate();
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormTextField(
                    _numero,
                    Strings.numeroDocumento,
                    key: ValueKey(_tipo),
                    digitsOnly: _numeric,
                    maxLength: Catalogs.numeroDocumentoLength[_tipo],
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
            const FormSection(Strings.direccion),
            FormTextField(_direccion, Strings.direccion),
            FormTextField(_distrito, Strings.distrito),
            FormTextField(_provincia, Strings.provincia),
            FormTextField(_departamento, Strings.departamento),
            FormTextField(
              _ubigeo,
              Strings.ubigeo,
              digitsOnly: true,
              maxLength: 6,
              validator: (ubigeo) => ubigeo.isEmpty || ubigeo.length == 6
                  ? null
                  : Strings.invalidUbigeo,
            ),
            const FormSection(Strings.contacto),
            FormTextField(
              _email,
              Strings.email,
              keyboardType: TextInputType.emailAddress,
              validator: (email) =>
                  email.isEmpty || RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)
                  ? null
                  : Strings.invalidEmail,
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
