import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class FlipperDioInterceptor extends InterceptorsWrapper {
  FlipperNetworkPlugin _flipperNetworkPlugin;

  FlipperDioInterceptor() {
    _flipperNetworkPlugin = FlipperClient
      .getDefault().getPlugin(FlipperNetworkPlugin.ID);
  }

  @override
  onRequest(RequestOptions options) {
    this._reportRequest(options);
    return options;
  }

  @override
  onResponse(Response response) {
    this._reportResponse(response);
    return response;
  }

  @override
  onError(DioError err) {
    if (err.response != null) {
      this._reportResponse(err.response);
    }
    return err;
  }

  void _reportRequest(RequestOptions options) {
    String requestId = new Uuid().v4();
    options.extra.putIfAbsent("requestId", () => requestId);
    RequestInfo requestInfo = new RequestInfo(
      requestId: requestId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: '${options.baseUrl}${options.path}',
      headers: options.headers,
      method: options.method,
      body: options.data,
    );

    _flipperNetworkPlugin.reportRequest(requestInfo);
  }

  void _reportResponse(Response response) {
    Map<String, dynamic> headers = new Map();
      for (var key in []
        ..addAll(HttpHeaders.entityHeaders)
        ..addAll(HttpHeaders.requestHeaders)
        ..addAll(HttpHeaders.responseHeaders)
      ) {
        var value = response.headers.value(key);

        if (value != null && value.isNotEmpty) {
          headers.putIfAbsent(key, () => value);
        }
      }
      String requestId = response.request.extra['requestId'];
      ResponseInfo responseInfo = new ResponseInfo(
        requestId: requestId,
        timeStamp: new DateTime.now().millisecondsSinceEpoch,
        statusCode: response.statusCode,
        headers: headers,
        body: response.data,
      );

      _flipperNetworkPlugin.reportResponse(responseInfo);
  }
}
