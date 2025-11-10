import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase{
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  Database? _database;
  static const String _dbFileName = 'userdata.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb(true);
    return _database!;
  }

  Future<Database> _initDb(bool overwrite) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbFileName);

    if (await databaseExists(path)) {
      if (overwrite) {
        await deleteDatabase(path);
      }
    }
    onCreate(Database db, int version) async {
      debugPrint("DATABASE: Loading database...");
      await db.execute('PRAGMA foreign_keys = ON');
      await db.execute(
          "CREATE TABLE Lesson ("
              "id INTEGER PRIMARY KEY, "
              "name TEXT)");
              // "create_date INTEGER, "); // millis since epoch
      await db.execute(
          "CREATE TABLE Content ("
              "id INTEGER PRIMARY KEY, "
              "text_content TEXT, "
              "question TEXT,"
              "answer TEXT,"
              "lesson_id INTEGER,"
              "FOREIGN KEY(lesson_id) REFERENCES Lesson(id))");
      await db.execute(
          "CREATE TABLE Dictionary ("
              "id INTEGER PRIMARY KEY, "
              "word TEXT, "
              "text TEXT,"
              "image_url TEXT)");
      await db.execute(
          "CREATE TABLE ConvertedText ("
              "id INTEGER PRIMARY KEY, "
              "word TEXT, "
              "file_url TEXT)");
    }
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<void> doSomething() async {
    final db = await database;

    db.insert("Lesson", {'id': 123, 'name': 'Test'});
  }
}