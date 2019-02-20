import 'dart:async';
import 'package:flutter/services.dart';
import './flipper_plugin.dart';

class FlipperClient {
  static const MethodChannel _channel = const MethodChannel('flutter_flipperkit'); 

  void addPlugin(FlipperPlugin plugin) async {
    await _channel.invokeMethod('clientAddPlugin', {
      'id': plugin.getId(),
    });
  }

  void start() async {
    await _channel.invokeMethod('clientStart');
  }

  void stop() async {
    await _channel.invokeMethod('clientStop');
  }
}