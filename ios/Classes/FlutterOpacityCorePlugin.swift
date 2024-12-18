import Flutter
import OpacityCore

public class FlutterOpacityCorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_opacity_core", binaryMessenger: registrar.messenger())
    let instance = FlutterOpacityCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
      if let args = call.arguments as? [String: Any],
        let apiKey = args["apiKey"] as? String,
        let dryRun = args["dryRun"] as? Bool,
        let environment = args["environment"] as? Int
      {
        guard let environmentEnum = OpacitySwiftWrapper.Environment(rawValue: environment) else {
          result(
            FlutterError(
              code: "INVALID_ENVIRONMENT", message: "Invalid environment value", details: nil))
          return
        }
        do {
          try OpacitySwiftWrapper.initialize(
            apiKey: apiKey, dryRun: dryRun, environment: environmentEnum)
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "ERROR_INITIALIZING", message: error.localizedDescription, details: nil))
        }
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    case "getUberRiderProfile":
      Task {
        do {
          let (json, _) = try await OpacitySwiftWrapper.getUberRiderProfile()
          let responseDict: [String: Any] = ["json": json]
          result(responseDict)  // Send the dictionary back to Flutter
        } catch {
          result(
            FlutterError(
              code: "ERROR_FETCHING_PROFILE", message: error.localizedDescription, details: nil))
        }
      }
    case "getGithubProfile":
      Task {
        do {
          let (json, _) = try await OpacitySwiftWrapper.getGithubProfile()
          let responseDict: [String: Any] = ["json": json]
          result(responseDict)  // Send the dictionary back to Flutter
        } catch {
          result(
            FlutterError(
              code: "ERROR_FETCHING_PROFILE", message: error.localizedDescription, details: nil))
        }
      }
    case "getInstagramProfile":
      Task {
        do {
          let (json, _) = try await OpacitySwiftWrapper.getInstagramProfile()
          let responseDict: [String: Any] = ["json": json]
          result(responseDict)  // Send the dictionary back to Flutter
        } catch {
          result(
            FlutterError(
              code: "ERROR_FETCHING_PROFILE", message: error.localizedDescription, details: nil))
        }
      }
    case "get":
      if let args = call.arguments as? [String: Any],
         let name = args["name"] as? String
      {
        let params = args["params"] as? String
        Task {
          do {
            let (json, _) = try await OpacitySwiftWrapper.get(
              name: name,
              params: params
            )
            let responseDict: [String: Any] = ["json": json]
            result(responseDict)  // Send the dictionary back to Flutter
          } catch {
            result(
              FlutterError(
                code: "ERROR_GETTING_FLOW", message: error.localizedDescription, details: nil))
          }
        }
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
