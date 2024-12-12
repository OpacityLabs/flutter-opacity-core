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
    return responseMap;
  }

  Future getGithubProfile() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getGithubProfile();
    return responseMap;
  }

  Future getInstagramProfile() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getInstagramProfile();
    return responseMap;
  }

  Future getGustoMembersTable() async {
    final responseMap =
        await FlutterOpacityCorePlatform.instance.getGustoMembersTable();
    return responseMap;
  }
}
