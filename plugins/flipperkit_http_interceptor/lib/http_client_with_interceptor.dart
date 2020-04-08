library flipperkit_http_client;

import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class HttpClientWithInterceptor implements http.BaseClient {
  Uuid _uuid = new Uuid();
  http.Client _client = new http.Client();

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> delete(url, {Map<String, String> headers}) async {
    return _withInterceptor(
      method: 'DELETE',
      url: url,
      headers: headers,
      sendRequest: () => _client.delete(url, headers: headers),
    );
  }

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) {
    return _withInterceptor(
      method: 'GET',
      url: url,
      headers: headers,
      sendRequest: () => _client.get(url, headers: headers),
    );
  }

  @override
  Future<http.Response> head(url, {Map<String, String> headers}) {
    return _withInterceptor(
      method: 'HEAD',
      url: url,
      headers: headers,
      sendRequest: () => _client.head(url, headers: headers),
    );
  }

  @override
  Future<http.Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
    return _withInterceptor(
      method: 'PATCH',
      url: url,
      headers: headers,
      body: body,
      encoding: encoding,
      sendRequest: () => _client.patch(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<http.Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    return _withInterceptor(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
      encoding: encoding,
      sendRequest: () => _client.post(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<http.Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
    return _withInterceptor(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
      encoding: encoding,
      sendRequest: () => _client.put(url, headers: headers, body: body, encoding: encoding),
    );
  }

  @override
  Future<String> read(url, {Map<String, String> headers}) {
    return _client.read(url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
    return _client.readBytes(url, headers: headers);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  Future<http.Response> _withInterceptor({
    String method, 
    String url,
    Map<String, String> headers, 
    body, 
    Encoding encoding,
    Future<http.Response> Function() sendRequest,
  }) async {
    String requestId = _uuid.v4();
    _reportRequest(
      requestId,
      method: method,
      url: url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    http.Response response = await sendRequest();

    _reportResponse(requestId, response);

    return response;
  }

  Future<bool> _reportRequest(requestId, {
    String method, 
    String url,
    Map<String, String> headers, 
    body, 
    Encoding encoding,
  }) async {
    RequestInfo requestInfo = new RequestInfo(
      requestId: requestId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: url,
      headers: headers,
      method: method,
      body: body,
    );

    FlipperNetworkPlugin _flipperNetworkPlugin =
        FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);

    if (_flipperNetworkPlugin != null) {
      _flipperNetworkPlugin?.reportRequest(requestInfo);
    }
    return true;
  }

  Future<bool> _reportResponse(String requestId, http.Response response) async {
    ResponseInfo responseInfo = new ResponseInfo(
      requestId: requestId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
    );

    FlipperNetworkPlugin _flipperNetworkPlugin =
        FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);

    if (_flipperNetworkPlugin != null) {
      _flipperNetworkPlugin?.reportResponse(responseInfo);
    }
    return true;
  }
}
