import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/providers.dart';
import 'background_outbox.dart';
import 'document_service.dart';

/// Sends pending documents while the app is open: at start, every minute
/// and when the app comes back to the foreground; and schedules the
/// background outbox for when it's closed (docs/DESIGN.md §5)
class OutboxRunner extends ConsumerStatefulWidget {
  const OutboxRunner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<OutboxRunner> createState() => _OutboxRunnerState();
}

class _OutboxRunnerState extends ConsumerState<OutboxRunner> {
  late final Timer _timer;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _run();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _run());
    _lifecycle = AppLifecycleListener(onResume: _resumed);
    // While closed, the work goes on in the background
    unawaited(
      scheduleBackgroundOutbox().catchError(
        (Object error) => debugPrint('Background outbox: $error'),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  /// The background outbox writes through its own connection: tell this
  /// one's streams the documents may have changed
  void _resumed() {
    final database = ref.read(databaseProvider);
    database.markTablesUpdated([
      database.documents,
      database.documentEvents,
      database.documentFiles,
    ]);
    _run();
  }

  /// Errors are logged: the next round tries again
  void _run() => unawaited(
    ref
        .read(documentServiceProvider)
        .sendDue()
        .catchError((Object error) => debugPrint('Outbox: $error')),
  );

  @override
  Widget build(BuildContext context) => widget.child;
}
