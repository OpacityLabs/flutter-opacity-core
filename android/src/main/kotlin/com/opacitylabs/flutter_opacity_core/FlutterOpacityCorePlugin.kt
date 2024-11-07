package com.opacitylabs.flutter_opacity_core

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*

/** FlutterOpacityCorePlugin */
class FlutterOpacityCorePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_opacity_core")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "init" -> {
        val apiKey = call.argument<String?>("apiKey")
        val dryRun = call.argument<Boolean?>("dryRun")
        val environment = call.argument<Int?>("environment")
        if (apiKey == null || dryRun == null || environment == null) {
          result.error("INVALID_ARGUMENTS", "apiKey and dryRun must be provided", null)
        } else {
          OpacityCore.initialize(apiKey, dryRun, environment)
          result.success(null)
        }
      }
      "getUberRiderProfile" -> {
        CoroutineScope(Dispatchers.Main).launch {
          try {
            // Call the suspend function and capture its result
            val res = OpacityCore.getUberDriverProfile()
            val profileMap: Map<String, Any?> = mapOf(
              "json" to res.json,
              "proof" to res.proof
            )

            // Send the map back to Flutter
            result.success(profileMap)
          } catch (e: Exception) {
            // Handle any exceptions and send an error back to Flutter
            result.error("ERROR_FETCHING_PROFILE", e.message, null)
          }
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    OpacityCore.setContext(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    OpacityCore.setContext(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
