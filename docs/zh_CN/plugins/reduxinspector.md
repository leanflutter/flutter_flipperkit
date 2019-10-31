# Redux

可以浏览你的状态管理器的所有历史动作（Action），通过它还对比每次动作前后的状态变化，支持 [redux](https://github.com/brianegan/flutter_redux/) 及 [fish-redux](https://github.com/alibaba/fish-redux)。

![](../../.vuepress/images/redux-inspector.png)

## 快速开始

### 初始化

要使用 Redux 插件，您需要将插件添加到 `FlipperClient` 实例。

```dart
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  flipperClient.start();

  runApp(MyApp());
}
```

### 开启检查

对于 [redux](https://github.com/brianegan/flutter_redux/)，我们为你准备了 [flipperkit_redux_middleware](https://github.com/blankapp/flutter_flipperkit_plugins/blob/master/packages/flipperkit_redux_middleware) 中间件：

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

对于 [fish-redux](https://github.com/alibaba/fish-redux)，我们为你准备了 [flipperkit_fish_redux_middleware](https://github.com/blankapp/flutter_flipperkit_plugins/blob/master/packages/flipperkit_fish_redux_middleware) 中间件：

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

## 相关链接

- https://github.com/brianegan/flutter_redux
- https://github.com/alibaba/fish-redux
