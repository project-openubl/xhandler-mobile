package io.github.projectopenubl.xhandler

import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "xhandler/whatsapp")
            .setMethodCallHandler { call, result ->
                if (call.method != "share") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                result.success(
                    shareToWhatsApp(
                        call.argument<String>("phone")!!,
                        call.argument<List<String>>("paths")!!,
                        call.argument<String>("text"),
                    ),
                )
            }
    }

    /**
     * Opens the chat with [phone] (digits with the country code) in WhatsApp
     * or WhatsApp Business with the files at [paths] (in the cache's
     * "delivery" folder) attached. False when neither is installed.
     */
    private fun shareToWhatsApp(phone: String, paths: List<String>, text: String?): Boolean {
        val uris = ArrayList(
            paths.map { FileProvider.getUriForFile(this, "$packageName.delivery", File(it)) },
        )
        val intent = Intent(Intent.ACTION_SEND_MULTIPLE).apply {
            type = "*/*"
            putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
            // SEND_MULTIPLE takes a list of captions
            if (text != null) putCharSequenceArrayListExtra(Intent.EXTRA_TEXT, arrayListOf(text))
            // WhatsApp's way to preselect the chat
            putExtra("jid", "$phone@s.whatsapp.net")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        // Businesses send from WhatsApp Business when they have both
        for (app in listOf("com.whatsapp.w4b", "com.whatsapp")) {
            try {
                startActivity(intent.setPackage(app))
                return true
            } catch (_: ActivityNotFoundException) {
                // Try the next one
            }
        }
        return false
    }
}
