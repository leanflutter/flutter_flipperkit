import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../flipper_client.dart';
import './flipper_network_plugin.dart';

class FlipperHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  FlipperNetworkPlugin? _flipperNetworkPlugin;

  final String uniqueId;
  final HttpClientResponse response;

  StreamController<List<int>> streamController = new StreamController();

  FlipperHttpClientResponse(this.uniqueId, this.response) {
    _flipperNetworkPlugin = FlipperClient.getDefault()
        .getPlugin(FlipperNetworkPlugin.ID) as FlipperNetworkPlugin;
  }

  @override
  X509Certificate? get certificate => response.certificate;

  @override
  HttpConnectionInfo? get connectionInfo => response.connectionInfo;

  @override
  int get contentLength => response.contentLength;

  @override
  HttpClientResponseCompressionState get compressionState =>
      response.compressionState;

  @override
  List<Cookie> get cookies => response.cookies;

  @override
  Future<Socket> detachSocket() {
    return response.detachSocket();
  }

  @override
  HttpHeaders get headers => response.headers;

  @override
  bool get isRedirect => response.isRedirect;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final _onData = (List<int> event) {
      onData!(event);

      streamController.sink.add(event);
    };

    final _onError = (error, StackTrace stackTrace) async {
      onError!(error, stackTrace);
    };

    final _onDone = () async {
      onDone!();

      await this._reportResponse(uniqueId);
    };

    return response.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: cancelOnError);
  }

  @override
  bool get persistentConnection => response.persistentConnection;

  @override
  String get reasonPhrase => response.reasonPhrase;

  @override
  Future<HttpClientResponse> redirect(
      [String? method, Uri? url, bool? followLoops]) {
    return response.redirect(method, url, followLoops);
  }

  @override
  List<RedirectInfo> get redirects => response.redirects;

  @override
  int get statusCode => response.statusCode;

  Future<bool> _reportResponse(String uniqueId) async {
    Map<String, dynamic> headers = new Map();
    response.headers.forEach((String name, List<String>? values) {
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

    ResponseInfo responseInfo = new ResponseInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      statusCode: response.statusCode,
      headers: headers,
      body: body,
    );

    _flipperNetworkPlugin?.reportResponse(responseInfo);
    return true;
  }
}
