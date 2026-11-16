import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../series/series_repository.dart';
import 'document_status.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';
import 'perception_retention_draft.dart';

/// Issues a comprobante de percepción ("40") or retención ("20") of one
/// collection or payment of a factura (docs/DESIGN.md §6)
class PerceptionRetentionFormPage extends ConsumerStatefulWidget {
  const PerceptionRetentionFormPage(
    this.company, {
    super.key,
    required this.tipoComprobante,
  });

  final Company company;
  final String tipoComprobante;

  @override
  ConsumerState<PerceptionRetentionFormPage> createState() =>
      _PerceptionRetentionFormPageState();
}

/// "F001-123"
final _facturaSerieNumero = RegExp(
  r'^(E001|F[A-Z0-9]{3}|\d{4})-(?!0+$)\d{1,8}$',
);

class _PerceptionRetentionFormPageState
    extends ConsumerState<PerceptionRetentionFormPage> {
  /// Whether the user typed something, to ask before leaving
  bool _edited = false;

  final _form = GlobalKey<FormState>();
  String? _serieId;
  Serie? _serie;
  DraftCustomer? _customer;
  String _tipoRegimen = '01';
  final _comprobante = TextEditingController();
  final _total = TextEditingController();
  final _importe = TextEditingController();
  final _observaciones = TextEditingController();
  final _today = DateTime.parse(peruToday());
  late DateTime _fechaComprobante = _today;
  late DateTime _fechaOperacion = _today;

  bool get _isPercepcion => widget.tipoComprobante == '40';

  /// SUNAT takes collections and payments from the factura's date and this
  /// month (codes 2612, 2625)
  DateTime get _firstFechaOperacion {
    final month = DateTime(_today.year, _today.month);
    return _fechaComprobante.isAfter(month) ? _fechaComprobante : month;
  }

  @override
  void dispose() {
    _comprobante.dispose();
    _total.dispose();
    _importe.dispose();
    _observaciones.dispose();
    super.dispose();
  }

  /// `null` while something required is missing or invalid
  PerceptionRetentionDraft? get _draft {
    final customer = _customer;
    final total = parseAmount(_total.text);
    final importe = _importe.text.trim().isEmpty
        ? total
        : parseAmount(_importe.text);
    if (customer == null ||
        total == null ||
        importe == null ||
        !_facturaSerieNumero.hasMatch(_comprobante.text.trim())) {
      return null;
    }
    return PerceptionRetentionDraft(
      tipoComprobante: widget.tipoComprobante,
      customer: customer,
      tipoRegimen: _tipoRegimen,
      comprobanteSerieNumero: _comprobante.text.trim(),
      comprobanteFechaEmision: isoDate(_fechaComprobante),
      comprobanteTotal: total,
      importeOperacion: importe,
      fechaOperacion: isoDate(_fechaOperacion),
      observaciones: optionalText(_observaciones),
    );
  }

  Future<void> _emit() async {
    final draft = _draft;
    final serie = _serie;
    if (!_form.currentState!.validate() || draft == null || serie == null) {
      return;
    }
    await issueAndShowResult(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
  }

  Future<void> _pickCustomer() async {
    final customer = await pickCustomer(
      context,
      company: widget.company,
      forFactura: true,
    );
    if (customer != null) {
      setState(() {
        _customer = customer;
        _edited = true;
      });
    }
  }

  Future<DateTime?> _pickDate(DateTime initial, {DateTime? first}) =>
      showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: first ?? _today.subtract(const Duration(days: 3650)),
        lastDate: _today,
      );

  @override
  Widget build(BuildContext context) {
    final seriesValue = ref.watch(seriesProvider(widget.company.id)).value;
    final series = activeSeries(
      seriesValue ?? const [],
      widget.tipoComprobante,
    );
    _serieId = chosenSerieId(series, _serieId, widget.tipoComprobante);
    _serie = series.where((s) => s.id == _serieId).firstOrNull;
    final title = _isPercepcion ? Strings.percepcion : Strings.retencion;
    final regimenes = _isPercepcion
        ? Catalogs.tiposRegimenPercepcion
        : Catalogs.tiposRegimenRetencion;
    final customer = _customer;

    return UnsavedChangesGuard(
      dirty: _edited,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Form(
          onChanged: _edited ? null : () => setState(() => _edited = true),
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.company.sunatEnvironment == SunatEnvironment.beta)
                const TestModeBanner(),
              if (seriesValue != null && series.isEmpty)
                MissingSerieWarning(Strings.noSerie(title.toLowerCase())),
              SerieDropdown(
                series: series,
                value: _serie?.id,
                onChanged: (id) => setState(() => _serieId = id),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.business),
                title: Text(
                  customer?.nombre ??
                      (_isPercepcion
                          ? Strings.selectCustomer
                          : Strings.selectSupplier),
                ),
                subtitle: customer == null
                    ? null
                    : Text('RUC ${customer.numeroDocumentoIdentidad}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickCustomer,
              ),
              if (regimenes.length > 1)
                CatalogDropdown(
                  label: Strings.regimen,
                  value: _tipoRegimen,
                  options: regimenes,
                  onChanged: (tipo) => setState(() => _tipoRegimen = tipo!),
                ),
              const FormSection(Strings.factura),
              FormTextField(
                _comprobante,
                Strings.facturaSerieNumero,
                helperText: 'F001-123',
                validator: (text) => _facturaSerieNumero.hasMatch(text.trim())
                    ? null
                    : Strings.invalidSerieNumero,
              ),
              _DateTile(
                label: Strings.fechaEmision,
                date: _fechaComprobante,
                onTap: () async {
                  final picked = await _pickDate(_fechaComprobante);
                  if (picked != null) {
                    setState(() {
                      _edited = true;
                      _fechaComprobante = picked;
                      if (_fechaOperacion.isBefore(_firstFechaOperacion)) {
                        _fechaOperacion = _firstFechaOperacion;
                      }
                    });
                  }
                },
              ),
              FormTextField(
                _total,
                Strings.facturaTotal,
                prefixText: 'S/ ',
                helperText: Strings.onlySoles,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (text) =>
                    parseAmount(text) == null ? Strings.invalidPrecio : null,
              ),
              FormSection(_isPercepcion ? Strings.cobro : Strings.pago),
              FormTextField(
                _importe,
                Strings.importe,
                prefixText: 'S/ ',
                helperText: Strings.importeHelp,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (text) => text.isEmpty || parseAmount(text) != null
                    ? null
                    : Strings.invalidPrecio,
              ),
              _DateTile(
                label: _isPercepcion ? Strings.fechaCobro : Strings.fechaPago,
                date: _fechaOperacion,
                onTap: () async {
                  final picked = await _pickDate(
                    _fechaOperacion,
                    first: _firstFechaOperacion,
                  );
                  if (picked != null) {
                    setState(() {
                      _fechaOperacion = picked;
                      _edited = true;
                    });
                  }
                },
              ),
              FormTextField(_observaciones, Strings.observaciones),
              ListenableBuilder(
                listenable: Listenable.merge([_comprobante, _total, _importe]),
                builder: (context, _) => _Summary(_draft),
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: Listenable.merge([_comprobante, _total, _importe]),
                builder: (context, _) => SaveButton(
                  label: Strings.emit,
                  filled: true,
                  onPressed: _draft == null || _serie == null ? null : _emit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(isoDate(date)),
      trailing: const Icon(Icons.calendar_month),
      onTap: onTap,
    );
  }
}

/// The amount perceived or withheld, and what's paid in the end
class _Summary extends StatelessWidget {
  const _Summary(this.draft);

  final PerceptionRetentionDraft? draft;

  @override
  Widget build(BuildContext context) {
    final draft = this.draft;
    if (draft == null) return const SizedBox.shrink();
    final problem = draft.problem;
    if (problem != null) return DraftWarning(draftProblemMessage(problem));
    final bold = Theme.of(context).textTheme.titleMedium;
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${draft.isPercepcion ? Strings.percibido : Strings.retenido}'
                  ' (${draft.porcentaje}%)',
                ),
                Text(formatMoney(draft.moneda, draft.importe)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  draft.isPercepcion
                      ? Strings.totalCobrado
                      : Strings.totalPagado,
                  style: bold,
                ),
                Text(formatMoney(draft.moneda, draft.importeNeto), style: bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
