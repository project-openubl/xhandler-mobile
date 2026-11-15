import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../app_log.dart';
import '../../strings.dart';

/// The phone's own lock: fingerprint, face, PIN, pattern or password
class DeviceAuth {
  bool _busy = false;

  /// Whether the system's unlock dialog is open; it may hide the app
  /// meanwhile, which isn't leaving it
  bool get busy => _busy;

  /// Whether the phone has a screen lock to ask for
  Future<bool> isAvailable() => LocalAuthentication().isDeviceSupported();

  /// `true` once the user proved it's them; `false` if they didn't or a
  /// dialog is already open. A phone whose screen lock was removed has
  /// nothing to ask, so it's `true` too: otherwise the app could never be
  /// opened again.
  Future<bool> authenticate() async {
    if (_busy) return false;
    _busy = true;
    try {
      return await LocalAuthentication().authenticate(
        localizedReason: Strings.unlockReason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (error) {
      if (error.code == LocalAuthExceptionCode.noCredentialsSet) return true;
      if (error.code != LocalAuthExceptionCode.userCanceled) {
        AppLog.error('Unlocking', error);
      }
      return false;
    } on Object catch (error, stack) {
      AppLog.error('Unlocking', error, stack);
      return false;
    } finally {
      _busy = false;
    }
  }
}

final deviceAuthProvider = Provider((ref) => DeviceAuth());

/// Hides the app's content from the recent apps screen and screenshots
/// (Android) and from the app switcher (iOS). Native side: MainActivity.kt
/// and AppDelegate.swift.
abstract final class PrivacyScreen {
  static const _channel = MethodChannel(
    'io.github.projectopenubl.xhandler/privacy',
  );

  static Future<void> set({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('set', enabled);
    } on MissingPluginException {
      // Widget tests and other platforms
    }
  }
}
