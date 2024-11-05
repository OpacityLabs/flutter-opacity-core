import 'flutter_opacity_core_platform_interface.dart';

class FlutterOpacityCore {
  Future<String?> getPlatformVersion() {
    return FlutterOpacityCorePlatform.instance.getPlatformVersion();
  }

  Future showAlert() {
    return FlutterOpacityCorePlatform.instance.showAlert();
  }
}
