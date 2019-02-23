import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.start();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: <Widget>[
            FlatButton(
              child: Text("POST"),
              onPressed: () {
                Random random = new Random();
                String identifier = '${random.nextInt(9999)}';
                RequestInfo requestInfo = RequestInfo(
                  requestId: identifier,
                  timeStamp: new DateTime.now().millisecondsSinceEpoch,
                  headers: new Map()
                    ..putIfAbsent("Content-Type", () => "application/json"),
                  method: 'POST',
                  uri: 'https://api.example.com/account/login',
                  // body: new Map()
                  //   ..putIfAbsent("username", () => 'lijy91')
                  //   ..putIfAbsent("password", () => "qDrTBZk8jgbA"),
                  body: 'Hello world!',
                );

                ResponseInfo responseInfo = ResponseInfo(
                  requestId: identifier,
                  timeStamp: new DateTime.now().millisecondsSinceEpoch,
                  statusCode: 200,
                  headers: new Map()
                    ..putIfAbsent("Server", () => "Apache/2.4.1 (Unix)")
                    ..putIfAbsent("Content-Type", () => "application/json"),
                  body: new Map()
                    ..putIfAbsent("code", () => 0)
                    ..putIfAbsent("message", () => "login successful"),
                  // body: 'Hello world!',
                );

                FlipperNetworkPlugin flipperNetworkPlugin = FlipperClient.getDefault()
                  .getPlugin(FlipperNetworkPlugin.ID);

                flipperNetworkPlugin.reportRequest(requestInfo);
                flipperNetworkPlugin.reportResponse(responseInfo);
              },
            )
          ],
        ),
      ),
    );
  }
}
