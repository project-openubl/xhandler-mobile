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
import 'document_detail_page.dart';
import 'document_service.dart';
import 'document_status.dart';
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

class _NoteFormPageState extends ConsumerState<NoteFormPage> {
  late final _spec =
      (jsonDecode(widget.affected.inputJson) as Map<String, Object?>)['spec']
          as Map<String, Object?>;
  late final _customer = DraftCustomer.fromJson(
    _spec['cliente']! as Map<String, Object?>,
  );

  /// A nota de crédito starts with the invoice's lines, to edit or remove
  late final _lines = <DraftLine>[
    if (_isCredito)
      for (final line in _spec['detalles']! as List)
        DraftLine.fromJson(line as Map<String, Object?>),
  ];
  late String _tipoNota = '01';
  late final _sustento = TextEditingController(text: _tiposNota[_tipoNota]);
  DocumentTotals? _totals;
  late final _preview = TotalsPreview((totals, _) {
    if (mounted) setState(() => _totals = totals);
  });

  bool get _isCredito => widget.tipoComprobante == '07';

  Map<String, String> get _tiposNota =>
      _isCredito ? Catalogs.tiposNotaCredito : Catalogs.tiposNotaDebito;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _changed());
  }

  @override
  void dispose() {
    _preview.dispose();
    _sustento.dispose();
    super.dispose();
  }

  /// Series of the note type with the affected invoice's letter
  Serie? get _serie => defaultSerie(
    (ref.read(seriesProvider(widget.company.id)).value ?? const []).where(
      (s) => s.serie.startsWith(widget.affected.serie[0]),
    ),
    widget.tipoComprobante,
  );

  NoteDraft? get _draft {
    final sustento = _sustento.text.trim();
    if (_lines.isEmpty || sustento.isEmpty) return null;
    return NoteDraft(
      tipoComprobante: widget.tipoComprobante,
      affected: widget.affected,
      tipoNota: _tipoNota,
      sustento: sustento,
      customer: _customer,
      lines: List.of(_lines),
    );
  }

  void _changed() {
    setState(() {});
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
    final issued = await issueDocument(
      context,
      ref,
      company: widget.company,
      serie: serie,
      draft: draft,
    );
    if (issued == null || !mounted) return;
    final view = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => EmitResultSheet(status: issued.status),
    );
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (view ?? false) {
      navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailPage(documentId: issued.id),
        ),
      );
    } else {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final series = ref.watch(seriesProvider(widget.company.id)).value;
    final serie = _serie;
    final moneda = widget.affected.moneda;
    final title = _isCredito ? Strings.notaCredito : Strings.notaDebito;
    final totals = _totals;

    return Scaffold(
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
            trailing: Text(
              serie == null ? '' : serieNumero(serie.serie, serie.nextNumber),
            ),
          ),
          if (series != null && serie == null)
            ListTile(
              leading: Icon(
                Icons.warning,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(Strings.noSerie(title.toLowerCase())),
            ),
          CatalogDropdown(
            label: Strings.tipoNota,
            value: _tipoNota,
            options: _tiposNota,
            onChanged: (tipo) {
              _tipoNota = tipo!;
              _sustento.text = _tiposNota[tipo]!;
              _changed();
            },
          ),
          TextField(
            controller: _sustento,
            decoration: const InputDecoration(labelText: Strings.sustento),
            onChanged: (_) => _changed(),
          ),
          const FormSection(Strings.lines),
          for (final (index, line) in _lines.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(line.descripcion),
              subtitle: Text(
                '${line.cantidad} × ${formatMoney(moneda, line.precio)}'
                '${line.precioIncluyeIgv ? '' : ' + IGV'}',
              ),
              onTap: () => _editLine(index: index),
              trailing: IconButton(
                tooltip: Strings.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  _lines.removeAt(index);
                  _changed();
                },
              ),
            ),
          OutlinedButton.icon(
            onPressed: _editLine,
            icon: const Icon(Icons.edit_note),
            label: const Text(Strings.freeLine),
          ),
          if (totals != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(Strings.total),
              trailing: Text(
                formatMoney(moneda, totals.total),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          const SizedBox(height: 24),
          SaveButton(
            label: Strings.emit,
            filled: true,
            onPressed: _draft == null || serie == null ? null : _emit,
          ),
        ],
      ),
    );
  }
}
