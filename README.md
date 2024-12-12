# flutter_opacity_core

Opacity Core for flutter

## Getting Started

Install the flutter dependency:

https://pub.dev/packages/flutter_opacity_core

## iOS

You need to bump min iOS version to iOS 14 or newer.

### Android

First add the necessary repos to download the dependencies. On your root `build.gradle` add:

```
allprojects {
  repositories {
    google()
    mavenCentral()
    maven { url "https://maven.mozilla.org/maven2/" }
    maven { url 'https://jitpack.io' }
  }
}
```

On your apps `AndroidManifest.xml` add an activity:

```xml
      <activity
        android:name="com.opacitylabs.opacitycore.InAppBrowserActivity"
        android:theme="@style/Theme.AppCompat.DayNight" />
    // Just above the closing tag of "application"
    </application>
```

You will also have to bump the minSDK version to 23. In your app's `build.gradle` file:

```gradle
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.opacitylabs.flutter_opacity_core_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24 // Change this!
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
```
