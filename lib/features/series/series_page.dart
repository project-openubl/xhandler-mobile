import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import 'series_repository.dart';

final _seriesProvider = StreamProvider.family<List<Serie>, String>(
  (ref, companyId) =>
      ref.watch(seriesRepositoryProvider).watchByCompany(companyId),
);

/// Series of the active company: which one is suggested for each document
/// type and the number its next document takes
class SeriesPage extends ConsumerWidget {
  const SeriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(activeCompanyProvider).value;
    if (company == null) return const Scaffold();
    final series = ref.watch(_seriesProvider(company.id)).value ?? const [];
    final repository = ref.read(seriesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.series)),
      floatingActionButton: FloatingActionButton(
        tooltip: Strings.addSerie,
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => _SerieDialog(companyId: company.id),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final serie in series)
            ListTile(
              title: Text(serie.serie),
              subtitle: Text(
                '${Catalogs.tiposComprobante[serie.tipoComprobante]} · '
                '${Strings.nextNumberOf(serie.nextNumber)}',
              ),
              trailing: IconButton(
                tooltip: Strings.setDefault,
                icon: Icon(serie.isDefault ? Icons.star : Icons.star_border),
                onPressed: serie.isDefault
                    ? null
                    : () => repository.setDefault(serie),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) =>
                    _SerieDialog(companyId: company.id, serie: serie),
              ),
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

  @override
  void dispose() {
    _serie.dispose();
    _nextNumber.dispose();
    super.dispose();
  }

  String? _validateSerie(String serie) {
    final letters = Catalogs.serieLetters[_tipoComprobante]!;
    final valid = RegExp('^[$letters][A-Z0-9]{3}\$')
        .hasMatch(serie.toUpperCase());
    return valid ? null : Strings.invalidSerie(letters);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(seriesRepositoryProvider);
    final nextNumber = Value(int.parse(_nextNumber.text.trim()));
    final existing = widget.serie;
    if (existing != null) {
      await repository.update(
        existing.id,
        SeriesCompanion(nextNumber: nextNumber),
      );
    } else {
      await repository.create(
        SeriesCompanion.insert(
          companyId: widget.companyId,
          tipoComprobante: _tipoComprobante,
          serie: _serie.text.trim().toUpperCase(),
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
      title: Text(editing ? widget.serie!.serie : Strings.addSerie),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!editing) ...[
              DropdownButtonFormField(
                initialValue: _tipoComprobante,
                decoration: const InputDecoration(
                  labelText: Strings.tipoComprobante,
                ),
                items: [
                  for (final MapEntry(:key, :value)
                      in Catalogs.tiposComprobante.entries)
                    DropdownMenuItem(value: key, child: Text(value)),
                ],
                onChanged: (tipo) => setState(() => _tipoComprobante = tipo!),
              ),
              FormTextField(_serie, Strings.serie, validator: _validateSerie),
            ],
            FormTextField(
              _nextNumber,
              Strings.nextNumber,
              keyboardType: TextInputType.number,
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
        TextButton(onPressed: _save, child: const Text(Strings.save)),
      ],
    );
  }
}
