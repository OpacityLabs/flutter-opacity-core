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
    case "init":
        if let args = call.arguments as? [String: Any],
           let apiKey = args["apiKey"] as? String,
           let dryRun = args["dryRun"] as? Bool {
            OpacitySwiftWrapper.initialize(apiKey: apiKey, dryRun: dryRun)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
    case "getUberRiderProfile":
        Task {
            do {
                let (json, proof) = try await OpacitySwiftWrapper.getUberRiderProfile()
                let responseDict: [String: Any] = ["json": json, "proof": proof]
                                result(responseDict)  // Send the dictionary back to Flutter
            } catch {
                result(FlutterError(code: "ERROR_FETCHING_PROFILE", message: error.localizedDescription, details: nil))
            }
        }
        
    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
