import 'dart:io';
import './flipper_http_client.dart';

class FlipperHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    return new FlipperHttpClient(client);
  }
}