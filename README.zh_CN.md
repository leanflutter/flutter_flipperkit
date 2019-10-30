# flutter_flipperkit

[![pub package](https://img.shields.io/pub/v/flutter_flipperkit.svg)](https://pub.dev/packages/flutter_flipperkit)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=lijy91%40live.com&currency_code=USD&source=url)

[English](./README.md) | 简体中文

Table of Contents
=================

  * [简介](#简介)
      * [特性](#特性)
  * [快速开始](#快速开始)
      * [必备条件](#必备条件)
      * [安装](#安装)
      * [用法](#用法)
      * [运行程序](#运行程序)
  * [已知问题（需注意）](#已知问题需注意)
  * [相关链接](#相关链接)
  * [探讨](#探讨)
  * [Stargazers over time](#stargazers-over-time)
  * [许可证](#许可证)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## 简介

*Flipper (Extensible mobile app debugger) for flutter.*

### 特性

- Network inspector
![network](https://fbflipper.com/docs/assets/network.png)

- Shared preferences (and UserDefaults) inspector
![shared-preferences](https://fbflipper.com/docs/assets/shared-preferences.png)

- Redux inspector
- Database Browser

## 快速开始

### 必备条件

开始之前确保你已安装：

- 已安装 [Flipper Desktop](https://fbflipper.com/docs/getting-started.html)

### 安装

添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_flipperkit: ^0.0.20
```

如何你在使用旧版本的 Flutter ，请使用以下方式添加：

```yaml
dependencies:
  flutter_flipperkit:
    git:
      url: https://github.com/blankapp/flutter_flipperkit
      ref: legacy
```

根据示例更改项目的 ios/Podfile 文件：

```diff
# Uncomment this line to define a global platform for your project
-# platform :ios, '8.0'
+platform :ios, '9.0'
```

根据示例更改项目文件：

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

`android/app/gradle.properties`

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

您可以通过命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin(
    // 如果你使用 http 库, 你必须把它设置为 false 且使用 https://pub.dev/packages/flipperkit_http_interceptor
    // useHttpOverrides: false,
    // 可选， 用于过滤请求
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

> 请参考 [flutter_flipperkit_examples](https://github.com/blankapp/flutter_flipperkit_examples) 项目，将 `flutter_flipperkit` 集成到你的项目。

### 运行程序

```bash
$ flutter run
```

## 已知问题（需注意）

- 【iOS】如果您在Podfile中使用`use_frameworks！`，请查看该 [issue](https://github.com/blankapp/flutter_flipperkit/issues/10#issuecomment-505138362)。

## 相关链接

- https://github.com/blankapp/flutter_flipperkit_plugins
- https://github.com/blankapp/flutter_flipperkit_examples
- https://github.com/blankapp/flutter-debugger
- https://github.com/blankapp/flutter-debugger-docs

## 探讨

如果您对此项目有任何建议或疑问，可以通过 [Telegram Group](https://t.me/flutterdebugger) 或我的微信进行讨论。

![](http://blankapp.org/assets/images/wechat_qrcode.png)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/blankapp/flutter_flipperkit.svg)](https://starchart.cc/blankapp/flutter_flipperkit)

## 许可证

```
MIT License

Copyright (c) 2019 JianyingLi <lijy91@foxmail.com>

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