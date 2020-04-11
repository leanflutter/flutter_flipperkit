# flutter_flipperkit

[![pub version][pub-image]][pub-url]
[![Join the chat][telegram-image]][telegram-url]

[pub-image]: https://img.shields.io/pub/v/flutter_flipperkit.svg
[pub-url]: https://pub.dev/packages/flutter_flipperkit
[telegram-image]:https://img.shields.io/badge/chat-on%20telegram-blue.svg
[telegram-url]: https://t.me/flipper4flutter

[English](./README.md) | 简体中文

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [简介](#%E7%AE%80%E4%BB%8B)
  - [特性](#%E7%89%B9%E6%80%A7)
- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [必备条件](#%E5%BF%85%E5%A4%87%E6%9D%A1%E4%BB%B6)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
  - [运行程序](#%E8%BF%90%E8%A1%8C%E7%A8%8B%E5%BA%8F)
- [已知问题（需注意）](#%E5%B7%B2%E7%9F%A5%E9%97%AE%E9%A2%98%E9%9C%80%E6%B3%A8%E6%84%8F)
- [相关链接](#%E7%9B%B8%E5%85%B3%E9%93%BE%E6%8E%A5)
- [探讨](#%E6%8E%A2%E8%AE%A8)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 简介

*Flipper (Extensible mobile app debugger) for flutter.*

[查看文档](./docs/zh_CN/README.md)

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
  flutter_flipperkit: ^0.0.21
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

## 探讨

欢迎加入「Flipper for Flutter」的 [Telegram Group](https://t.me/flipper4flutter) 与我分享你的建议和想法。

## 许可证

```text
MIT License

Copyright (c) 2019 LiJianying <lijy91@foxmail.com>

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
