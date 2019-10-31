# 网络

可以轻松浏览所有正在发出的请求及其响应。该插件还支持 `gzip` 压缩响应。

![](../../../screenshots/flipper-plugin-network.png)

## 快速开始

### 初始化

要使用网络插件，您需要将插件添加到 `FlipperClient` 实例。

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

> `flutter_flipperkit` 已支持全局拦截网络请求（基于 `HttpClient` API），则无需进行额外的配置。

### 开启检查

> 如有需要，可关闭默认全局拦截的功能，改为通过添加对应的拦截器进行开启该功能。

```dart
  flipperClient.addPlugin(new FlipperNetworkPlugin(useHttpOverrides: false));
  flipperClient.start();
```

对于 [dio](https://github.com/flutterchina/dio) 2.x，我们为你准备了 [flipperkit_dio_interceptor](https://github.com/blankapp/flutter_flipperkit_plugins/tree/master/packages/flipperkit_dio_interceptor) 拦截器：

```dart
final dio = new Dio(options);
dio.interceptors.add(FlipperKitDioInterceptor());
```

## 相关链接

- https://github.com/flutterchina/dio