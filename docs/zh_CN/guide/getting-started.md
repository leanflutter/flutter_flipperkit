# 快速上手

## 安装

要安装[Flipper Desktop](https://fbflipper.com/) ，您可以从[Flipper 官网](https://fbflipper.com/)下载预构建的二进制文件。

## 集成

> 这是官方维护的一些流行库的支持插件，请查看 [https://github.com/leanflutter/flutter_flipperkit_plugins](https://github.com/leanflutter/flutter_flipperkit_plugins)。


添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_flipperkit: ^0.0.26
```

根据示例更改项目的 ios/Podfile 文件：

```diff
# Uncomment this line to define a global platform for your project
-# platform :ios, '9.0'
+platform :ios, '10.0'
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

> 请参考 [flutter_flipperkit_examples](https://github.com/leanflutter/flutter_flipperkit_examples) 项目，将 `flutter_flipperkit` 集成到你的项目。

### 运行程序

```bash
$ flutter run
```

## 已知问题（需注意）

- 【iOS】如果您在Podfile中使用`use_frameworks！`，请查看该 [issue](https://github.com/leanflutter/flutter_flipperkit/issues/10#issuecomment-505138362)。
