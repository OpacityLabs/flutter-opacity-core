import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_opacity_core/flutter_opacity_core.dart';
import 'package:flutter_opacity_core/flutter_opacity_core_platform_interface.dart';
import 'package:flutter_opacity_core/flutter_opacity_core_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterOpacityCorePlatform
    with MockPlatformInterfaceMixin
    implements FlutterOpacityCorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterOpacityCorePlatform initialPlatform = FlutterOpacityCorePlatform.instance;

  test('$MethodChannelFlutterOpacityCore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterOpacityCore>());
  });

  test('getPlatformVersion', () async {
    FlutterOpacityCore flutterOpacityCorePlugin = FlutterOpacityCore();
    MockFlutterOpacityCorePlatform fakePlatform = MockFlutterOpacityCorePlatform();
    FlutterOpacityCorePlatform.instance = fakePlatform;

    expect(await flutterOpacityCorePlugin.getPlatformVersion(), '42');
  });
}
