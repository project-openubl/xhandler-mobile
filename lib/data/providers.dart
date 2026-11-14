import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'secure_store.dart';

/// Opened in `main`, which overrides this provider
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final secureStoreProvider = Provider((ref) => SecureStore());
