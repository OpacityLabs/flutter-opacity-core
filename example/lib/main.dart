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
    try {
      await _flutterOpacityCorePlugin.init(
        apiKey, false, OpacityEnvironment.production, true);
    } catch (e) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: const Text('Error'),
        content: const Text('Session could not be created'),
        actions: <Widget>[
          TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          ),
        ],
        );
      },
      );
    }
  }

  Future<void> getUberRiderProfile() async {
    final response =
        await _flutterOpacityCorePlugin.get("uber_rider:profile");
    // ignore: avoid_print
    print('Response: $response');
  }

  Future<void> getGenerateProof() async {
    final response = await _flutterOpacityCorePlugin.get("generate_proof");
    print('Response: $response');
  }

  Future<void> getFail() async {
    try {
      final response = await _flutterOpacityCorePlugin.get("fail");
      print('Response: $response');
    } catch (e) {
      print('Error: $e');
    }
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
                getGenerateProof();
              },
              color: Colors.green,
              child: const Text("Get generate_proof")),
          MaterialButton(
              onPressed: () {
                getFail();
              },
              color: Colors.green,
              child: const Text("failing")),
        ]),
      ),
    ));
  }
}
