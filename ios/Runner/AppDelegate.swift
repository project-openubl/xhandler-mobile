import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Whether the app lock is on: the app switcher then shows a blank screen
  /// instead of the app (lib/features/lock/device_auth.dart, PrivacyScreen)
  private var hidesContent = false
  private var cover: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Sends pending documents in the background (lib/features/document/background_outbox.dart)
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "io.github.projectopenubl.xhandler.outbox",
      earliestBeginInSeconds: NSNumber(value: 15 * 60)
    )
    let center = NotificationCenter.default
    center.addObserver(
      self, selector: #selector(sceneWillDeactivate),
      name: UIScene.willDeactivateNotification, object: nil)
    center.addObserver(
      self, selector: #selector(sceneDidActivate),
      name: UIScene.didActivateNotification, object: nil)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PrivacyScreen") else {
      return
    }
    FlutterMethodChannel(
      name: "io.github.projectopenubl.xhandler/privacy",
      binaryMessenger: registrar.messenger()
    ).setMethodCallHandler { [weak self] call, result in
      guard call.method == "set" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.hidesContent = call.arguments as? Bool ?? false
      result(nil)
    }
  }

  /// Covers the window of a scene going to the background. Face ID, Control
  /// Center and banners deactivate the scene too, so the lock screen goes
  /// blank while unlocking: intended, the cover is up before the snapshot.
  @objc private func sceneWillDeactivate(_ notification: Notification) {
    guard hidesContent, cover == nil,
      let window = (notification.object as? UIWindowScene)?.keyWindow
    else { return }
    let view = UIView(frame: window.bounds)
    view.backgroundColor = .systemBackground
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(view)
    cover = view
  }

  @objc private func sceneDidActivate(_ notification: Notification) {
    cover?.removeFromSuperview()
    cover = nil
  }
}
