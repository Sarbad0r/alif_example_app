import 'dart:math';

import 'package:alif_flutter_app/models/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static final Future<Database> database = getDatabasesPath().then((value) {
    return openDatabase(
      join(value, 'data.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE data (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, url TEXT, startDate TEXT, "
            "endDate TEXT, name TEXT, email TEXT, icon TEXT, objType TEXT, loginRequired INTEGER)");
      },
      version: 1,
    );
  });

  static Future<void> saveDataToDb(List<Data> dataList) async {
    final db = await database;
    for (var each in dataList) {
      await db.insert("data", each.toJson());
    }
  }
}
