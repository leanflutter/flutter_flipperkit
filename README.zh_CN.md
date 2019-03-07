# flutter_flipperkit

[![pub package](https://img.shields.io/pub/v/flutter_flipperkit.svg)](https://pub.dartlang.org/packages/flutter_flipperkit)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=lijy91%40live.com&currency_code=USD&source=url)

[English](./README.zh_CN.md) | 简体中文

## 简介

*Flipper SDK for Flutter 可帮助您调试在模拟器或连接的物理开发设备中运行的 Flutter 应用。*

### 特性

- Network inspector
![network](https://fbflipper.com/docs/assets/network.png)

- Shared preferences (and UserDefaults) inspector
![shared-preferences](https://fbflipper.com/docs/assets/shared-preferences.png)

## 快速开始

### 必备条件

开始之前确保你已安装：

- 已安装 [Flipper Desktop](https://fbflipper.com/docs/getting-started.html)

### 安装

添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_flipperkit: ^0.0.4
```

根据示例更改项目的 ios/Podfile 文件：

```diff
+source 'https://github.com/facebook/flipper.git'
+source 'https://github.com/CocoaPods/Specs'
# Uncomment this line to define a global platform for your project
-# platform :ios, '9.0'
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

您可以通过命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  flipperClient.start();

  runApp(MyApp());
}

...

```

> 请参考 [dio 2.0.x](https://github.com/flutterchina/dio) 的 [集成示例](./example/lib/networking/api_client/api_client.dart) 将 `flutter_flipperkit` 集成到你的项目

### 运行程序

```bash
$ flutter run
```

## 已知问题（需注意）

- 【iOS】如果使用 cocoapods 1.6.0 及以上版本，不支持 `use_frameworks!`

## 探讨

如果您对此项目有任何建议或疑问，可以通过 [Telegram](https://t.me/lijy91) 或我的微信进行讨论。

![](http://blankapp.org/assets/images/wechat_qrcode.png)

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