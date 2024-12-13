import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_opacity_core_method_channel.dart';

// class WorkflowResponse {
//   String json;
//   // String proof;

//   WorkflowResponse({required this.json});

//   // Factory constructor to create from a dictionary
//   factory WorkflowResponse.fromMap(Map<String, dynamic> map) {
//     return WorkflowResponse(
//       json: map['json'] as String,
//       // proof: map['proof'] as String,
//     );
//   }
// }

abstract class FlutterOpacityCorePlatform extends PlatformInterface {
  /// Constructs a FlutterOpacityCorePlatform.
  FlutterOpacityCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterOpacityCorePlatform _instance =
      MethodChannelFlutterOpacityCore();

  /// The default instance of [FlutterOpacityCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterOpacityCore].
  static FlutterOpacityCorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterOpacityCorePlatform] when
  /// they register themselves.
  static set instance(FlutterOpacityCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future init(String apiKey, bool dryRun, int environment) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future getUberRiderProfile() {
    throw UnimplementedError('getUberRiderProfile() has not been implemented.');
  }

  Future getGithubProfile() {
    throw UnimplementedError('getGithubProfile() has not been implemented.');
  }

  Future getInstagramProfile() {
    throw UnimplementedError('getInstagramProfile() has not been implemented.');
  }

  Future getGustoMembersTable() {
    throw UnimplementedError(
        'getGustoMembersTable() has not been implemented.');
  }
}
