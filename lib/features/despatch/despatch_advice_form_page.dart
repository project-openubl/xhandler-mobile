import 'dart:convert';

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
import '../document/document_status.dart';
import '../document/emit_flow.dart';
import '../document/invoice_draft.dart';
import '../document/invoice_form_parts.dart';
import '../series/series_repository.dart';
import 'despatch_advice_draft.dart';
import 'transport_pickers.dart';

/// Issues a guía de remisión remitente ("09"), from scratch or for the goods
/// of a factura or boleta ([related]) (docs/DESIGN.md §6)
class DespatchAdviceFormPage extends ConsumerStatefulWidget {
  const DespatchAdviceFormPage(this.company, {super.key, this.related});

  final Company company;
  final Document? related;

  @override
  ConsumerState<DespatchAdviceFormPage> createState() =>
      _DespatchAdviceFormPageState();
}

class _DespatchAdviceFormPageState
    extends ConsumerState<DespatchAdviceFormPage> {
  String? _serieId;
  late DraftCustomer? _customer;
  late final List<DraftLine> _lines;
  String _motivo = '01';
  final _motivoDescripcion = TextEditingController();
  final _peso = TextEditingController();
  final _bultos = TextEditingController();
  late DateTime _fechaTraslado = DateTime.parse(peruToday());
  String _modalidad = ModalidadTraslado.privado;
  bool _vehiculoM1L = false;
  Vehicle? _vehicle;
  Driver? _driver;
  DraftCustomer? _transportista;
  final _mtc = TextEditingController();
  GuiaPoint? _partida;
  GuiaPoint? _llegada;

  @override
  void initState() {
    super.initState();
    final related = widget.related;
    if (related == null) {
      _customer = null;
      _lines = [];
      return;
    }
    // The goods and customer of the factura or boleta
    final spec =
        (jsonDecode(related.inputJson) as Map<String, Object?>)['spec']!
            as Map<String, Object?>;
    _customer = DraftCustomer.fromJson(
      spec['cliente']! as Map<String, Object?>,
    );
    _lines = [
      for (final line in spec['detalles']! as List)
        DraftLine.fromJson(line as Map<String, Object?>),
    ];
  }

  @override
  void dispose() {
    _motivoDescripcion.dispose();
    _peso.dispose();
    _bultos.dispose();
    _mtc.dispose();
    super.dispose();
  }

  /// The company is its own destinatario when moving goods between its
  /// establishments
  DraftCustomer get _company => DraftCustomer(
    tipoDocumentoIdentidad: '6',
    numeroDocumentoIdentidad: widget.company.ruc,
    nombre: widget.company.razonSocial,
  );

  DespatchAdviceDraft? get _draft {
    final customer = _motivo == '04' ? _company : _customer;
    final peso = parseAmount(_peso.text);
    if (customer == null || peso == null) return null;
    return DespatchAdviceDraft(
      customer: customer,
      lines: List.of(_lines),
      motivo: _motivo,
      motivoDescripcion: _motivo == '13'
          ? optionalText(_motivoDescripcion)
          : null,
      fechaTraslado: isoDate(_fechaTraslado),
      pesoTotal: peso,
      numeroBultos: int.tryParse(_bultos.text.trim()),
      modalidad: _modalidad,
      vehiculoM1L: _vehiculoM1L,
      vehicle: _vehicle,
      driver: _driver,
      transportista: _transportista,
      transportistaMtc: optionalText(_mtc),
      partida: _partida,
      llegada: _llegada,
      related: widget.related,
    );
  }

  /// Points suggested for [forPartida]: the company's address, or the
  /// customer's
  List<(String, GuiaPoint)> _suggested({required bool forPartida}) {
    final company = widget.company;
    final customer = _customer;
    final (label, ubigeo, direccion) = forPartida
        ? (Strings.companyAddress, company.ubigeo, company.direccion)
        : (Strings.customerAddress, customer?.ubigeo, customer?.direccion);
    if (ubigeo == null || direccion == null || ubigeo.isEmpty) return const [];
    return [(label, (ubigeo: ubigeo, direccion: direccion, codigoLocal: null))];
  }

  Future<void> _editLine({int? index}) async {
    final line = await showDialog<DraftLine>(
      context: context,
      builder: (_) =>
          _GuiaLineDialog(line: index == null ? null : _lines[index]),
    );
    if (line == null) return;
    setState(() {
      if (index == null) {
        _lines.add(line);
      } else {
        _lines[index] = line;
      }
    });
  }

  Future<void> _emit(Serie serie) async {
    final draft = _draft;
    if (draft == null) return;
    await issueAndShowResult(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final seriesValue = ref.watch(seriesProvider(widget.company.id)).value;
    final series = activeSeries(seriesValue ?? const [], '09');
    _serieId = chosenSerieId(series, _serieId, '09');
    final serie = series.where((s) => s.id == _serieId).firstOrNull;
    final related = widget.related;
    final draft = _draft;
    final problem = draft?.problem;
    final isPrivado = _modalidad == ModalidadTraslado.privado;
    final customer = _motivo == '04' ? _company : _customer;

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.guia)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.company.sunatEnvironment == SunatEnvironment.beta)
            const TestModeBanner(),
          if (seriesValue != null && series.isEmpty)
            MissingSerieWarning(Strings.noSerie(Strings.guia.toLowerCase())),
          SerieDropdown(
            series: series,
            value: serie?.id,
            onChanged: (id) => setState(() => _serieId = id),
          ),
          if (related != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: Text(
                Strings.guiaOf(serieNumero(related.serie, related.numero)),
              ),
            ),
          CatalogDropdown(
            label: Strings.motivoTraslado,
            value: _motivo,
            options: Catalogs.motivosTraslado,
            onChanged: (motivo) => setState(() => _motivo = motivo!),
          ),
          if (_motivo == '13')
            FormTextField(_motivoDescripcion, Strings.motivoDescripcion),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person),
            title: Text(customer?.nombre ?? Strings.selectDestinatario),
            subtitle: customer == null
                ? null
                : Text(customer.numeroDocumentoIdentidad),
            trailing: _motivo == '04' ? null : const Icon(Icons.chevron_right),
            onTap: _motivo == '04'
                ? null
                : () async {
                    final picked = await pickCustomer(
                      context,
                      company: widget.company,
                      forFactura: false,
                      allowAnonymous: false,
                    );
                    if (picked != null) setState(() => _customer = picked);
                  },
          ),
          const FormSection(Strings.traslado),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(Strings.fechaTraslado),
            subtitle: Text(isoDate(_fechaTraslado)),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final today = DateTime.parse(peruToday());
              final picked = await showDatePicker(
                context: context,
                initialDate: _fechaTraslado,
                firstDate: today,
                lastDate: today.add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _fechaTraslado = picked);
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _peso,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: Strings.pesoTotal,
                    suffixText: 'kg',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _bultos,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: Strings.numeroBultos,
                  ),
                ),
              ),
            ],
          ),
          _PointTile(
            label: Strings.partida,
            point: _partida,
            onTap: () async {
              final point = await pickAddress(
                context,
                widget.company,
                suggested: _suggested(forPartida: true),
              );
              if (point != null) setState(() => _partida = point);
            },
          ),
          _PointTile(
            label: Strings.llegada,
            point: _llegada,
            onTap: () async {
              final point = await pickAddress(
                context,
                widget.company,
                suggested: _suggested(forPartida: false),
              );
              if (point != null) setState(() => _llegada = point);
            },
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: ModalidadTraslado.privado,
                label: Text(Strings.transportePrivado),
              ),
              ButtonSegment(
                value: ModalidadTraslado.publico,
                label: Text(Strings.transportePublico),
              ),
            ],
            selected: {_modalidad},
            onSelectionChanged: (selected) =>
                setState(() => _modalidad = selected.single),
          ),
          if (isPrivado) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.vehiculoM1L),
              subtitle: const Text(Strings.vehiculoM1LHelp),
              value: _vehiculoM1L,
              onChanged: (value) => setState(() => _vehiculoM1L = value),
            ),
            if (!_vehiculoM1L) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_shipping),
                title: Text(_vehicle?.placa ?? Strings.selectVehicle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final vehicle = await pickVehicle(context, widget.company);
                  if (vehicle != null) setState(() => _vehicle = vehicle);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.badge),
                title: Text(switch (_driver) {
                  final driver? => '${driver.nombres} ${driver.apellidos}',
                  null => Strings.selectDriver,
                }),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final driver = await pickDriver(context, widget.company);
                  if (driver != null) setState(() => _driver = driver);
                },
              ),
            ],
          ] else ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_shipping),
              title: Text(_transportista?.nombre ?? Strings.selectCarrier),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final carrier = await pickCustomer(
                  context,
                  company: widget.company,
                  forFactura: true,
                );
                if (carrier != null) setState(() => _transportista = carrier);
              },
            ),
            FormTextField(
              _mtc,
              Strings.registroMtc,
              helperText: Strings.optional,
            ),
          ],
          const FormSection(Strings.bienes),
          DraftLinesList(
            lines: _lines,
            moneda: '',
            showPrices: false,
            onEdit: (index) => _editLine(index: index),
            onRemove: (index) => setState(() => _lines.removeAt(index)),
          ),
          OutlinedButton.icon(
            onPressed: _editLine,
            icon: const Icon(Icons.add),
            label: const Text(Strings.addBien),
          ),
          if (problem != null && _lines.isNotEmpty)
            DraftWarning(draftProblemMessage(problem)),
          const SizedBox(height: 24),
          SaveButton(
            label: Strings.emit,
            filled: true,
            onPressed: draft == null || problem != null || serie == null
                ? null
                : () => _emit(serie),
          ),
        ],
      ),
    );
  }
}

class _PointTile extends StatelessWidget {
  const _PointTile({
    required this.label,
    required this.point,
    required this.onTap,
  });

  final String label;
  final GuiaPoint? point;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final point = this.point;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.place),
      title: Text(label),
      subtitle: Text(
        point == null
            ? Strings.selectAddress
            : '${point.direccion} · ${point.ubigeo}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// What is moved: description, quantity and unit
class _GuiaLineDialog extends StatefulWidget {
  const _GuiaLineDialog({required this.line});

  final DraftLine? line;

  @override
  State<_GuiaLineDialog> createState() => _GuiaLineDialogState();
}

class _GuiaLineDialogState extends State<_GuiaLineDialog> {
  final _form = GlobalKey<FormState>();
  late final _descripcion = TextEditingController(
    text: widget.line?.descripcion,
  );
  late final _cantidad = TextEditingController(
    text: widget.line?.cantidad ?? '1',
  );
  late String _unidad = widget.line?.unidadMedida ?? 'NIU';

  @override
  void dispose() {
    _descripcion.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.bien),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormTextField(
              _descripcion,
              Strings.descripcion,
              validator: (text) => text.isEmpty ? Strings.required : null,
            ),
            FormTextField(
              _cantidad,
              Strings.cantidad,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (text) =>
                  parseAmount(text) == null ? Strings.invalidCantidad : null,
            ),
            CatalogDropdown(
              label: Strings.unidadMedida,
              value: _unidad,
              options: Catalogs.unidadesMedida,
              onChanged: (unidad) => setState(() => _unidad = unidad!),
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
            final descripcion = _descripcion.text.trim();
            final cantidad = parseAmount(_cantidad.text)!;
            final line = widget.line;
            Navigator.pop(
              context,
              line == null
                  ? DraftLine(
                      descripcion: descripcion,
                      cantidad: cantidad,
                      precio: '0',
                      unidadMedida: _unidad,
                    )
                  : line.copyWith(
                      descripcion: descripcion,
                      cantidad: cantidad,
                      unidadMedida: _unidad,
                    ),
            );
          },
          child: Text(widget.line == null ? Strings.add : Strings.save),
        ),
      ],
    );
  }
}
