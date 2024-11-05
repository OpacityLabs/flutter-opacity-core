import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_opacity_core_method_channel.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future showAlert() {
    throw UnimplementedError('showAlert() has not been implemented.');
  }
}
