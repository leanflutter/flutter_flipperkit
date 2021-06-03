# Getting started

## Installation

To install the [Flipper Desktop](https://fbflipper.com/), you can download a prebuilt binary from the [flipper homepage](https://fbflipper.com/).

## Integrations

> more plugins, please see [https://github.com/leanflutter/flutter_flipperkit_plugins](https://github.com/leanflutter/flutter_flipperkit_plugins)。

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_flipperkit: ^0.0.27
```

Change your project `ios/Podfile` file according to the example:

```diff
# Uncomment this line to define a global platform for your project
-# platform :ios, '9.0'
+platform :ios, '10.0'
```

Change your project files according to the example:

`android/app/build.gradle`:

```diff
android {
-    compileSdkVersion 27
+    compileSdkVersion 28

    defaultConfig {
-        targetSdkVersion 27
+        targetSdkVersion 28
    }
}
```

`android/app/gradle.properties`:

```diff
+android.useAndroidX=true
+android.enableJetifier=true
```

`android/settings.gradle`:
```diff
...

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory

+    if (name == 'flutter_flipperkit') {
+        include ':flipper-no-op'
+        project(':flipper-no-op').projectDir = new File(pluginDirectory, 'flipper-no-op')
+    }
}

...

```

You can install packages from the command line:

```bash
$ flutter packages get
```

### Usage

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin(
    // If you use http library, you must set it to false and use https://pub.dev/packages/flipperkit_http_interceptor
    // useHttpOverrides: false,
    // Optional, for filtering request
    filter: (HttpClientRequest request) {
      String url = '${request.uri}';
      if (url.startsWith('https://via.placeholder.com') || url.startsWith('https://gravatar.com')) {
        return false;
      }
      return true;
    }
  ));
  flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  flipperClient.start();

  runApp(MyApp());
}

...

```

> Please refer to  [flutter_flipperkit_examples](flutter_flipperkit_examples) project, to integrate `flutter_flipperkit` into your project.

### Run the app

```bash
$ flutter run
```

## Known Issues (to note)

- 【iOS】If you use `use_frameworks!` in your Podfile, Please see the [issue](https://github.com/leanflutter/flutter_flipperkit/issues/10#issuecomment-505138362).
