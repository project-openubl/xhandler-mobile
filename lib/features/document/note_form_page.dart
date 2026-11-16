import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../series/series_repository.dart';
import 'document_repository.dart';
import 'document_service.dart';
import 'document_status.dart';
import 'document_totals.dart';
import 'draft_problem.dart';
import 'emit_flow.dart';
import 'invoice_draft.dart';
import 'invoice_form_parts.dart';

/// Issues a nota de crédito ("07") or débito ("08") of [affected], an
/// accepted factura or boleta (docs/DESIGN.md §6)
class NoteFormPage extends ConsumerStatefulWidget {
  const NoteFormPage(
    this.company, {
    super.key,
    required this.affected,
    required this.tipoComprobante,
  });

  final Company company;
  final Document affected;
  final String tipoComprobante;

  @override
  ConsumerState<NoteFormPage> createState() => _NoteFormPageState();
}

/// Notas de crédito that take back the whole invoice: annulment, wrong RUC
/// and full return carry its lines as they were
const _wholeInvoiceTipos = {'01', '02', '06'};

/// Notas adjusting exports: crédito 11, débito 10 (by document type, as
/// crédito 10 is "otros conceptos")
const _exportTipos = {'07': '11', '08': '10'};

class _NoteFormPageState extends ConsumerState<NoteFormPage> {
  /// Whether the user changed the copy of the affected document
  bool _edited = false;

  late final _spec =
      (jsonDecode(widget.affected.inputJson) as Map<String, Object?>)['spec']
          as Map<String, Object?>;
  late final _customer = DraftCustomer.fromJson(
    _spec['cliente']! as Map<String, Object?>,
  );

  /// A nota de crédito starts with the invoice's lines, to edit or remove
  late final _lines = _isCredito ? _invoiceLines() : <DraftLine>[];
  String _tipoNota = '01';

  /// The corrected installments of a type 13 nota de crédito
  final _cuotas = <DraftCuota>[];
  late final _sustento = TextEditingController(text: _tiposNota[_tipoNota]);
  String? _serieId;
  DocumentTotals? _totals;
  String? _previewError;
  late final _preview = TotalsPreview((totals, error) {
    if (mounted) {
      setState(() {
        _totals = totals;
        _previewError = error;
      });
    }
  });

  bool get _isCredito => widget.tipoComprobante == '07';

  String get _letter => widget.affected.serie.substring(0, 1);

  /// Series of the note type with the affected invoice's letter
  List<Serie> _series(List<Serie> all) =>
      activeSeries(all, widget.tipoComprobante, prefix: _letter);

  /// The chosen serie, or the default one
  Serie? get _serie {
    final series = _series(
      ref.read(seriesProvider(widget.company.id)).value ?? const [],
    );
    final id = chosenSerieId(series, _serieId, widget.tipoComprobante);
    return series.where((s) => s.id == id).firstOrNull;
  }

  bool get _wholeInvoice =>
      _isCredito && _wholeInvoiceTipos.contains(_tipoNota);

  bool get _isAjuste => _isCredito && _tipoNota == ajusteMontosYFechasDePago;

  bool get _isFactura => widget.affected.tipoComprobante == '01';

  /// The reasons that fit the affected invoice: wrong RUC and adjusting the
  /// installments only happen on facturas (al crédito, for the latter), and
  /// adjusting exports on invoices with exports
  late final Map<String, String> _tiposNota = _fittingTipos();

  Map<String, String> _fittingTipos() {
    final alCredito = isFacturaAlCredito(widget.affected);
    final exports = _invoiceLines().any((line) => line.igvTipo == '40');
    final catalog = _isCredito
        ? Catalogs.tiposNotaCredito
        : Catalogs.tiposNotaDebito;
    bool fits(String tipo) => switch (tipo) {
      _ when tipo == _exportTipos[widget.tipoComprobante] => exports,
      '02' when _isCredito => _isFactura,
      ajusteMontosYFechasDePago when _isCredito => alCredito,
      _ => true,
    };
    return {
      for (final MapEntry(:key, :value) in catalog.entries)
        if (fits(key)) key: value,
    };
  }

  /// A type 13 nota changes no amounts: one line at zero, as SUNAT asks
  DraftLine get _ajusteLine => DraftLine(
    descripcion: Catalogs.tiposNotaCredito[ajusteMontosYFechasDePago]!,
    cantidad: '1',
    precio: '0',
    igvTipo: widget.company.igvTipo,
  );

  List<DraftLine> _invoiceLines() => [
    for (final line in _spec['detalles']! as List)
      DraftLine.fromJson(line as Map<String, Object?>),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _changed(edited: false),
    );
  }

  @override
  void dispose() {
    _preview.dispose();
    _sustento.dispose();
    super.dispose();
  }

  NoteDraft? get _draft {
    final sustento = _sustento.text.trim();
    if (_lines.isEmpty || sustento.isEmpty || (_isAjuste && _cuotas.isEmpty)) {
      return null;
    }
    return NoteDraft(
      tipoComprobante: widget.tipoComprobante,
      affected: widget.affected,
      tipoNota: _tipoNota,
      sustento: sustento,
      customer: _customer,
      lines: List.of(_lines),
      cuotas: _isAjuste ? List.of(_cuotas) : const [],
    );
  }

  void _changed({bool edited = true}) {
    setState(() => _edited |= edited);
    final draft = _draft;
    final serie = _serie;
    _preview.request(
      draft == null || serie == null
          ? null
          : () => ref
                .read(documentServiceProvider)
                .preview(company: widget.company, serie: serie, draft: draft),
    );
  }

  void _changeTipo(String tipo) {
    // A sustento the user wrote is kept
    if (_sustento.text == _tiposNota[_tipoNota]) {
      _sustento.text = _tiposNota[tipo]!;
    }
    final wasAjuste = _isAjuste;
    _tipoNota = tipo;
    if (_isAjuste) {
      _lines
        ..clear()
        ..add(_ajusteLine);
    } else if (_wholeInvoice || wasAjuste) {
      _lines
        ..clear()
        ..addAll(_invoiceLines());
    }
    _changed();
  }

  Future<void> _addCuota() async {
    final cuota = await showDialog<DraftCuota>(
      context: context,
      builder: (_) => const CuotaDialog(),
    );
    if (cuota != null) {
      _cuotas.add(cuota);
      _changed();
    }
  }

  Future<void> _editLine({int? index}) async {
    final line = await showDialog<DraftLine>(
      context: context,
      builder: (_) => LineDialog(
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

  Future<void> _emit() async {
    final draft = _draft;
    final serie = _serie;
    if (draft == null || serie == null) return;
    await issueAndShowResult(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
  }

  /// A nota de crédito over what's left to credit of the invoice
  String? get _warning {
    final total = _totals?.total;
    if (!_isCredito || total == null) return null;
    final related =
        ref.watch(relatedDocumentsProvider(widget.affected.id)).value ??
        const [];
    return creditedCents(related) + toCents(total) >
            toCents(widget.affected.total)
        ? draftProblemMessage(DraftProblem.noteExceedsInvoice)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    // Series loaded after the first frame recompute the preview
    ref.listen(
      seriesProvider(widget.company.id),
      (_, _) => _changed(edited: false),
    );
    final seriesValue = ref.watch(seriesProvider(widget.company.id)).value;
    final series = _series(seriesValue ?? const []);
    final serie = _serie;
    final moneda = widget.affected.moneda;
    final title = _isCredito ? Strings.notaCredito : Strings.notaDebito;
    final warning = _warning;
    final editable = !_wholeInvoice && !_isAjuste;

    return UnsavedChangesGuard(
      dirty: _edited,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.company.sunatEnvironment == SunatEnvironment.beta)
              const TestModeBanner(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                Strings.affectedDocument(
                  serieNumero(widget.affected.serie, widget.affected.numero),
                ),
              ),
              subtitle: Text(_customer.nombre),
            ),
            if (seriesValue != null && series.isEmpty)
              MissingSerieWarning(
                Strings.noNoteSerie(
                  title.toLowerCase(),
                  '$_letter${widget.tipoComprobante == '07' ? 'C' : 'D'}',
                ),
              ),
            SerieDropdown(
              series: series,
              value: serie?.id,
              onChanged: (id) {
                _serieId = id;
                _changed();
              },
            ),
            CatalogDropdown(
              label: Strings.tipoNota,
              value: _tipoNota,
              options: _tiposNota,
              onChanged: (tipo) => _changeTipo(tipo!),
            ),
            TextField(
              controller: _sustento,
              decoration: const InputDecoration(labelText: Strings.sustento),
              onChanged: (_) => _changed(),
            ),
            const FormSection(Strings.lines),
            DraftLinesList(
              lines: _lines,
              moneda: moneda,
              onEdit: editable ? (index) => _editLine(index: index) : null,
              onRemove: editable
                  ? (index) {
                      _lines.removeAt(index);
                      _changed();
                    }
                  : null,
            ),
            if (editable)
              OutlinedButton.icon(
                onPressed: _editLine,
                icon: const Icon(Icons.edit_note),
                label: const Text(Strings.freeLine),
              ),
            if (_isAjuste) ...[
              const FormSection(Strings.cuotasCorregidas),
              CuotasList(
                cuotas: _cuotas,
                moneda: moneda,
                onAdd: _addCuota,
                onRemove: (index) {
                  _cuotas.removeAt(index);
                  _changed();
                },
              ),
              if (_cuotas.isEmpty)
                const DraftWarning(Strings.ajusteWithoutCuotas),
            ],
            TotalsSection(
              totals: _totals,
              error: _previewError,
              moneda: moneda,
            ),
            if (warning != null) DraftWarning(warning),
            const SizedBox(height: 24),
            SaveButton(
              label: Strings.emit,
              filled: true,
              onPressed: _draft == null || serie == null || warning != null
                  ? null
                  : _emit,
            ),
          ],
        ),
      ),
    );
  }
}
