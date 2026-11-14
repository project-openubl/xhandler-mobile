import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../src/rust/api/ruc.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'company_repository.dart';

/// Creates a company, or edits the active one when [editActive]
class CompanyFormPage extends ConsumerStatefulWidget {
  const CompanyFormPage({super.key, this.editActive = false});

  final bool editActive;

  @override
  ConsumerState<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends ConsumerState<CompanyFormPage> {
  final _form = GlobalKey<FormState>();
  late final Company? _company = widget.editActive
      ? ref.read(activeCompanyProvider).value
      : null;
  late final _ruc = _controller(_company?.ruc);
  late final _razonSocial = _controller(_company?.razonSocial);
  late final _nombreComercial = _controller(_company?.nombreComercial);
  late final _direccion = _controller(_company?.direccion);
  late final _urbanizacion = _controller(_company?.urbanizacion);
  late final _distrito = _controller(_company?.distrito);
  late final _provincia = _controller(_company?.provincia);
  late final _departamento = _controller(_company?.departamento);
  late final _ubigeo = _controller(_company?.ubigeo);
  late final _codigoLocal = _controller(_company?.codigoLocal ?? '0000');
  late final _telefono = _controller(_company?.telefono);
  late final _email = _controller(_company?.email);

  final _controllers = <TextEditingController>[];

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
    Value<String?> optional(TextEditingController controller) =>
        Value(optionalText(controller));

    final company = CompaniesCompanion(
      razonSocial: Value(_razonSocial.text.trim()),
      nombreComercial: optional(_nombreComercial),
      direccion: optional(_direccion),
      urbanizacion: optional(_urbanizacion),
      distrito: optional(_distrito),
      provincia: optional(_provincia),
      departamento: optional(_departamento),
      ubigeo: optional(_ubigeo),
      codigoLocal: optional(_codigoLocal),
      telefono: optional(_telefono),
      email: optional(_email),
    );
    final repository = ref.read(companyRepositoryProvider);
    final existing = _company;
    if (existing != null) {
      await repository.update(existing.id, company);
    } else {
      final ruc = _ruc.text.trim();
      if (await repository.findByRuc(ruc) != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text(Strings.companyExists)));
        }
        return;
      }
      await repository.create(company.copyWith(ruc: Value(ruc)));
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _company == null ? Strings.newCompany : Strings.companyData,
        ),
        actions: [
          TextButton(onPressed: _save, child: const Text(Strings.save)),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormTextField(
              _ruc,
              Strings.ruc,
              enabled: _company == null,
              keyboardType: TextInputType.number,
              validator: (ruc) =>
                  isRuc(digits: ruc) ? null : Strings.invalidRuc,
            ),
            FormTextField(
              _razonSocial,
              Strings.razonSocial,
              validator: _required,
            ),
            FormTextField(_nombreComercial, Strings.nombreComercial),
            const FormSection(Strings.domicilioFiscal),
            FormTextField(_direccion, Strings.direccion),
            FormTextField(_urbanizacion, Strings.urbanizacion),
            FormTextField(_distrito, Strings.distrito),
            FormTextField(_provincia, Strings.provincia),
            FormTextField(_departamento, Strings.departamento),
            FormTextField(
              _ubigeo,
              Strings.ubigeo,
              keyboardType: TextInputType.number,
              validator: (ubigeo) =>
                  ubigeo.isEmpty || RegExp(r'^\d{6}$').hasMatch(ubigeo)
                  ? null
                  : Strings.invalidUbigeo,
            ),
            FormTextField(_codigoLocal, Strings.codigoLocal),
            const FormSection(Strings.contacto),
            FormTextField(
              _telefono,
              Strings.telefono,
              keyboardType: TextInputType.phone,
            ),
            FormTextField(
              _email,
              Strings.email,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  static String? _required(String text) =>
      text.isEmpty ? Strings.required : null;
}
