import 'flutter_opacity_core_platform_interface.dart';

class FlutterOpacityCore {
  Future init(String apiKey, bool dryRun) {
    return FlutterOpacityCorePlatform.instance.init(apiKey, dryRun);
  }

  Future getUberRiderProfile() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getUberRiderProfile();
    return WorkflowResponse.fromMap(responseMap as Map<String, dynamic>);
  }
}
