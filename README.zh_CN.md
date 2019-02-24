# flutter_flipperkit

[![pub package](https://img.shields.io/pub/v/flutter_flipperkit.svg)](https://pub.dartlang.org/packages/flutter_flipperkit)

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
  flutter_flipperkit: ^0.0.2
```

根据示例更改项目的 ios/Podfile 文件：

```diff
+source 'https://github.com/facebook/flipper.git'
+source 'https://github.com/CocoaPods/Specs'
# Uncomment this line to define a global platform for your project
-# platform :ios, '9.0'
+platform :ios, '9.0'
```

根据示例更改项目的 android/app/build.gradle 文件：

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

  Random random = new Random();
  String identifier = '${random.nextInt(9999)}';
  RequestInfo requestInfo = RequestInfo(
    requestId: identifier,
    timeStamp: new DateTime.now().millisecondsSinceEpoch,
    headers: new Map()
      ..putIfAbsent("Content-Type", () => "application/json"),
    method: 'POST',
    uri: 'https://api.example.com/account/login',
    body: new Map()
       ..putIfAbsent("username", () => 'lijy91')
       ..putIfAbsent("password", () => "qDrTBZk8jgbA"),
  );
  ResponseInfo responseInfo = ResponseInfo(
    requestId: identifier,
    timeStamp: new DateTime.now().millisecondsSinceEpoch,
    statusCode: 200,
    headers: new Map()
      ..putIfAbsent("Server", () => "Apache/2.4.1 (Unix)")
      ..putIfAbsent("Content-Type", () => "application/json"),
    body: new Map()
      ..putIfAbsent("code", () => 0)
      ..putIfAbsent("message", () => "login successful"),
  );

  FlipperNetworkPlugin flipperNetworkPlugin = FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);
  flipperNetworkPlugin.reportRequest(requestInfo);
  flipperNetworkPlugin.reportResponse(responseInfo);

  runApp(MyApp());
}

...

```

### 运行程序

```bash
$ flutter run
```

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