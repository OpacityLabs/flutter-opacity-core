#include "opacity.h"
#include <android/log.h>
#include <future>
#include <jni.h>
#include <thread>

JavaVM *java_vm;
jobject java_object;

void DeferThreadDetach(JNIEnv *env) {
  static pthread_key_t thread_key;

  // Set up a Thread Specific Data key, and a callback that
  // will be executed when a thread is destroyed.
  // This is only done once, across all threads, and the value
  // associated with the key for any given thread will initially
  // be NULL.
  static auto run_once = [] {
    const auto err = pthread_key_create(&thread_key, [](void *ts_env) {
      if (ts_env) {
        java_vm->DetachCurrentThread();
      }
    });
    if (err) {
      // Failed to create TSD key. Throw an exception if you want to.
    }
    return 0;
  }();

  // For the callback to actually be executed when a thread exits
  // we need to associate a non-NULL value with the key on that thread.
  // We can use the JNIEnv* as that value.
  const auto ts_env = pthread_getspecific(thread_key);
  if (!ts_env) {
    if (pthread_setspecific(thread_key, env)) {
      // Failed to set thread-specific value for key. Throw an exception if you
      // want to.
    }
  }
}

JNIEnv *GetJniEnv() {
  JNIEnv *env = nullptr;
  // We still call GetEnv first to detect if the thread already
  // is attached. This is done to avoid setting up a DetachCurrentThread
  // call on a Java thread.

  // g_vm is a global.
  auto get_env_result = java_vm->GetEnv((void **)&env, JNI_VERSION_1_6);
  if (get_env_result == JNI_EDETACHED) {
    if (java_vm->AttachCurrentThread(&env, nullptr) == JNI_OK) {
      DeferThreadDetach(env);
    } else {
      // Failed to attach thread. Throw an exception if you want to.
    }
  } else if (get_env_result == JNI_EVERSION) {
    // Unsupported JNI version. Throw an exception if you want to.
  }
  return env;
}

extern "C" JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *jvm, void *reserved) {
  java_vm = jvm;
  return JNI_VERSION_1_6;
}

jstring string2jstring(JNIEnv *env, const char *str) {
  return (*env).NewStringUTF(str);
}

extern "C" void secure_set(const char *key, const char *value) {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID set_method = env->GetMethodID(
      jOpacityCore, "securelySet", "(Ljava/lang/String;Ljava/lang/String;)V");

  env->CallVoidMethod(java_object, set_method, string2jstring(env, key),
                      string2jstring(env, value));
}

extern "C" const char *secure_get(const char *key) {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID set_method = env->GetMethodID(
      jOpacityCore, "securelyGet", "(Ljava/lang/String;)Ljava/lang/String;");

  auto res = (jstring)env->CallObjectMethod(java_object, set_method,
                                            string2jstring(env, key));

  if (res == nullptr) {
    return nullptr;
  }

  const char *val_str = env->GetStringUTFChars(res, nullptr);
  return val_str;
}

extern "C" void android_prepare_request(const char *url) {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID openBrowserMethod = env->GetMethodID(
      jOpacityCore, "prepareInAppBrowser", "(Ljava/lang/String;)V");

  // Call the method with the necessary parameters
  jstring jurl = env->NewStringUTF(url);
  env->CallVoidMethod(java_object, openBrowserMethod, jurl);
}

extern "C" void android_set_request_header(const char *key, const char *value) {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID method =
      env->GetMethodID(jOpacityCore, "setBrowserHeader",
                       "(Ljava/lang/String;Ljava/lang/String;)V");

  // Call the method with the necessary parameters
  jstring jkey = env->NewStringUTF(key);
  jstring jvalue = env->NewStringUTF(value);
  env->CallVoidMethod(java_object, method, jkey, jvalue);
}

extern "C" void android_present_webview() {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID method = env->GetMethodID(jOpacityCore, "presentBrowser", "()V");

  // Call the method with the necessary parameters
  env->CallVoidMethod(java_object, method);
}

extern "C" void android_close_webview() {
  JNIEnv *env = GetJniEnv();
  // Get the Kotlin class
  jclass jOpacityCore = env->GetObjectClass(java_object);

  // Get the method ID for the method you want to call
  jmethodID method = env->GetMethodID(jOpacityCore, "closeBrowser", "()V");

  // Call the method with the necessary parameters
  env->CallVoidMethod(java_object, method);
}

extern "C" JNIEXPORT jint JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_init(JNIEnv *env,
                                                             jobject thiz,
                                                             jstring api_key,
                                                             jboolean dry_run) {
  java_object = env->NewGlobalRef(thiz);
  const char *api_key_str = env->GetStringUTFChars(api_key, nullptr);
  int result = opacity_core::init(api_key_str, dry_run);
  return result;
}

extern "C" JNIEXPORT void JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_executeFlow(
    JNIEnv *env, jobject thiz, jstring flow) {
  const char *flow_str = env->GetStringUTFChars(flow, nullptr);
  std::thread([flow_str]() {
    opacity_core::execute_workflow(flow_str);
  }).detach();
}

extern "C" JNIEXPORT void JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_emitWebviewEvent(
    JNIEnv *env, jobject thiz, jstring event_json) {
  const char *json = env->GetStringUTFChars(event_json, nullptr);
  opacity_core::emit_webview_event(json);
}

jobject createOpacityResponse(JNIEnv *env, int status, const char *json,
                              const char *proof, const char *err) {
  jclass opacityResponseClass =
      env->FindClass("com/opacitylabs/opacitycore/OpacityResponse");

  jmethodID constructor = env->GetMethodID(
      opacityResponseClass, "<init>",
      "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");

  jobject opacityResponse;
  jstring json2, proof2, err2;
  if (status == opacity_core::OPACITY_OK) {
    json2 = env->NewStringUTF(json);
    proof2 = env->NewStringUTF(nullptr);
    err2 = env->NewStringUTF(nullptr);
  } else {
    json2 = env->NewStringUTF(nullptr);
    proof2 = env->NewStringUTF(nullptr);
    err2 = env->NewStringUTF(err);
  }
  opacityResponse = env->NewObject(opacityResponseClass, constructor, status,
                                   json2, proof2, err2);

  return opacityResponse;
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberRiderProfileNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_uber_rider_profile(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberRiderTripHistoryNative(
    JNIEnv *env, jobject thiz, jstring cursor) {
  char *json, *proof, *err;
  const char *cursor_str = env->GetStringUTFChars(cursor, nullptr);
  int status = opacity_core::get_uber_rider_trip_history(cursor_str, &json,
                                                         &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberRiderTripNative(
    JNIEnv *env, jobject thiz, jstring id) {
  char *json, *proof, *err;
  const char *id_str = env->GetStringUTFChars(id, nullptr);
  int status = opacity_core::get_uber_rider_trip(id_str, &json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberDriverProfileNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_uber_driver_profile(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberDriverTripsNative(
    JNIEnv *env, jobject thiz, jstring start_date, jstring end_date,
    jstring cursor) {
  char *json, *proof, *err;
  const char *start_date_str = env->GetStringUTFChars(start_date, nullptr);
  const char *end_date_str = env->GetStringUTFChars(end_date, nullptr);
  const char *cursor_str = env->GetStringUTFChars(cursor, nullptr);
  int status = opacity_core::get_uber_driver_trips(
      start_date_str, end_date_str, cursor_str, &json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getRedditAccountNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_reddit_account(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getRedditFollowedSubredditsNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status =
      opacity_core::get_reddit_followed_subreddits(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getRedditCommentsNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_reddit_comments(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getRedditPostsNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_reddit_posts(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getZabkaAccountNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_zabka_account(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getZabkaPointsNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_zabka_points(&json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getUberFareEstimate(
    JNIEnv *env, jobject thiz, jdouble j_pickup_latitude,
    jdouble j_pickup_longitude, jdouble j_destination_latitude,
    jdouble j_destination_longitude) {
  char *json, *proof, *err;
  auto pickup_latitude = static_cast<double>(j_pickup_latitude);
  auto pickup_longitude = static_cast<double>(j_pickup_longitude);
  auto destination_latitude = static_cast<double>(j_destination_latitude);
  auto destination_longitude = static_cast<double>(j_destination_longitude);
  int status = opacity_core::get_uber_fare_estimate(
      pickup_latitude, pickup_longitude, destination_latitude,
      destination_longitude, &json, &proof, &err);

  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getCartaProfileNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_carta_profile(&json, &proof, &err);
  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getCartaOrganizationsNative(
    JNIEnv *env, jobject thiz) {
  char *json, *proof, *err;
  int status = opacity_core::get_carta_organizations(&json, &proof, &err);
  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getCartaPortfolioInvestmentsNative(
    JNIEnv *env, jobject thiz, jstring firm_id, jstring account_id) {
  char *json, *proof, *err;
  const char *firm_id_str = env->GetStringUTFChars(firm_id, nullptr);
  const char *account_id_str = env->GetStringUTFChars(account_id, nullptr);

  int status = opacity_core::get_carta_portfolio_investments(
      firm_id_str, account_id_str, &json, &proof, &err);
  return createOpacityResponse(env, status, json, proof, err);
}
extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getCartaHoldingsCompaniesNative(
    JNIEnv *env, jobject thiz, jstring account_id) {
  char *json, *proof, *err;
  const char *account_id_str = env->GetStringUTFChars(account_id, nullptr);
  int status = opacity_core::get_carta_holdings_companies(account_id_str, &json,
                                                          &proof, &err);
  return createOpacityResponse(env, status, json, proof, err);
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_opacitylabs_flutter_1opacity_1core_OpacityCore_getCartaCorporationSecuritiesNative(
    JNIEnv *env, jobject thiz, jstring account_id, jstring corporation_id) {
  char *json, *proof, *err;
  const char *account_id_str = env->GetStringUTFChars(account_id, nullptr);
  const char *corporation_id_str =
      env->GetStringUTFChars(corporation_id, nullptr);
  int status = opacity_core::get_carta_corporation_securities(
      account_id_str, corporation_id_str, &json, &proof, &err);
  return createOpacityResponse(env, status, json, proof, err);
}