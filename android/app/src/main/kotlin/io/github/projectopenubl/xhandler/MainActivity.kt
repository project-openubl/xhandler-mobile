package io.github.projectopenubl.xhandler

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// A FragmentActivity: local_auth shows the system's unlock dialog
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // While the app lock is on, its screens don't show in recent apps nor
        // in screenshots (lib/features/lock/device_auth.dart, PrivacyScreen)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "io.github.projectopenubl.xhandler/privacy",
        ).setMethodCallHandler { call, result ->
            if (call.method == "set") {
                if (call.arguments == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
