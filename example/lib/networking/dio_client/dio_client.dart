import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class DioClient {
  static DioClient shared = new DioClient();

  Dio _http;
  FlipperNetworkPlugin _flipperNetworkPlugin;

  DioClient() {
    _flipperNetworkPlugin = FlipperClient
      .getDefault().getPlugin(FlipperNetworkPlugin.ID);
    
    Options options = new Options(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      responseType: ResponseType.JSON,
    );
    this._http = new Dio(options);
    this._http.interceptor.request.onSend = (Options options) async {
      this._reportRequest(options);
      return options;
    };
    this._http.interceptor.response.onSuccess = (Response response) {
      this._reportResponse(response);
      return response;
    };
  }

  Dio get http {
    return _http;
  }

  void _reportRequest(Options options) {
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
