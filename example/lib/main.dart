import 'package:flutter/material.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  flipperClient.start();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void _testNetwork() {
    FlipperNetworkPlugin flipperNetworkPlugin = 
      FlipperClient.getDefault().getPlugin("Network");

    String uniqueId = new Uuid().v4();
    RequestInfo requestInfo = new RequestInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: 'https://example.com/account/login',
      headers: new Map()
        ..putIfAbsent("Content-Type", () => "application/json"),
      method: 'POST',
      body: new Map()
        ..putIfAbsent("username", () => "example")
        ..putIfAbsent("password", () => "123456"),
    );

    flipperNetworkPlugin.reportRequest(requestInfo);

    ResponseInfo responseInfo = new ResponseInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      statusCode: 200,
      headers: new Map()
        ..putIfAbsent("Content-Type", () => "application/json"),
      body: new Map()
        ..putIfAbsent("username", () => "lijy91")
        ..putIfAbsent("age", () => 28)
        ..putIfAbsent("name", () => "JianyingLi"),
    );

    flipperNetworkPlugin.reportResponse(responseInfo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text("Preferences"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int counter = (prefs.getInt('counter') ?? 0) + 1;
                await prefs.setInt('counter', counter);
              },
            ),
            ListTile(
              title: Text("Network"),
              onTap: this._testNetwork,
            ),
            ListTile(
              title: Text("ReduxInspector"),
              onTap: () {
                FlipperReduxInspectorPlugin flipperReduxInspectorPlugin = 
                  FlipperClient.getDefault().getPlugin("ReduxInspector");

                ActionInfo actionInfo = ActionInfo(
                  uniqueId: new Uuid().v4(),
                  actionType: 'LoginSuccess',
                  timeStamp: new DateTime.now().millisecondsSinceEpoch,
                  state: new Map()
                    ..putIfAbsent("user", () => { "name": "JianyingLi"})
                );
                flipperReduxInspectorPlugin.report(actionInfo);
              },
            ),
          ],
        ),
      ),
    );
  }
}
