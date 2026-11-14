import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../data/database.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../document/document_repository.dart';
import '../pdf/share_document.dart';
import 'sales_register.dart';

/// The sales register of a month (docs/DESIGN.md §10)
final _salesProvider = FutureProvider.autoDispose
    .family<List<SalesRow>, ({Company company, DateTime month})>((
      ref,
      query,
    ) async {
      final month = query.month;
      final last = DateTime(month.year, month.month + 1, 0);
      final documents = await ref
          .watch(documentRepositoryProvider)
          .issued(
            query.company.id,
            query.company.sunatEnvironment,
            from: isoDate(month),
            to: isoDate(last),
            tipos: salesTipos,
            statuses: salesStatuses,
          );
      return [for (final document in documents) SalesRow.of(document)];
    });

/// Sales of a month and their export, in the company's current mode
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  late DateTime _month = () {
    final today = DateTime.parse(peruToday());
    return DateTime(today.year, today.month);
  }();

  String get _period =>
      '${_month.year}${_month.month.toString().padLeft(2, '0')}';

  Future<void> _export(
    BuildContext anchor,
    List<SalesRow> rows, {
    required bool excel,
  }) async {
    final name = 'ventas-${widget.company.ruc}-$_period';
    await shareFiles(
      [
        excel
            ? (
                name: '$name.xlsx',
                mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                bytes: salesXlsx(rows),
              )
            : (name: '$name.csv', mimeType: 'text/csv', bytes: salesCsv(rows)),
      ],
      subject: '${Strings.salesRegister} $_period',
      anchor: anchor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sales = ref.watch(
      _salesProvider((company: widget.company, month: _month)),
    );
    final rows = sales.value;
    final localizations = MaterialLocalizations.of(context);
    final thisMonth = DateTime.parse(peruToday());
    final isCurrent =
        _month.year == thisMonth.year && _month.month == thisMonth.month;

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.reports)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: Strings.previousMonth,
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1),
                ),
              ),
              Expanded(
                child: Text(
                  localizations.formatMonthYear(_month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: Strings.nextMonth,
                icon: const Icon(Icons.chevron_right),
                onPressed: isCurrent
                    ? null
                    : () => setState(
                        () => _month = DateTime(_month.year, _month.month + 1),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (rows == null)
            const Center(child: CircularProgressIndicator())
          else if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(Strings.noSales, textAlign: TextAlign.center),
            )
          else ...[
            for (final summary in salesSummaries(rows))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        Strings.documentsCount(summary.count, summary.voided),
                      ),
                      for (final (label, amount) in [
                        (Strings.opGravada, summary.gravado),
                        (Strings.igv, summary.igv),
                        (Strings.total, summary.total),
                      ])
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(label),
                            Text(formatMoney(summary.moneda, amount)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            const FormSection(Strings.export),
            Builder(
              builder: (anchor) => Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _export(anchor, rows, excel: true),
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Excel'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _export(anchor, rows, excel: false),
                    icon: const Icon(Icons.description),
                    label: const Text('CSV'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Strings.salesRegisterHelp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (sales.hasError) const Text(Strings.unexpectedError),
        ],
      ),
    );
  }
}
