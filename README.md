# flutter_opacity_core

Opacity Core for flutter

## Getting Started

Install the flutter dependency:

https://pub.dev/packages/flutter_opacity_core

## iOS

You need to bump min iOS version to iOS 14 or newer. Then do a `pod install` on the `ios`. Sometimes when upgrading versions you might find it cannot find the new version of the native dependency. You can try with `pod install --repo-update` or by deleting the `Podfile.lock` file and running pod install again.

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

```groovy
    defaultConfig {
        // the rest of your config
        minSdk = 24 // Change this!
    }
```
