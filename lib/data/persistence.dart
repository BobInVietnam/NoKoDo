import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/converted_file.dart';

abstract class LocalDatabase extends ChangeNotifier{
  Future<void> test();
  Future<int> insertConvertedFile(ConvertedFile file);
  Future<List<ConvertedFile>> getAllConvertedFiles();
  Future<ConvertedFile?> getConvertedFileById(int id);
  Future<int> deleteConvertedFile(int id);
}

class TestLocalDatabase extends LocalDatabase {
  static final TestLocalDatabase _instance = TestLocalDatabase._internal();
  factory TestLocalDatabase() => _instance;
  TestLocalDatabase._internal();

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
              "name TEXT, "
              "content TEXT, "
              "created_date INTEGER)");
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
              "text TEXT, "
              "image_url TEXT)");
      await db.execute(
          "CREATE TABLE ConvertedFile ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name STRING, "
              "extracted_text TEXT, "
              "created_date INTEGER)");
    }
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

// 1. INSERT A CONVERTED FILE RECORD
  @override
  Future<int> insertConvertedFile(ConvertedFile file) async {
    final db = await database;
    // Inserts record and returns the auto-incremented primary key ID
    return await db.insert(
      'ConvertedFile',
      file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> test() async {
    final db = await database;
    debugPrint("DATABASE: Online!");
  }

  // 2. QUERY ALL CONVERTED FILES
  @override
  Future<List<ConvertedFile>> getAllConvertedFiles() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('ConvertedFile');

    return List.generate(maps.length, (i) {
      return ConvertedFile.fromMap(maps[i]);
    });
  }

  @override
  Future<ConvertedFile?> getConvertedFileById(int id) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'ConvertedFile',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Optimizes execution since IDs are unique
    );

    if (maps.isEmpty) return null;
    return ConvertedFile.fromMap(maps.first);
  }

  // 3. DELETE A CONVERTED FILE RECORD BY INT ID
  @override
  Future<int> deleteConvertedFile(int id) async {
    final db = await database;
    return await db.delete(
      'ConvertedFile',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}