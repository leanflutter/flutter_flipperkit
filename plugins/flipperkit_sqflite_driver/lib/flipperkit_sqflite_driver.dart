library flipperkit_sqflite_driver;

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

class SqfliteDriverTableQueryer implements DatabaseDriverTableQueryer {
  Database _db;
  String _table;

  void setDatabase(Database db) {
    this._db = db;
  }

  void setTable(String table) {
    this._table = table;
  }

  @override
  Future<List<Map<String, dynamic>>> info() async {
    List<Map<String, dynamic>> tableInfo = await _db.rawQuery('PRAGMA table_info($_table)');

    _db.close();
    return tableInfo;
  }

  @override
  Future<List<Map<String, dynamic>>> count() async {
    List<Map<String, dynamic>> records = await _db.rawQuery('SELECT count(*) as count FROM $_table');

    _db.close();
    return records;
  }

  @override
  Future<List<Map<String, dynamic>>> get({ int limit = 20, int offset = 0}) async {
    String sqlString = 'SELECT * FROM $_table LIMIT $limit OFFSET $offset';
    print(sqlString);
    List<Map<String, dynamic>> records = await _db.rawQuery(sqlString);

    _db.close();
    return records;
  }
}

class SqfliteDriver implements DatabaseDriver {
  Database _db;
  SqfliteDriverTableQueryer _tableQueryer;

  final String name;

  SqfliteDriver(this.name);

  Future<Database> db() async {
    if (_db == null || !_db.isOpen) {
      String path = await getDatabasesPath();
      _db = null;
      _db = await openDatabase('$path/$name', singleInstance: false);
    }
    return _db;
  }

  @override
  Future<SqfliteDriverTableQueryer> table(String name) async{
      Database db = await this.db();
    if (_tableQueryer == null) {
      _tableQueryer = new SqfliteDriverTableQueryer();
    }
    _tableQueryer.setDatabase(db);
    _tableQueryer.setTable(name);
    return _tableQueryer;
  }

  @override
  Future<List<Map<String, dynamic>>> tables() async {
    Database db = await this.db();

    List<Map<String, dynamic>> records = await db.rawQuery('SELECT * FROM sqlite_master');

    _db.close();
    return records;
  }
}
