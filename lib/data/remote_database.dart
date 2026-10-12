import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cross_file/cross_file.dart';
import 'package:nodyslexia/utils/url_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/converted_file.dart';
import '../models/test.dart';
import '../models/session.dart';
import '../models/trial_log.dart';
import '../models/event_log.dart';

abstract class RemoteDatabase {
  Future<bool> testConnection();
  Future<Map<String, Object?>?> getUser(String uid);
  Future<List<Map<String, Object?>>> getTestList(String uid);
  Future<Map<String, Object?>> getTestDetails(String testId, String studentId);
  Future<Map<String, Object?>> getCustomSettings(String uid, String lessonId);
  Future<void> sendCustomSettings(
    String uid,
    String lessonId,
    Map<String, Object?> settings,
  );
  Future<void> sendTestSessionStatus(TestSession testSession);
  Future<void> sendTestAnswers(Map<String, Object?> answersList);
  Future<void> sendUsageTime(int totalUsageTime, String uid);
  Future<void> sendSession(Session session);
  Future<void> sendUserSettings(String uid, Map<String, dynamic> settings);
  Future<void> sendPersonalLesson(String uid, ConvertedFile file);
  Future<void> sendTrialLog(TrialLog trial);
  Future<void> sendEventLog(EventLog event);
  Future<void> sendEventLogsBatch(List<EventLog> events);
  Future<Map<String, dynamic>?> sendAudioFile(
    XFile audioFile,
    String studentId, {
    String? trialId,
  });
  Future<void> sendHighlightList(String uid, List<String> highlightList);

  Future<Map<String, dynamic>> getStudentStatistics(String uid);
  Future<List<Map<String, Object?>>> getLessonList(String uid, String classId);
  Future<void> sendLessonResult(
    String studentId,
    String lessonId,
    Map<String, dynamic> results,
  );
  Future<Map<String, String>> getSystemConfig();
  Future<Map<String, dynamic>> getDictionaryData();
  Future<Map<String, Object?>?> studentLogin(String email, String password);
  void setToken(String? token);
  Future<Map<String, Object?>?> verifySession(String token);
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
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

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
  Future<List<Map<String, Object?>>> getLessonList(
    String uid,
    String classId,
  ) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('Lesson');
    return maps
        .map(
          (map) => {
            ...map,
            'dateCreated': map['created_date'],
            'isDone': false,
          },
        )
        .toList();
  }

  @override
  Future<List<Map<String, Object?>>> getTestList(String uid) async {
    final db = await database;

    debugPrint("TESTING: Querying database for TestInfo...");
    final List<Map<String, Object?>> maps = await db.rawQuery(
      '''
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
      [uid],
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
  Future<Map<String, Object?>> getTestDetails(
    String testId,
    String studentId,
  ) async {
    final db = await database;

    debugPrint("TESTING: Querying database for Test...");
    final List<Map<String, Object?>> maps = await db.rawQuery(
      '''
   SELECT * FROM test WHERE test.id = ?;
      ''',
      [testId],
    );
    debugPrint("TESTING: Map pulled : $maps");
    if (maps.isNotEmpty) {
      final Map<String, Object?> mutableMap = Map<String, Object?>.from(
        maps.first,
      );
      final List<Map<String, Object?>> attemptsList = await db.query(
        'student_test_status',
        where: 'testid = ? AND studentid = ?',
        whereArgs: [testId, studentId],
      );
      mutableMap['studentStatuses'] = attemptsList;
      return mutableMap;
    } else {
      debugPrint('TESTING: No test found.');
      return {}; //TODO: need to handle no test case (UNLIKELY exception)
    }
  }

  Future<Map<String, Object?>> getTestSessionId(TestSession testSession) async {
    final db = await database;

    debugPrint("TESTING: Querying database for TestSession...");
    final List<Map<String, Object?>> maps = await db.query(
      'student_test_status',
      where: 'studentid = ? AND date_created = ?',
      whereArgs: [testSession.studentId, testSession.startTime],
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
    final int sessionId = await db.insert('student_test_status', {
      'studentid': testSession.studentId,
      'testid': testSession.testId,
      'date_created': testSession.startTime,
      'date_finished': testSession.endTime,
      'duration': testSession.endTime - testSession.startTime,
      'result': testSession.score,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    debugPrint("TESTING: Test session posted.");
    return sessionId;
  }

  @override
  Future<void> sendTestAnswers(Map<String, Object?> answersList) async {
    final db = await database;

    debugPrint("TESTING: Posting test answers data...");
    for (var answer in (answersList["answers"] as List<Map<String, Object?>>)) {
      answer["date_created"] = answersList["startTime"];
      await db.insert(
        'Student_Answer',
        answer,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    debugPrint("TESTING: Test answers posted.");
  }

  @override
  Future<Map<String, dynamic>> getStudentStatistics(String uid) async {
    return {
      'uid': uid,
      'classid': 2,
      'testNumber': 3,
      'testFinishedNumber': 1,
      'averageTestScore': 8,
      'lessonNumber': 2,
      'lessonFinishedNumber': 1,
      'activityCounts': [0, 1, 0, 2, 0, 1, 3],
      'totalUsageTime': 45320,
    };
  }

  @override
  Future<bool> testConnection() async {
    try {
      final db = await database;
      return db.isOpen;
    } catch (e) {
      debugPrint("TESTING: DB errored. Cause: $e");
      return false;
    }
  }

  @override
  Future<void> sendUsageTime(int totalUsageTime, String uid) async {
    debugPrint(
      "TESTING: Mock sendUsageTime updating: $totalUsageTime seconds for $uid",
    );
  }

  @override
  Future<void> sendSession(Session session) async {
    debugPrint("TESTING: Mock sendSession saved: ${session.sessionId}");
  }

  @override
  Future<void> sendUserSettings(
    String uid,
    Map<String, dynamic> settings,
  ) async {
    debugPrint("TESTING: Mock sendUserSettings saved for $uid: $settings");
  }

  @override
  Future<void> sendTrialLog(TrialLog trial) async {
    debugPrint("TESTING: Mock sendTrialLog saved: ${trial.trialId}");
  }

  @override
  Future<void> sendEventLog(EventLog event) async {
    debugPrint("TESTING: Mock sendEventLog saved: ${event.eventId}");
  }

  @override
  Future<void> sendEventLogsBatch(List<EventLog> events) async {
    debugPrint(
      "TESTING: Mock sendEventLogsBatch saved (${events.length} events)",
    );
  }

  @override
  Future<void> sendLessonResult(
    String studentId,
    String lessonId,
    Map<String, dynamic> results,
  ) async {
    debugPrint(
      "TESTING: Mock sendLessonResult saved: $results for student $studentId and lesson $lessonId",
    );
  }

  @override
  Future<Map<String, String>> getSystemConfig() async {
    final db = await database;
    try {
      final List<Map<String, Object?>> maps = await db.query('system_config');
      return {
        for (final row in maps) row['key'] as String: row['value'] as String,
      };
    } catch (e) {
      debugPrint("TESTING: Error querying local mock config: $e");
      return {"dictVersion": "v1"};
    }
  }

  @override
  Future<Map<String, dynamic>> getDictionaryData() async {
    debugPrint("TESTING: Mock getDictionaryData returned empty.");
    return {"count": 0, "entries": []};
  }

  @override
  Future<Map<String, Object?>?> studentLogin(
    String email,
    String password,
  ) async {
    final db = await database;
    try {
      final List<Map<String, Object?>> maps = await db.query(
        'student',
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return maps.first;
      }
    } catch (e) {
      debugPrint("TESTING: Mock studentLogin error: $e");
    }
    return null;
  }

  @override
  void setToken(String? token) {}

  @override
  Future<Map<String, Object?>?> verifySession(String token) async {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> sendAudioFile(
    XFile audioFile,
    String studentId, {
    String? trialId,
  }) {
    // TODO: implement sendAudioFile
    throw UnimplementedError();
  }

  @override
  Future<void> sendPersonalLesson(String uid, ConvertedFile file) {
    // TODO: implement sendPersonalLesson
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> getCustomSettings(String uid, String lessonId) {
    // TODO: implement getCustomSettings
    throw UnimplementedError();
  }

  @override
  Future<void> sendCustomSettings(
    String uid,
    String lessonId,
    Map<String, Object?> settings,
  ) {
    // TODO: implement sendCustomSettings
    throw UnimplementedError();
  }

  @override
  Future<void> sendHighlightList(String uid, List<String> highlightList) {
    // TODO: implement sendHighlightList
    throw UnimplementedError();
  }
}

class LocalhostRemoteDatabase extends RemoteDatabase {
  String? _token;

  @override
  void setToken(String? token) {
    _token = token;
  }

  String get _baseUrl {
    return UrlProvider().url;
  }

  Future<http.Response> _get(Uri url) async {
    return http.get(
      url,
      headers: {if (_token != null) 'Authorization': 'Bearer $_token'},
    );
  }

  Future<http.Response> _post(Uri url, {Object? body}) async {
    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: body,
    );
  }

  @override
  Future<Map<String, dynamic>> getStudentStatistics(String uid) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/user/$uid/statistics');

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');

      // 1. Send the asynchronous network request
      final http.Response response = await _get(targetUrl);

      Map<String, dynamic> jsonContents;
      // 2. Evaluate the HTTP Status Code response boundary
      if (response.statusCode == 200) {
        // 3. Parse the raw text body payload into a structured Dart Map object
        jsonContents = jsonDecode(response.body) as Map<String, dynamic>;

        // 4. Log the target JSON value cleanly to your debug terminal console window
        debugPrint('HTTP SUCCESS: Connection established payload received!');
        debugPrint('JSON Content: $jsonContents');
        debugPrint('Extracted Key Value (hello): ${jsonContents['hello']}');
        return jsonContents;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>> getTestDetails(
    String testId,
    String studentId,
  ) async {
    // 1. Construct the target URL with path parameters and query arguments matching the API contract
    final Uri targetUrl = Uri.parse(
      '$_baseUrl/api/exam/$testId',
    ).replace(queryParameters: {'studentid': studentId});

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');

      // 2. Send the asynchronous network request
      final http.Response response = await _get(targetUrl);

      // 3. Evaluate the HTTP Status Code response boundary
      if (response.statusCode == 200) {
        // 4. Parse the raw text body payload into a structured Dart Map object safely
        final Map<String, Object?> jsonContents =
            jsonDecode(response.body) as Map<String, Object?>;

        debugPrint('HTTP SUCCESS: Connection established payload received!');
        debugPrint('JSON Content: $jsonContents');
        return jsonContents;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> getLessonList(
    String uid,
    String classId,
  ) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/lesson').replace(
      queryParameters: {'classid': classId.toString(), 'studentid': uid},
    );

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');
      final http.Response response = await _get(targetUrl);

      if (response.statusCode == 200) {
        final Map<String, Object?> jsonContents =
            jsonDecode(response.body) as Map<String, Object?>;

        final List<Map<String, Object?>> lessonList =
            List<Map<String, Object?>>.from(jsonContents["lessons"] as List);
        debugPrint(
          'HTTP SUCCESS: Connection established lessons payload received!',
        );
        debugPrint('JSON Content: $jsonContents');
        return lessonList;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> getTestList(String uid) async {
    final Uri targetUrl = Uri.parse(
      '$_baseUrl/api/exam',
    ).replace(queryParameters: {'studentid': uid});

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');

      // 2. Send the asynchronous network request
      final http.Response response = await _get(targetUrl);

      // 3. Evaluate the HTTP Status Code response boundary
      if (response.statusCode == 200) {
        // 4. Parse the raw text body payload into a structured Dart Map object safely
        final Map<String, Object?> jsonContents =
            jsonDecode(response.body) as Map<String, Object?>;

        final List<Map<String, Object?>> testList =
            List<Map<String, Object?>>.from(
              jsonContents["testInfoList"] as List,
            );
        debugPrint('HTTP SUCCESS: Connection established payload received!');
        debugPrint('JSON Content: $jsonContents');
        return testList;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>?> getUser(String uid) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/user/$uid');

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');

      final http.Response response = await _get(targetUrl);

      if (response.statusCode == 200) {
        final Map<String, Object?> jsonContents =
            jsonDecode(response.body) as Map<String, Object?>;
        debugPrint('HTTP SUCCESS: Connection established payload received!');
        debugPrint('JSON Content: $jsonContents');
        return jsonContents;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendTestAnswers(Map<String, Object?> answersList) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/exam/answers');
    debugPrint(answersList.toString());
    try {
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode(answersList),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HTTP SUCCESS: Test answers data synced successfully.');
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected session payload with status code: ${response.statusCode},  ${response.body}',
        );
        throw Exception(
          'Server rejected session payload with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit session status. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendTestSessionStatus(TestSession testSession) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/exam/${testSession.testId}');

    debugPrint(testSession.toString());
    try {
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({
          'testId': testSession.testId,
          'studentId': testSession.studentId,
          'startTime': testSession.startTime,
          'endTime': testSession.endTime,
          'score': testSession.score,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HTTP SUCCESS: Test session data synced successfully.');
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected session payload with status code: ${response.statusCode},  ${response.body}',
        );
        throw Exception(
          'Server rejected session payload with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit session status. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<bool> testConnection() async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/testapi');

    try {
      debugPrint('HTTP REQUEST: Initiating GET request to $targetUrl...');

      // 1. Send the asynchronous network request
      final http.Response response = await _get(targetUrl);

      // 2. Evaluate the HTTP Status Code response boundary
      if (response.statusCode == 200) {
        // 3. Parse the raw text body payload into a structured Dart Map object
        final Map<String, dynamic> jsonContents =
            jsonDecode(response.body) as Map<String, dynamic>;

        // 4. Log the target JSON value cleanly to your debug terminal console window
        debugPrint('HTTP SUCCESS: Connection established payload received!');
        debugPrint('JSON Content: $jsonContents');
        debugPrint('Extracted Key Value (hello): ${jsonContents['hello']}');
        return true;
      } else {
        debugPrint(
          'HTTP ERROR: Server responded with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to reach network endpoint. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendUsageTime(int totalUsageTime, String uid) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/user/$uid');

    try {
      debugPrint(
        'HTTP REQUEST: Syncing usage time ($totalUsageTime seconds) to $targetUrl...',
      );

      // Dispatch a POST network request to perform a partial update on the student record
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({
          'totalTime':
              totalUsageTime, // Matches the 'totalTime' schema keyword on your Prisma backend
        }),
      );
      // Evaluate the HTTP status codes
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        debugPrint(
          'HTTP SUCCESS: Active application usage time synced successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected time sync payload with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected time sync payload with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit usage time payload. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendSession(Session session) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/session');

    try {
      debugPrint(
        'HTTP REQUEST: Syncing session (${session.sessionId}) to $targetUrl...',
      );

      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode(session.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          'HTTP SUCCESS: Intervention session data synced successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected session sync payload with status code: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit session payload. Details: $error',
      );
    }
  }

  @override
  Future<void> sendUserSettings(
    String uid,
    Map<String, dynamic> settings,
  ) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/user/$uid');

    try {
      debugPrint('HTTP REQUEST: Syncing settings to $targetUrl...');

      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({'settings': settings}),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        debugPrint(
          'HTTP SUCCESS: Student personal settings synced online successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected settings payload with status code: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit settings payload. Details: $error',
      );
    }
  }

  @override
  Future<void> sendTrialLog(TrialLog trial) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/trial');
    try {
      debugPrint(
        'HTTP REQUEST: Syncing TrialLog (${trial.trialId}) to $targetUrl...',
      );
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode(trial.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HTTP SUCCESS: TrialLog synced online successfully.');
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected TrialLog: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit TrialLog payload. Details: $error',
      );
    }
  }

  @override
  Future<void> sendEventLog(EventLog event) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/event');
    try {
      debugPrint(
        'HTTP REQUEST: Syncing EventLog (${event.eventId}) to $targetUrl...',
      );
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode(event.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HTTP SUCCESS: EventLog synced online successfully.');
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected EventLog: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit EventLog payload. Details: $error',
      );
    }
  }

  @override
  Future<void> sendEventLogsBatch(List<EventLog> events) async {
    if (events.isEmpty) return;
    final Uri targetUrl = Uri.parse('$_baseUrl/api/event');
    try {
      debugPrint(
        'HTTP REQUEST: Syncing ${events.length} EventLogs batch to $targetUrl...',
      );
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode(events.map((e) => e.toMap()).toList()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          'HTTP SUCCESS: Batch of ${events.length} EventLogs synced online successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected EventLog batch: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to transmit EventLog batch payload. Details: $error',
      );
    }
  }

  @override
  Future<void> sendLessonResult(
    String studentId,
    String lessonId,
    Map<String, dynamic> results,
  ) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/lesson');

    try {
      debugPrint(
        'HTTP REQUEST: Syncing lesson result ($lessonId) to $targetUrl...',
      );

      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({
          'studentid': studentId,
          'lessonid': lessonId,
          'results': results,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HTTP SUCCESS: Student lesson result synced successfully.');
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected lesson result sync with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected lesson result sync with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to sync lesson result. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, String>> getSystemConfig() async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/config');
    try {
      final response = await _get(targetUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonContents = jsonDecode(response.body);
        return jsonContents.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      } else {
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("HTTP ERROR: Failed to get system config: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getDictionaryData() async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/dictionary');
    try {
      final response = await _get(targetUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("HTTP ERROR: Failed to get dictionary data: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>?> studentLogin(
    String email,
    String password,
  ) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/auth/student/login');
    try {
      debugPrint(
        'HTTP REQUEST: Initiating student login POST request to $targetUrl...',
      );
      final http.Response response = await http.post(
        targetUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonContents = jsonDecode(response.body);
        final Map<String, Object?>? student =
            jsonContents['student'] as Map<String, Object?>?;
        final String? token = jsonContents['token'] as String?;
        if (token != null) {
          setToken(token);
        }
        if (student != null) {
          final Map<String, Object?> studentWithToken = Map.from(student);
          studentWithToken['token'] = token;
          debugPrint('HTTP SUCCESS: Student logged in successfully!');
          return studentWithToken;
        }
        return student;
      } else {
        debugPrint(
          'HTTP ERROR: Login failed with code: ${response.statusCode}, ${response.body}',
        );
        final Map<String, dynamic> jsonContents = jsonDecode(response.body);
        throw Exception(jsonContents['error'] ?? 'Đăng nhập không thành công.');
      }
    } catch (error) {
      debugPrint('HTTP CRITICAL EXCEPTION: Login call failed. Details: $error');
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>?> verifySession(String token) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/auth/student/session');
    try {
      debugPrint(
        'HTTP REQUEST: Verifying student session GET request to $targetUrl...',
      );
      final http.Response response = await http.get(
        targetUrl,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonContents = jsonDecode(response.body);
        final Map<String, Object?>? student =
            jsonContents['student'] as Map<String, Object?>?;
        if (student != null) {
          setToken(token);
        }
        debugPrint('HTTP SUCCESS: Session token validated successfully!');
        return student;
      } else {
        debugPrint(
          'HTTP ERROR: Session validation failed with code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Session validation failed with code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Session verification call failed. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> sendAudioFile(
    XFile audioFile,
    String studentId, {
    String? trialId,
  }) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/audio');

    try {
      debugPrint(
        'HTTP REQUEST: Uploading audio file (${audioFile.name}) to $targetUrl...',
      );

      final request = http.MultipartRequest('POST', targetUrl);
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.fields['studentId'] = studentId;
      if (trialId != null) {
        request.fields['trialId'] = trialId;
      }

      final isWebm = audioFile.name.endsWith('.webm');
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          await audioFile.readAsBytes(),
          filename: audioFile.name,
          contentType: http.MediaType('audio', isWebm ? 'webm' : 'mp4'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonContents = jsonDecode(response.body);
        debugPrint(
          'HTTP SUCCESS: Audio file uploaded successfully: $jsonContents',
        );
        return jsonContents;
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected audio upload: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected audio upload with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to upload audio file. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendPersonalLesson(String uid, ConvertedFile file) {
    // TODO: implement sendPersonalLesson
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> getCustomSettings(
    String uid,
    String lessonId,
  ) async {
    final Uri targetUrl = Uri.parse(
      '$_baseUrl/api/customsettings',
    ).replace(queryParameters: {'studentid': uid, 'lessonid': lessonId});

    try {
      final http.Response response = await _get(targetUrl);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonContents =
            jsonDecode(response.body) as Map<String, dynamic>;

        // 4. Log the target JSON value cleanly to your debug terminal console window
        debugPrint('JSON Content: $jsonContents');
        debugPrint(
          'HTTP SUCCESS: Student lesson settings fetched successfully.',
        );
        return jsonContents;
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected lesson settings fetch with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected lesson settings fetch with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to get lesson settings. Details: $error. Returning to default settings.',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendCustomSettings(
    String uid,
    String lessonId,
    Map<String, Object?> settings,
  ) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/customsettings');

    try {
      debugPrint(
        'HTTP REQUEST: Syncing lesson ($lessonId) custom settings to $targetUrl...',
      );

      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({
          'studentid': uid,
          'lessonid': lessonId,
          'settings': settings,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          'HTTP SUCCESS: Student lesson settings synced successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected lesson settings sync with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected lesson settings sync with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to sync lesson result. Details: $error',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendHighlightList(String uid, List<String> highlightList) async {
    final Uri targetUrl = Uri.parse('$_baseUrl/api/user/$uid');

    try {
      debugPrint(
        'HTTP REQUEST: Syncing highlighted words to $targetUrl...',
      );

      // Dispatch a POST network request to perform a partial update on the student record
      final http.Response response = await _post(
        targetUrl,
        body: jsonEncode({
          'highlightedWords':
          highlightList, // Matches the 'totalTime' schema keyword on your Prisma backend
        }),
      );
      // Evaluate the HTTP status codes
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        debugPrint(
          'HTTP SUCCESS: Highlighted words synced successfully.',
        );
      } else {
        debugPrint(
          'HTTP ERROR: Server rejected highlight words payload with status code: ${response.statusCode}, ${response.body}',
        );
        throw Exception(
          'Server rejected highlight words payload with status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint(
        'HTTP CRITICAL EXCEPTION: Failed to sync highlight words payload. Details: $error',
      );
      rethrow;
    }
  }
}
