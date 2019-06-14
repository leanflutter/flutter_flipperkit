import 'dart:io';
import 'package:flutter/services.dart';
import '../../flipper_plugin.dart';
import './flipper_http_overrides.dart';

class RequestInfo {
  String requestId;
  int timeStamp;
  Map<String, dynamic> headers;
  String method;
  String uri;
  dynamic body;

  RequestInfo({
    this.requestId, 
    this.timeStamp, 
    this.headers,
    this.method, 
    this.uri,
    this.body,
  });

  Map<String, dynamic> toJson() {
    if (headers == null) {
      headers = new Map();
    }
    return {
      'requestId' : requestId,
      'timeStamp' : timeStamp,
      'headers'   : headers,
      'method'    : method,
      'uri'       : uri,
      'body'      : body,
    };
  }
}

class ResponseInfo {
  String requestId;
  int timeStamp;
  int statusCode;
  String statusReason;
  Map<String, dynamic> headers;
  dynamic body;

  ResponseInfo({
    this.requestId, 
    this.timeStamp, 
    this.statusCode,
    this.statusReason, 
    this.headers,
    this.body,
  });
  Map<String, dynamic> toJson() {
    if (headers == null) {
      headers = new Map();
    }
    return {
      'requestId'     : requestId,
      'timeStamp'     : timeStamp,
      'statusCode'    : statusCode,
      'statusReason'  : statusReason,
      'headers'       : headers,
      'body'          : body,
    };
  }
}

class FlipperNetworkPlugin extends FlipperPlugin {
  static const String ID = 'Network';
  static const MethodChannel _channel = const MethodChannel('flutter_flipperkit'); 

  bool Function(HttpClientRequest request) filter;

  FlipperNetworkPlugin({
    useHttpOverrides = true,
    this.filter,
  }) {
    if (useHttpOverrides) {
      HttpOverrides.global = FlipperHttpOverrides();
    }
  }

  @override
  String getId() {
    return ID;
  }

  void reportRequest(final RequestInfo requestInfo) async {
    await _channel.invokeMethod('pluginNetworkReportRequest', requestInfo.toJson());
  }

  void reportResponse(final ResponseInfo responseInfo) async {
    await _channel.invokeMethod('pluginNetworkReportResponse', responseInfo.toJson());
  }
}