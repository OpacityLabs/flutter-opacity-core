import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_opacity_core_platform_interface.dart';

/// An implementation of [FlutterOpacityCorePlatform] that uses method channels.
class MethodChannelFlutterOpacityCore extends FlutterOpacityCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_opacity_core');

  @override
  Future init(String apiKey, bool dryRun, int environment, bool shouldShowErrorsInWebView) async {
    await methodChannel.invokeMethod<void>('init', {
      'apiKey': apiKey,
      'dryRun': dryRun,
      'environment': environment,
      'shouldShowErrorsInWebView': shouldShowErrorsInWebView,
    });
  }

  @override
  Future<Map<String, dynamic>?> get(String name,
      {Map<String, dynamic>? params}) async {
    final response = await methodChannel.invokeMapMethod<String, dynamic>(
        'get', {'name': name, 'params': params});
    return response;
  }
}
