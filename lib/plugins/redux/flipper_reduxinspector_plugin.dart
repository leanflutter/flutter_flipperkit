import 'package:flutter/services.dart';
import '../../flipper_plugin.dart';

class ActionInfo {
  String uniqueId;
  String actionType;
  int timeStamp;
  dynamic state;

  ActionInfo({
    this.uniqueId, 
    this.actionType,
    this.timeStamp, 
    this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'uniqueId'    : uniqueId,
      'actionType'  : actionType,
      'timeStamp'   : timeStamp,
      'state'       : state,
    };
  }
}

class FlipperReduxInspectorPlugin extends FlipperPlugin{
  static const MethodChannel _channel = const MethodChannel('flutter_flipperkit'); 

  @override
  String getId() {
    return 'ReduxInspector';
  } 

  void report(final ActionInfo actionInfo) async {
    await _channel.invokeMethod('pluginReduxInspectorReport', actionInfo.toJson());
  }
}