import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/test.dart';

abstract class RemoteDatabase {
  Future<Map<String, Object?>?> getUser(String uid);
  Future<List<Map<String, Object?>>> getTestList(String uid);
  Future<Map<String, Object?>> getTestDetails(int testId);
  Future<List<Map<String, Object?>>> getTestQuestions(int testId);
  Future<int> sendTestSessionStatus(TestSession testSession);
  Future<void> updateTestSessionStatus(TestSession testSession);
  Future<void> sendTestAnswers(List<Map<String, Object?>> answersList);

  Future<Future<Map<String, dynamic>>> getStudentStatistics(String uid);
}

class TestRemoteDatabase extends RemoteDatabase {
  static final TestRemoteDatabase _instance = TestRemoteDatabase._internal();
  factory TestRemoteDatabase() => _instance;
  TestRemoteDatabase._internal();

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

  @override
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

  @override
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
      student S
  -- 1. Link Student to Class and Class to Tests (The "Master List")
  JOIN class_test CT ON S.classid = CT.classid
  JOIN test T ON CT.testid = T.id
  
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

  @override
  Future<Map<String, Object?>> getTestDetails(int testId) async {
    final db = await database;

    debugPrint("TESTING: Querying database for Test...");
    final List<Map<String, Object?>> maps = await db.rawQuery('''
   SELECT * FROM test WHERE test.id = ?;
      ''',
        [testId]
    );
    debugPrint("TESTING: Map pulled : $maps");
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      debugPrint('TESTING: No test found.');
      return {}; //TODO: need to handle no test case (UNLIKELY exception)
    }
  }

  @override
  Future<List<Map<String, Object?>>> getTestQuestions(int testId) async {
    final db = await database;

    debugPrint("TESTING: Querying database for Questions...");
    final List<Map<String, Object?>> maps = await db.rawQuery('''
  SELECT 
    id,
    question,
    answer,
    is_multiple_choice,
    choices
  FROM question WHERE question.testid = ?;
    ''',
      [testId]
    );
    debugPrint("TESTING: Map pulled : $maps");
    if (maps.isNotEmpty) {
      return maps;
    } else {
      debugPrint('TESTING: No question in test???');
      return []; //TODO: deal with this too (UNLIKELY exception)
    }
  }

  Future<Map<String, Object?>> getTestSessionId(TestSession testSession) async {
    final db = await database;

    debugPrint("TESTING: Querying database for TestSession...");
    final List<Map<String, Object?>> maps = await db.query(
      'student_test_status',
      where: 'studentid = ? AND date_created = ?',
      whereArgs: [testSession.studentId, testSession.startTime]
    );
    debugPrint("TESTING: Map pulled : $maps");
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      debugPrint('TESTING: No test session found.');
      return {}; //TODO: need to handle no test session case (UNLIKELY exception)
    }
  }

  @override
  Future<int> sendTestSessionStatus(TestSession testSession) async {
    final db = await database;

    debugPrint("TESTING: Posting test session data...");
    final int sessionId = await db.insert('student_test_status',
        {
          'studentid': testSession.studentId,
          'testid': testSession.testId,
          'date_created': testSession.startTime
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    debugPrint("TESTING: Test session posted.");
    return sessionId;
  }

  @override
  Future<void> updateTestSessionStatus(TestSession testSession) async {
    final db = await database;

    debugPrint("TESTING: Posting test session data...");
    await db.update('student_test_status',
        {
          'date_finished': testSession.endTime,
          'duration': testSession.endTime - testSession.startTime,
          'result': testSession.score
        },
        where: 'sessionid = ?',
        whereArgs: [testSession.id]);
    debugPrint("TESTING: Test session posted.");
  }

  @override
  Future<void> sendTestAnswers(List<Map<String, Object?>> answersList) async {
    final db = await database;

    debugPrint("TESTING: Posting test answers data...");
    for (final answer in answersList) {
      await db.insert('Student_Answer', answer,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    debugPrint("TESTING: Test answers posted.");
  }

  @override
  Future<Future<Map<String, dynamic>>> getStudentStatistics(String uid) {
    // TODO: implement getStudentStatistics
    throw UnimplementedError();
  }
}
