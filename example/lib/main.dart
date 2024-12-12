import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_opacity_core/flutter_opacity_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterOpacityCorePlugin = FlutterOpacityCore();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await dotenv.load();
    final apiKey = dotenv.env['OPACITY_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not set');
    }
    await _flutterOpacityCorePlugin.init(
        apiKey, false, OpacityEnvironment.production);
  }

  Future<void> getUberRiderProfile() async {
    final response = await _flutterOpacityCorePlugin.getUberRiderProfile();
    // ignore: avoid_print
    print('Response: $response');
  }

  Future<void> getGithubProfile() async {
    final response = await _flutterOpacityCorePlugin.getGithubProfile();
    // ignore: avoid_print
    print('Response: $response');
  }

  Future<void> getInstagramProfile() async {
    final response = await _flutterOpacityCorePlugin.getInstagramProfile();
    // ignore: avoid_print
    print('Response: $response');
  }

  Future<void> getGustoMembersTable() async {
    final response = await _flutterOpacityCorePlugin.getGustoMembersTable();
    // ignore: avoid_print
    print('Response: $response');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          MaterialButton(
              onPressed: () {
                getUberRiderProfile();
              },
              color: Colors.green,
              child: const Text("Get Uber Rider Profile")),
          MaterialButton(
              onPressed: () {
                getGithubProfile();
              },
              color: Colors.green,
              child: const Text("Get Github Profile")),
          MaterialButton(
              onPressed: () {
                getInstagramProfile();
              },
              color: Colors.green,
              child: const Text("Get Instagram Profile")),
          MaterialButton(
              onPressed: () {
                getGustoMembersTable();
              },
              color: Colors.green,
              child: const Text("Get Gusto Profile")),
        ]),
      ),
    ));
  }
}
