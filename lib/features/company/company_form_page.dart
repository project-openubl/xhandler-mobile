import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../src/rust/api/ruc.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'company_repository.dart';

/// Creates a company, or edits [company]
class CompanyFormPage extends ConsumerStatefulWidget {
  const CompanyFormPage({super.key, this.company});

  final Company? company;

  @override
  ConsumerState<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends ConsumerState<CompanyFormPage> {
  final _form = GlobalKey<FormState>();
  final _controllers = <TextEditingController>[];
  late final _ruc = _controller(widget.company?.ruc);
  late final _razonSocial = _controller(widget.company?.razonSocial);
  late final _nombreComercial = _controller(widget.company?.nombreComercial);
  late final _direccion = _controller(widget.company?.direccion);
  late final _urbanizacion = _controller(widget.company?.urbanizacion);
  late final _distrito = _controller(widget.company?.distrito);
  late final _provincia = _controller(widget.company?.provincia);
  late final _departamento = _controller(widget.company?.departamento);
  late final _ubigeo = _controller(widget.company?.ubigeo);
  late final _codigoLocal = _controller(widget.company?.codigoLocal ?? '0000');
  late final _telefono = _controller(widget.company?.telefono);
  late final _email = _controller(widget.company?.email);

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
      codigoLocal: Value(optionalText(_codigoLocal) ?? '0000'),
      telefono: optional(_telefono),
      email: optional(_email),
    );
    final repository = ref.read(companyRepositoryProvider);
    final existing = widget.company;
    if (existing != null) {
      await repository.update(existing.id, company);
      if (mounted) showMessage(context, Strings.saved);
      return;
    }

    final ruc = _ruc.text.trim();
    if (await repository.findByRuc(ruc) != null) {
      if (mounted) showMessage(context, Strings.companyExists);
      return;
    }
    await repository.create(company.copyWith(ruc: Value(ruc)));
    if (!mounted) return;
    showMessage(context, Strings.companyCreated);
    context.go(Routes.companySettings);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.company != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? Strings.companyData : Strings.newCompany),
        actions: [SaveButton(onPressed: _save)],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const RequiredFieldsLegend(),
            FormTextField(
              _ruc,
              Strings.ruc,
              required: true,
              enabled: !editing,
              digitsOnly: true,
              maxLength: 11,
              validator: (ruc) =>
                  isRuc(digits: ruc) ? null : Strings.invalidRuc,
            ),
            FormTextField(_razonSocial, Strings.razonSocial, required: true),
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
              digitsOnly: true,
              maxLength: 6,
              validator: (ubigeo) => ubigeo.isEmpty || ubigeo.length == 6
                  ? null
                  : Strings.invalidUbigeo,
            ),
            FormTextField(
              _codigoLocal,
              Strings.codigoLocal,
              digitsOnly: true,
              maxLength: 4,
              validator: (codigo) => codigo.isEmpty || codigo.length == 4
                  ? null
                  : Strings.invalidCodigoLocal,
            ),
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
}
