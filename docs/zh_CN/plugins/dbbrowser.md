# 数据库

轻松浏览应用的本地数据库。

![](../../../screenshots/flipper-plugin-dbbrowser.png)

## 快速开始

### 初始化

要使用数据库插件，您需要将插件添加到 `FlipperClient` 实例。

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  var databaseDriver = SqfliteDriver('simple_todo.db'); // 示例使用了 Sqflite
  flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin(databaseDriver));
  flipperClient.start();

  runApp(MyApp());
}
```

### 开启检查

对于 [sqfite](https://github.com/tekartik/sqflite)，我们为你准备了 [flipperkit_sqflite_driver](https://github.com/blankapp/flutter_flipperkit_plugins/tree/master/packages/flipperkit_sqflite_driver) 驱动：

```dart
var sqfliteDriver = SqfliteDriver('simple_todo.db');
flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin(sqfliteDriver));
```

## 相关链接

- https://github.com/tekartik/sqflite
- https://github.com/blankapp/flipper-plugin-dbbrowser