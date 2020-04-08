# flipperkit_sqflite_driver

[![pub package](https://img.shields.io/pub/v/flipperkit_sqflite_driver.svg)](https://pub.dartlang.org/packages/flipperkit_sqflite_driver)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=lijy91%40live.com&currency_code=USD&source=url)

English | [简体中文](./README.zh_CN.md)

## Getting Started

### Prerequisites

Before starting make sure you have:

- Installed [flutter_flipperkit](https://github.com/blankapp/flutter_flipperkit)
- Installed [flipper-plugin-dbbrowser](https://github.com/blankapp/flipper-plugin-dbbrowser)
- Installed [sqflite](https://github.com/tekartik/sqflite)

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flipperkit_sqflite_driver: ^0.0.2
```

You can install packages from the command line:

```bash
$ flutter packages get
```

### Usage

```dart
import 'package:flipperkit_sqflite_driver/flipperkit_sqflite_driver.dart';

void main() async {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin(SqfliteDriver('simple_todo.db')));
  flipperClient.start();

  runApp(MyApp());
}
```

## Discussion

If you have any suggestions or questions about this project, you can discuss it by [Telegram](https://t.me/lijy91) or my wechat.

![](http://blankapp.org/assets/images/wechat_qrcode.png)

## License

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
