import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = new Uuid();

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
                String identifier = uuid.v4();
                RequestInfo requestInfo = RequestInfo(
                  requestId: identifier,
                  timeStamp: new DateTime.now().millisecondsSinceEpoch,
                  // headers
                  method: 'POST',
                  uri: 'https://api.example.com/account/login',
                  // body,
                );
                ResponseInfo responseInfo =ResponseInfo(
                  requestId: identifier,
                  timeStamp: new DateTime.now().millisecondsSinceEpoch,
                  statusCode: 200,
                  body: new Map()
                    ..putIfAbsent("code", () => 0)
                    ..putIfAbsent("message", () => "login successful")
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
