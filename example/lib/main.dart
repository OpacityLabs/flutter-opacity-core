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
    await _flutterOpacityCorePlugin.init(apiKey, false, OpacityEnvironment.staging);
  }

  Future<void> getUberRiderProfile() async {
    final response = await _flutterOpacityCorePlugin.getUberRiderProfile();
    print('Response: ${response.json}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: MaterialButton(
                onPressed: () {
                  getUberRiderProfile();
                },
                color: Colors.green,
                child: const Text("Get Uber Rider Profile"))),
      ),
    );
  }
}
