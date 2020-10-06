# Redux

You can browse through all the historical actions of your state manager, and also compare the state changes before and after each action, support [redux](https://github.com/brianegan/flutter_redux) and [fish-redux](https://github.com/alibaba/fish-redux)。

![](../.vuepress/images/redux-inspector.png)

## Quick start

### Initialization

To use the redux plugin, you need to add the plugin to your `FlipperClient` instance.

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

### Enable Inspection

for [redux](https://github.com/brianegan/flutter_redux/), you can use [flipperkit_redux_middleware](https://github.com/leanflutter/flutter_flipperkit_plugins/blob/master/packages/flipperkit_redux_middleware) middleware:

```dart
import 'package:redux/redux.dart';
import 'package:flipperkit_redux_middleware/flipperkit_redux_middleware.dart';

void main() async {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: []
      ..add(new FlipperReduxMiddleware(
        // Optional, for filtering action types
        filter: (actionType) {
          return actionType.startsWith('\$');
        }
      ))
  );

  runApp(MyApp(
    store: store
  ));
}
```

for [fish-redux](https://github.com/alibaba/fish-redux), you can use [flipperkit_fish_redux_middleware](https://github.com/leanflutter/flutter_flipperkit_plugins/blob/master/packages/flipperkit_fish_redux_middleware) middleware:

```dart
import 'package:fish_redux/fish_redux.dart';
import 'package:flipperkit_fish_redux_middleware/flipperkit_fish_redux_middleware.dart';

import 'effect.dart';
import 'list_adapter/adapter.dart';
import 'reducer.dart';
import 'report_component/component.dart';
import 'state.dart';

import 'view.dart';

class ToDoListPage extends Page<PageState, Map<String, dynamic>> {
  ToDoListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PageState>(
              adapter: ToDoListAdapter(),
              slots: <String, Dependent<PageState>>{
                'report': ReportConnector() + ReportComponent()
              }),
          middlewares: <Middleware<PageState>>[
            logMiddleware(tag: 'ToDoListPage'),
            flipperKitFishReduxMiddleware(
              // Optional, for filtering action types
              filter: (actionType) {
                return actionType.startsWith('\$');
              }
            ),
          ],
        );
}

```

## Related Links

- https://github.com/brianegan/flutter_redux
- https://github.com/alibaba/fish-redux
