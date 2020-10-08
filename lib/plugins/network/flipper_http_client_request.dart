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
  StreamController<List<int>> streamController = new StreamController();

  FlipperHttpClientRequest(this.uniqueId, this.request) {
    _flipperNetworkPlugin =
        FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);
  }

  @override
  bool get bufferOutput => request.bufferOutput;

  @override
  set bufferOutput(bool value) => request.bufferOutput = value;

  @override
  int get contentLength => request.contentLength;

  @override
  set contentLength(int value) => request.contentLength = value;

  @override
  Encoding get encoding => request.encoding;

  @override
  set encoding(Encoding value) => request.encoding = value;

  @override
  bool get followRedirects => request.followRedirects;

  @override
  set followRedirects(bool value) => request.followRedirects = value;

  @override
  int get maxRedirects => request.maxRedirects;

  @override
  set maxRedirects(int value) => request.maxRedirects = value;

  @override
  bool get persistentConnection => request.persistentConnection;

  @override
  set persistentConnection(bool value) => request.persistentConnection = value;

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
    Stream<List<int>> broadcastStream = stream.asBroadcastStream();

    broadcastStream.listen(
      (List<int> event) {
        streamController.sink.add(event);
      },
    );

    return request.addStream(broadcastStream);
  }

  @override
  Future<HttpClientResponse> close() async {
    bool skipped = _flipperNetworkPlugin.filter != null &&
        !_flipperNetworkPlugin.filter(request);

    if (!skipped) {
      await this._reportRequest(uniqueId, request);
    }
    final response = await request.close();

    return skipped ? response : await withInterceptor(response);
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

  @override
  void abort([Object exception, StackTrace stackTrace]) =>
      request.abort(exception, stackTrace);

  Future<FlipperHttpClientResponse> withInterceptor(
      HttpClientResponse response) async {
    FlipperHttpClientResponse responseWithInterceptor =
        new FlipperHttpClientResponse(this.uniqueId, response);

    return responseWithInterceptor;
  }

  Future<bool> _reportRequest(
      String uniqueId, HttpClientRequest request) async {
    Map<String, dynamic> headers = new Map();
    request.headers.forEach((String name, List<String> values) {
      if (values != null && values.length > 0) {
        headers.putIfAbsent(
            name, () => values.length == 1 ? values[0] : values);
      }
    });

    var body;

    try {
      if (!streamController.isClosed) streamController.close();
      body = await Utf8Decoder(allowMalformed: false)
          .bind(streamController.stream)
          .join();
    } catch (e) {}

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
