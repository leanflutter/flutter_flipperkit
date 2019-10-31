# Shared preferences

Easily inspect and modify the data contained within your app's shared preferences.

![](../../../screenshots/flipper-plugin-shared-preferences.png)

## Quick start

### Initialization

To use the shared preferences plugin, you need to add the plugin to your `FlipperClient` instance.

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

> for now only support [shared_preferences](https://pub.dev/packages/shared_preferences).

## Related Links

- https://pub.dev/packages/shared_preferences
