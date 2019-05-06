import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../flipper_client.dart';
import './flipper_network_plugin.dart';
import './flipper_http_client_response.dart';

class FlipperHttpClientRequest implements HttpClientRequest {
  FlipperNetworkPlugin _flipperNetworkPlugin;

  final String uniqueId;
  final HttpClientRequest request;
  Stream<List<int>> requestStream;

  FlipperHttpClientRequest(this.uniqueId, this.request) {
    _flipperNetworkPlugin =
        FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);
  }
  
  @override
  bool bufferOutput;

  @override
  int contentLength;

  @override
  Encoding encoding;

  @override
  bool followRedirects;

  @override
  int maxRedirects;

  @override
  bool persistentConnection;

  @override
  void add(List<int> data) {
    request.add(data);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    request.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    requestStream = stream;
    return request.addStream(stream);
  }

  @override
  Future<HttpClientResponse> close() async {
    await this._reportRequest(uniqueId, request);
    final response = await request.close();

    return await withInterceptor(response);
  }

  @override
  HttpConnectionInfo get connectionInfo => request.connectionInfo;

  @override
  List<Cookie> get cookies => request.cookies;

  @override
  Future<HttpClientResponse> get done => request.done;

  @override
  Future flush() {
    return request.flush();
  }

  @override
  HttpHeaders get headers => request.headers;

  @override
  String get method => request.method;

  @override
  Uri get uri => request.uri;

  @override
  void write(Object obj) {
    request.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    request.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    request.writeCharCode(charCode);
  }

  @override
  void writeln([Object obj = ""]) {
    request.writeln(obj);
  }

  Future<FlipperHttpClientResponse> withInterceptor(HttpClientResponse response) async {
    FlipperHttpClientResponse responseWithInterceptor = 
      new FlipperHttpClientResponse(this.uniqueId, response);

    return responseWithInterceptor;
  }

  Future<bool> _reportRequest(String uniqueId, HttpClientRequest request) async {
    Map<String, dynamic> headers = new Map();
    request.headers.forEach((String name, List<String> values) {
      if (values != null && values.length > 0) {
        headers.putIfAbsent(name, () => values);
      }
    });

    var body;

    try {
      if (requestStream != null) {
        body = await requestStream.transform(Utf8Decoder(allowMalformed: false)).join();
      }
    } catch (e) { }

    RequestInfo requestInfo = new RequestInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: '${request.uri}',
      headers: headers,
      method: request.method,
      body: body,
    );

    _flipperNetworkPlugin?.reportRequest(requestInfo);
    return true;
  }
}
