import 'flutter_opacity_core_platform_interface.dart';

enum OpacityEnvironment { test, local, staging, production }

class FlutterOpacityCore {
  Future init(String apiKey, bool dryRun, OpacityEnvironment environment) {
    int environmentInt = environment.index;
    return FlutterOpacityCorePlatform.instance
        .init(apiKey, dryRun, environmentInt);
  }

  Future getUberRiderProfile() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getUberRiderProfile();
    return WorkflowResponse.fromMap(responseMap as Map<String, dynamic>);
  }

  Future getGithubProfile() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getGithubProfile();
    return WorkflowResponse.fromMap(responseMap as Map<String, dynamic>);
  }
}
