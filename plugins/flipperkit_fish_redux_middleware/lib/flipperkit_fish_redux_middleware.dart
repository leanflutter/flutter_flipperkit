library flipperkit_fish_redux_middleware;

import 'dart:convert';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:uuid/uuid.dart';

Middleware<T> flipperKitFishReduxMiddleware<T>({
  bool Function(String actionType) filter,
}) {
  Uuid _uuid = Uuid();

  return ({Dispatch dispatch, Get<T> getState}) {
    return (Dispatch next) {
      if (!isDebug()) return next;

      return (Action action) {
        String actionType = '${action.type}';
        dynamic payload;
        dynamic prevState;
        dynamic nextState;
        try {
          prevState = json.encode(getState());
        } catch (e) {
          prevState = getState().toString();
        }

        next(action);

        if (filter == null) {
          filter = (String actionType) {
            return actionType.startsWith('\$');
          };
        }
        
        if (filter(actionType)) {
          return;
        }

        try {
          payload = json.encode(action.payload);
        } catch (e) {
          payload = <String, String>{};
        }

        try {
          nextState = json.encode(getState());
        } catch (e) {
          nextState = getState().toString();
        }

        String uniqueId = _uuid.v4();
        ActionInfo actionInfo = new ActionInfo(
          uniqueId: uniqueId,
          actionType: actionType,
          timeStamp: new DateTime.now().millisecondsSinceEpoch,
          payload: payload,
          prevState: prevState,
          nextState: nextState,
        );

        FlipperReduxInspectorPlugin _flipperReduxInspectorPlugin =
          FlipperClient.getDefault().getPlugin("ReduxInspector");

        if (_flipperReduxInspectorPlugin != null) {
          _flipperReduxInspectorPlugin.report(actionInfo);
        }
      };
    };
  };
}
