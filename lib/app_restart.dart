/// Starts the app over: opens the database again and rebuilds every page,
/// e.g. after restoring a backup. Set by `main`.
late Future<void> Function() restartApp;
