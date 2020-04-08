# flipperkit_http_interceptor

[![pub package](https://img.shields.io/pub/v/flipperkit_http_interceptor.svg)](https://pub.dartlang.org/packages/flipperkit_http_interceptor)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=lijy91%40live.com&currency_code=USD&source=url)

[English](./README.md) | 简体中文

> `flutter_flipperkit` 暂不支持全局拦截 [http](https://github.com/dart-lang/http) 库的网络请求，请设置网络插件 `useHttpOverrides` 参数为 `false`。

## 快速开始

### 必备条件

开始之前确保你已安装：

- 已安装 [flutter_flipperkit](https://github.com/blankapp/flutter_flipperkit)
- 已安装 [http](https://github.com/dart-lang/http)

### 安装

添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flipperkit_http_interceptor: ^0.0.1
```

您可以通过命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

```dart
void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin(
    // If you use http library, you must set it to false
    useHttpOverrides: false,
  ));
  flipperClient.start();

  runApp(MyApp());
}

...

```

```dart
import 'package:flipperkit_http_interceptor/flipperkit_http_interceptor.dart';

void sendRequest() async {
  var http = new HttpClientWithInterceptor();
  var response = http.get("https://example.com");
}
```

## 探讨

如果您对此项目有任何建议或疑问，可以通过 [Telegram Group](https://t.me/flipper4flutter) 或我的微信进行讨论。

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
