import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'series_repository.dart';

/// Series of the company: which one is suggested for each document type and
/// the number its next document takes
class SeriesPage extends ConsumerWidget {
  const SeriesPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(seriesProvider(company.id)).value ?? const [];
    void openDialog([Serie? serie]) => showDialog<void>(
      context: context,
      builder: (_) => _SerieDialog(companyId: company.id, serie: serie),
    );

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.series)),
      floatingActionButton: FloatingActionButton(
        tooltip: Strings.addSerie,
        onPressed: openDialog,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final serie in series)
            ListTile(
              title: Text(serie.serie),
              subtitle: Text(
                '${Catalogs.tiposComprobante[serie.tipoComprobante] ?? serie.tipoComprobante}'
                ' · ${Strings.nextNumberOf(serie.nextNumber)}',
              ),
              trailing: IconButton(
                tooltip: serie.isDefault
                    ? Strings.isDefault
                    : Strings.setDefault,
                icon: Icon(serie.isDefault ? Icons.star : Icons.star_border),
                onPressed: serie.isDefault
                    ? null
                    : () =>
                          ref.read(seriesRepositoryProvider).setDefault(serie),
              ),
              onTap: () => openDialog(serie),
            ),
        ],
      ),
    );
  }
}

/// Adds a series, or edits the next number of [serie]
class _SerieDialog extends ConsumerStatefulWidget {
  const _SerieDialog({required this.companyId, this.serie});

  final String companyId;
  final Serie? serie;

  @override
  ConsumerState<_SerieDialog> createState() => _SerieDialogState();
}

class _SerieDialogState extends ConsumerState<_SerieDialog> {
  final _form = GlobalKey<FormState>();
  late String _tipoComprobante = widget.serie?.tipoComprobante ?? '01';
  late final _serie = TextEditingController(text: widget.serie?.serie);
  late final _nextNumber = TextEditingController(
    text: '${widget.serie?.nextNumber ?? 1}',
  );
  String? _serieError;

  @override
  void dispose() {
    _serie.dispose();
    _nextNumber.dispose();
    super.dispose();
  }

  String? _validateSerie(String serie) {
    if (_serieError != null) return _serieError;
    final letters = Catalogs.serieLetters[_tipoComprobante]!;
    final valid = RegExp('^[$letters][A-Z0-9]{3}\$')
        .hasMatch(serie.toUpperCase());
    return valid ? null : Strings.invalidSerie(letters);
  }

  Future<void> _save() async {
    setState(() => _serieError = null);
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(seriesRepositoryProvider);
    final nextNumber = Value(int.parse(_nextNumber.text.trim()));
    final existing = widget.serie;
    if (existing != null) {
      // TODO(phase 3): don't go below the last issued number + 1
      await repository.update(
        existing.id,
        SeriesCompanion(nextNumber: nextNumber),
      );
    } else {
      final serie = _serie.text.trim().toUpperCase();
      if (await repository.exists(widget.companyId, _tipoComprobante, serie)) {
        _serieError = Strings.serieExists;
        _form.currentState!.validate();
        return;
      }
      await repository.create(
        SeriesCompanion.insert(
          companyId: widget.companyId,
          tipoComprobante: _tipoComprobante,
          serie: serie,
          nextNumber: nextNumber,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.serie != null;
    return AlertDialog(
      scrollable: true,
      title: Text(editing ? widget.serie!.serie : Strings.addSerie),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RequiredFieldsLegend(),
            if (!editing) ...[
              CatalogDropdown(
                label: Strings.tipoComprobante,
                value: _tipoComprobante,
                options: Catalogs.tiposComprobante,
                onChanged: (tipo) {
                  setState(() => _tipoComprobante = tipo!);
                  if (_serie.text.isNotEmpty) _form.currentState!.validate();
                },
              ),
              FormTextField(
                _serie,
                Strings.serie,
                required: true,
                maxLength: 4,
                validator: _validateSerie,
              ),
            ],
            FormTextField(
              _nextNumber,
              Strings.nextNumber,
              required: true,
              digitsOnly: true,
              maxLength: 8,
              validator: (text) => (int.tryParse(text) ?? 0) > 0
                  ? null
                  : Strings.invalidNextNumber,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        SaveButton(onPressed: _save),
      ],
    );
  }
}
