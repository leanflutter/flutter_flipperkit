import 'package:dio/dio.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import './flipper_dio_interceptor.dart';
import './_topics.dart';

class ApiClient {
  static ApiClient shared = new ApiClient();

  Dio _http;
  FlipperNetworkPlugin _flipperNetworkPlugin;

  TopicsService     _topicsService;

  ApiClient() {
    _flipperNetworkPlugin = FlipperClient
      .getDefault().getPlugin(FlipperNetworkPlugin.ID);

    BaseOptions options = new BaseOptions(
      baseUrl: 'https://www.v2ex.com/api',
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      responseType: ResponseType.json,
    );
    this._http = new Dio(options);
    this._http.interceptors.add(FlipperDioInterceptor());

    this._topicsService = new TopicsService(_http);
  }

  TopicsService get topics => _topicsService;
}
