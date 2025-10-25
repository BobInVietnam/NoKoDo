import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nodyslexia/models/student.dart';

class Persistence {
  static final Persistence _instance = Persistence._internal();
  factory Persistence() => _instance;
  Persistence._internal();

  Database? _database;

  static const String _dbFileName = 'test_db.db';
  static const String userStatsTable = 'user_stats';

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
      debugPrint("Error copying database from assets: $e");
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
      return Student(uid: userInfo['uid'] as String,
          firstname: userInfo['firstname'] as String,
          lastname: userInfo['lastname'] as String);
    } else {
      return null;
    }
  }
}
