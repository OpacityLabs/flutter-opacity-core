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
import com.opacitylabs.opacitycore.OpacityCore
import com.opacitylabs.opacitycore.OpacityError
import kotlinx.coroutines.*

/** FlutterOpacityCorePlugin */
class FlutterOpacityCorePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_opacity_core")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val apiKey = call.argument<String?>("apiKey")
                val dryRun = call.argument<Boolean?>("dryRun") ?: false
                val environment = call.argument<Int?>("environment")
                val shouldShowErrorsInWebview =
                    call.argument<Boolean?>("shouldShowErrorsInWebView") ?: true
                if (apiKey == null || environment == null) {
                    result.error("INVALID_ARGUMENTS", "apiKey and dryRun must be provided", null)
                } else {
                    val environmentEnum = when (environment) {
                        0 -> OpacityCore.Environment.TEST
                        1 -> OpacityCore.Environment.LOCAL
                        2 -> OpacityCore.Environment.SANDBOX
                        3 -> OpacityCore.Environment.STAGING
                        4 -> OpacityCore.Environment.PRODUCTION
                        else -> {
                            result.error("INVALID_ARGUMENTS", "Invalid environment value", null)
                            return
                        }
                    }
                    try {
                        OpacityCore.initialize(
                            apiKey,
                            dryRun,
                            environmentEnum,
                            shouldShowErrorsInWebview
                        )
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("INITIALIZATION_ERROR", e.message, null)
                    }
                }
            }

            "get" -> {
                val name = call.argument<String>("name")
                val params = call.argument<Map<String, Any>>("params")
                if (name == null) {
                    result.error("MISSING_PARAM", "Name parameter is required", null)
                    return
                }
                CoroutineScope(Dispatchers.Main).launch {
                    val res = OpacityCore.get(name, params)
                    res.fold(
                        onSuccess = { value ->
                            result.success(value)
                        },
                        onFailure = {
                            when (it) {
                                is OpacityError -> {
                                    result.error(it.code, it.message, it)
                                }

                                else -> {
                                    result.error("UnknownError", it.message, it)
                                }
                            }
                        }
                    )
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
