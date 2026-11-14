import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'document_service.dart';

/// Sends pending documents while the app is open: at start, every minute
/// and when the app comes back to the foreground (docs/DESIGN.md §5)
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
    _lifecycle = AppLifecycleListener(onResume: _run);
  }

  @override
  void dispose() {
    _timer.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  void _run() => ref.read(documentServiceProvider).sendDue();

  @override
  Widget build(BuildContext context) => widget.child;
}
