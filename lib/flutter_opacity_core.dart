import 'flutter_opacity_core_platform_interface.dart';

enum OpacityEnvironment { test, local, staging, production }

class FlutterOpacityCore {
  Future init(String apiKey, bool dryRun, OpacityEnvironment environment, bool shouldShowErrorsInWebView) {
    int environmentInt = environment.index;
    return FlutterOpacityCorePlatform.instance
        .init(apiKey, dryRun, environmentInt, shouldShowErrorsInWebView);
  }

  Future get(String name, {Map<String, dynamic>? params}) async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.get(name, params: params);
    return responseMap;
  }
}
