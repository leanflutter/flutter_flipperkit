import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './networking/networking.dart';

void main() {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperNetworkPlugin());
  flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
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
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text("Preferences: setInt"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int counter = (prefs.getInt('counter') ?? 0) + 1;
                await prefs.setInt('counter', counter);
              },
            ),
            ListTile(
              title: Text("Network: GET"),
              onTap: () {
                sharedDioClient.http.get('https://www.v2ex.com/api/topics/hot.json');
              },
            ),
          ],
        ),
      ),
    );
  }
}
