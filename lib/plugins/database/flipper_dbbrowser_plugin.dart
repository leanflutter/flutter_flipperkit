import 'dart:async';
import 'package:flutter/services.dart';
import '../../flipper_plugin.dart';

abstract class DatabaseDriverTableQueryer {
  Future<List<Map<String, dynamic>>> info();
  Future<List<Map<String, dynamic>>> count();
  Future<List<Map<String, dynamic>>> get({int limit, int offset});
}

abstract class DatabaseDriver {
  Future<List<Map<String, dynamic>>> tables();
  Future<DatabaseDriverTableQueryer> table(String name);
}

class FlipperDatabaseBrowserPlugin extends FlipperPlugin{
  static const MethodChannel _methodChannel = const MethodChannel('flutter_flipperkit'); 
  static const EventChannel _eventChannel = const EventChannel('flutter_flipperkit/event_channel');

  final DatabaseDriver driver;

  FlipperDatabaseBrowserPlugin(this.driver) {
    _eventChannel.receiveBroadcastStream().listen(_onEvent);
  }

  @override
  String getId() {
    return "DatabaseBrowser";
  }

  void _onEvent(Object event) {
    Map map = event;

    String eventType = '${map['action']}';
    String table = map['table'];

    switch (eventType) {
      case 'getTables':
        this.reportTables();
        break;
      case 'getTableInfo':
        this.reportTableInfo(table);
        break;
      case 'getTableCount':
        this.reportTableCount(table);
        break;
      case 'getTableRecordes':
        int limit = map['limit'];
        int offset = map['offset'];
        this.reportTableRecordes(table, limit: limit, offset: offset);
        break;
      default:
        break;
    }
  }

  void reportTables() async {
    List<Map<String, dynamic>> results = await driver.tables();

    await _methodChannel.invokeMethod('pluginDatabaseBrowserReportQueryResult', new Map()
      ..putIfAbsent("action", () => "getTables")
      ..putIfAbsent("table", () => null)
      ..putIfAbsent("results", () => results));
  }

  void reportTableInfo(String table) async {
    DatabaseDriverTableQueryer queryer = await driver.table(table);
    List<Map<String, dynamic>> results = await queryer.info();

    await _methodChannel.invokeMethod('pluginDatabaseBrowserReportQueryResult', new Map()
      ..putIfAbsent("action", () => "getTableInfo")
      ..putIfAbsent("table", () => table)
      ..putIfAbsent("results", () => results));
  }

  void reportTableCount(String table) async {
    DatabaseDriverTableQueryer queryer = await driver.table(table);
    List<Map<String, dynamic>> results = await queryer.count();

    await _methodChannel.invokeMethod('pluginDatabaseBrowserReportQueryResult', new Map()
      ..putIfAbsent("action", () => "getTableCount")
      ..putIfAbsent("table", () => table)
      ..putIfAbsent("results", () => results));
  }

  void reportTableRecordes(String table, {int limit = 20, int offset = 0}) async {
    DatabaseDriverTableQueryer queryer = await driver.table(table);
    List<Map<String, dynamic>> results = await queryer.get(limit: limit, offset: offset);

    await _methodChannel.invokeMethod('pluginDatabaseBrowserReportQueryResult', new Map()
      ..putIfAbsent("action", () => "getTableRecordes")
      ..putIfAbsent("table", () => table)
      ..putIfAbsent("results", () => results));
  }
}