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

  Future<Map<String, Object?>?> getUser(String uid) async {
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(
      'student',
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final userInfo = maps.first;
      return userInfo;
    } else {
      debugPrint('TESTING: No user found');
      return null;
    }
  }

  Future<List<Map<String, Object?>>> getTestList(String uid) async {
    final db = await database;

    debugPrint("TESTING: Querying database for TestInfo...");
    final List<Map<String, Object?>> maps = await db.rawQuery('''
SELECT 
      T.id, 
      T.name, 
      T.date_created, 
      T.time_limit,
      T.allowed_attempts, 
      T.difficulty,
      -- 4. Get the best score from the attached sessions
      MAX(SessionStats.result) as result, 
      -- 5. Count how many sessions exist (ignores NULLs automatically)
      COUNT(SessionStats.sessionid) as attempts
  FROM 
      Student S
  -- 1. Link Student to Class and Class to Tests (The "Master List")
  JOIN Class_Test CT ON S.classid = CT.classid
  JOIN Test T ON CT.testid = T.id
  
  -- 2. Create a subquery that calculates the score for every session
  LEFT JOIN Student_Test_Status SessionStats 
  -- 3. Attach the scores to the tests (Matching Student AND Test)
  ON T.id = SessionStats.testid AND S.uid = SessionStats.studentid
  
  WHERE S.uid = ?
  GROUP BY T.id;
  ''',
      [uid]
    );
    debugPrint("TESTING: Map pulled : $maps");
    if (maps.isNotEmpty) {
      return maps;
    } else {
      debugPrint('TESTING: No test in class found.');
      return [];
    }
  }
}

// select *, max(sum_correct) as result, count() as attempts from (
// select T.id as id, T.name as name,
// T.date_created as date_created, T.time_limit as time_limit,
// T.allowed_attempts as allowed_attempts, T.difficulty as difficulty,
// sum(SA.is_correct) as sum_correct
// from Student S
// join Class_Test CT on S.classid = CT.classid
// join Test T on CT.testid = T.id
// left join Student_Test_Status STS on STS.testid = T.id and S.uid = STS.studentid
// left join Student_Answer SA on SA.sessionid = STS.sessionid
// where S.uid = "ZgDTxfh7uWgYIdxcX0zEK2acvuD2"
// group by STS.sessionid)
// group by id;