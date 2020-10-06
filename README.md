# flutter_flipperkit

[![pub version][pub-image]][pub-url]

[pub-image]: https://img.shields.io/pub/v/flutter_flipperkit.svg
[pub-url]: https://pub.dev/packages/flutter_flipperkit

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [flutter_flipperkit](#flutter_flipperkit)
  - [Introduction](#introduction)
    - [Features](#features)
  - [Quick Start](#quick-start)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
      - [Android](#android)
      - [iOS](#ios)
    - [Usage](#usage)
    - [Run the app](#run-the-app)
  - [Related Links](#related-links)
  - [Discussion](#discussion)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

[Flipper](https://fbflipper.com) (Extensible mobile app debugger) for flutter. [View document](https://flutter-widget.live/flutter_flipperkit)

![](./screenshots/flipper.png)

### Features

- Network inspector
- Shared preferences inspector
- Redux inspector
- Database Browser

## Quick Start

### Prerequisites

Before starting make sure you have:

- Installed [Flipper Desktop](https://fbflipper.com/)

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_flipperkit: ^0.0.24
```

Or

```yaml
dependencies:
  flutter_flipperkit:
    git:
      url: https://github.com/leanflutter/flutter_flipperkit
      ref: master
```

#### Android

Change your project files according to the example:

`android/settings.gradle`:

```diff
include ':app'

def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
def properties = new Properties()

assert localPropertiesFile.exists()
localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }

def flutterSdkPath = properties.getProperty("flutter.sdk")
assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"

+ def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()
+ def plugins = new Properties()
+ def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
+ assert pluginsFile.exists()
+ pluginsFile.withReader("UTF-8") { reader -> plugins.load(reader) }
+ plugins.each { name, path ->
+     def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
+     if (name == 'flutter_flipperkit') {
+         include ':flipper-no-op'
+         project(':flipper-no-op').projectDir = new File(pluginDirectory, 'flipper-no-op')
+     }
+ }

```

#### iOS

> Open `ios/Runner.xcworkspace` Add a empty Swift file (e.g `Runner-Noop.swift`) into `Runner` Group And make sure the `Runner-Bridging-Header.h` file is created. 

Change your project `ios/Podfile` file according to the example:

```diff
# Uncomment this line to define a global platform for your project
- # platform :ios, '9.0'
+platform :ios, '9.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end

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

> Please refer to [examples](https://github.com/leanflutter/flutter_flipperkit_examples), to integrate `flutter_flipperkit` into your project.

You can install packages from the command line:

```bash
$ flutter clean
$ flutter packages get
```

### Run the app

```bash
$ flutter run
```

## Related Links

- https://github.com/facebook/flipper
- https://github.com/leanflutter/flipper-plugin-dbbrowser
- https://github.com/leanflutter/flipper-plugin-reduxinspector

## Discussion

If you have any suggestions or questions about this project, you can discuss it by [Telegram Group](https://t.me/joinchat/I4jz1FE5sBGk7V0jUpzSXg) with me.

## License

```text
MIT License

Copyright (c) 2019-2020 LiJianying <lijy91@foxmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
