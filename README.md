# flutter_flipperkit

## 简介

*Flipper SDK for Flutter 可帮助您调试在模拟器或连接的物理开发设备中运行的 Flutter 应用。*

### 特性

- 网络检查
- Coming soon

## 快速开始

### 安装

添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_flipperkit: ^0.0.1
```

运行以下命令安装依赖包：

```bash
$ flutter packages get
```

### 用法

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.start();

  // 在网络框架拦截器中添加下面逻辑
  String identifier = uuid.v4();
  RequestInfo requestInfo = RequestInfo(
    requestId: identifier,
    timeStamp: new DateTime.now().millisecondsSinceEpoch,
    // headers
    method: 'POST',
    uri: 'https://api.example.com/account/login',
    // body,
  );
  ResponseInfo responseInfo = ResponseInfo(
    requestId: identifier,
    timeStamp: new DateTime.now().millisecondsSinceEpoch,
    statusCode: 200,
    body: new Map()
      ..putIfAbsent("code", () => 0)
      ..putIfAbsent("message", () => "login successful")
  );

  FlipperNetworkPlugin flipperNetworkPlugin = FlipperClient.getDefault()
                  .getPlugin(FlipperNetworkPlugin.ID);
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