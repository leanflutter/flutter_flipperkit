# Network

You can easily browse all requests being made and their responses. The plugin also supports gzipped responses.

![](../../../screenshots/flipper-plugin-network.png)

## Quick start

### Initialization

To use the network plugin, you need to add the plugin to your `FlipperClient` instance.

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

> `flutter_flipperkit` already supports global interception of network requests (based on the `HttpClient` API), no additional configuration is required.

### Enable Inspection

> If necessary, you can turn off the default global interception function, and then turn it on by adding the corresponding interceptor.

```dart
  flipperClient.addPlugin(new FlipperNetworkPlugin(useHttpOverrides: false));
  flipperClient.start();
```

for [dio](https://github.com/flutterchina/dio) 2.x, you can use [flipperkit_dio_interceptor](https://github.com/blankapp/flutter_flipperkit_plugins/tree/master/packages/flipperkit_dio_interceptor) interceptor:

```dart
final dio = new Dio(options);
dio.interceptors.add(FlipperKitDioInterceptor());
```

## Related Links

- https://github.com/flutterchina/dio
