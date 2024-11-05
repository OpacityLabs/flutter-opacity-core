import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_opacity_core_platform_interface.dart';

/// An implementation of [FlutterOpacityCorePlatform] that uses method channels.
class MethodChannelFlutterOpacityCore extends FlutterOpacityCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_opacity_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future showAlert() async {
    await methodChannel.invokeMethod<void>('showAlert');
  }
}
