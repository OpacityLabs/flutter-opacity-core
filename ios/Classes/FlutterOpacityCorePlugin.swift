import Flutter
import UIKit

public class FlutterOpacityCorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_opacity_core", binaryMessenger: registrar.messenger())
    let instance = FlutterOpacityCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "showAlert":
        let alert = UIAlertController(title: "Hello", message: "I am a native alert dialog", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    case "init":
        if let args = call.arguments as? [String: Any],
           let apiKey = args["apiKey"] as? String,
           let dryRun = args["dryRun"] as? Bool {
            OpacitySwiftWrapper.initialize(apiKey: apiKey, dryRun: dryRun)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
