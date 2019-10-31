# 共享首选项

轻松检查和修改应用程序共享首选项中包含的数据。

![](../../../screenshots/flipper-plugin-shared-preferences.png)

## 快速开始

### 初始化

要使用共享首选项插件，您需要将插件添加到 `FlipperClient` 实例。

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

> 当前仅支持检查 [shared_preferences](https://pub.dev/packages/shared_preferences) 所产生的数据。

## 相关链接

* https://pub.dev/packages/shared_preferences
