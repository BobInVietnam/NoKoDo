import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nodyslexia/models/student.dart';

import '../models/test.dart';

class RemoteDatabase {
  static final RemoteDatabase _instance = RemoteDatabase._internal();
  factory RemoteDatabase() => _instance;
  RemoteDatabase._internal();

  Database? _database;

  static const String _dbFileName = 'test_db.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  /// 1. Initializes the database connection.
  /// This checks for a bundled asset database and copies it if necessary.
  Future<Database> _initDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbFileName);

    // --- MODIFICATION FOR TESTING ---
    // Always delete the database if it exists to force a fresh copy.
    // Use sqflite's `deleteDatabase` helper.
    if (await databaseExists(path)) {
      debugPrint("TESTING: Existing database found. Deleting...");
      await deleteDatabase(path);
    }
    // --- END MODIFICATION ---

    // This part now runs every time on first init
    debugPrint("TESTING: Copying fresh database from assets...");
    try {
      await Directory(dirname(path)).create(recursive: true);

      ByteData data = await rootBundle.load(join("assets", _dbFileName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      debugPrint("TESTING: Fresh database copied successfully.");
    } catch (e) {
      debugPrint("TESTING: Error copying database from assets: $e");
      throw Exception("Failed to copy bundled database. Error: $e");
    }

    // Open the brand new database
    return await openDatabase(path);
  }

  Future<Student?> getUser(String uid) async {
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(
      'student',
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final userInfo = maps.first;
      return Student.fromMap(userInfo);
    } else {
      debugPrint('TESTING: No user found');
      return null;
    }
  }

  Future<List<TestInfo>> getTestList(String uid, int classid) async {
    final db = await database;

    final List<Map<String, Object?>> maps = await db.rawQuery(
      'SELECT Test.id, Test.name, Test.date_created, Test.time_limit, Test.allowed_attempts, Test.difficulty,  '
      'FROM Test '
      'INNER JOIN Class_Test ON Class_Test.testid = Test.id '
      'WHERE Class_Test.classid = ?',
      [classid]
    );
    if (maps.isNotEmpty) {
      return maps.map((map) => TestInfo.fromMap(map)).toList();
    } else {
      debugPrint('TESTING: No test in class found.');
      return [];
    }
  }
}
