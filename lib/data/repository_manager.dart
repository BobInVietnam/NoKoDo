import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nodyslexia/models/student.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/models/session.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/remote_database.dart';
import 'package:nodyslexia/utils/trial_logger.dart';

class RepoManager extends ChangeNotifier {
  final RemoteDatabase onlineDatabase;
  final LocalDatabase database;
  final _secureStorage = const FlutterSecureStorage();

  late final TrialLogger trialLogger = TrialLogger(this);

  Student? currentStudent;
  Session? currentSession;
  String? remoteDictVersion;
  String appVersion = "undefined";
  String webVersion = "undefined";

  // Constructor Injection: Pass the dependencies here
  RepoManager({
    required this.onlineDatabase,
    required this.database,
  });

  Future<Session?> createSession({
    String? examinerId,
    String? siteId,
    required double screenWidth,
    required double screenHeight,
  }) async {
    if (currentStudent == null) return null;

    final now = DateTime.now();
    final dateStr = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";

    final String formattedSid = currentStudent!.sid.toString().padLeft(4, '0');
    final String sessionId = "S${formattedSid}_$dateStr";

    final String deviceOs = kIsWeb ? 'web' : Platform.operatingSystem;

    currentSession = Session(
      studentId: currentStudent!.uid,
      sessionId: sessionId,
      sessionStartTime: now,
      examinerId: (examinerId != null && examinerId.trim().isNotEmpty) ? examinerId.trim() : null,
      siteId: (siteId != null && siteId.trim().isNotEmpty) ? siteId.trim() : null,
      device: deviceOs,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      appVersion: appVersion,
      webVersion: webVersion,
      completed: false,
    );

    debugPrint("SESSION: Created session ${currentSession!.sessionId}");
    await database.saveSession(currentSession!);
    try {
      await onlineDatabase.sendSession(currentSession!);
    } catch (e) {
      debugPrint("SESSION: Online sync failed: $e");
    }
    notifyListeners();
    return currentSession;
  }

  Future<void> completeCurrentSession() async {
    if (currentSession != null && !currentSession!.completed) {
      currentSession!.sessionEndTime = DateTime.now();
      currentSession!.completed = true;
      debugPrint("SESSION: Completed session ${currentSession!.sessionId} at ${currentSession!.sessionEndTime}");
      await database.saveSession(currentSession!);
      try {
        await onlineDatabase.sendSession(currentSession!);
      } catch (e) {
        debugPrint("SESSION: Online completion sync failed: $e");
      }
      notifyListeners();
    }
  }

  Future<void> saveStudentSettings(Map<String, dynamic> settingsMap) async {
    if (currentStudent == null) return;
    currentStudent!.settings = settingsMap;
    try {
      await onlineDatabase.sendUserSettings(currentStudent!.uid, settingsMap);
      debugPrint("SETTINGS: Online settings synced successfully for ${currentStudent!.uid}");
    } catch (e) {
      debugPrint("SETTINGS: Failed to sync settings online: $e");
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, Object?>? currentUserMap = await onlineDatabase.studentLogin(
        email,
        password,
      );

      if (currentUserMap == null) {
        throw Exception("Email hoặc mật khẩu không chính xác.");
      }

      final String? token = currentUserMap['token'] as String?;
      if (token != null) {
        await _secureStorage.write(key: 'jwt_token', value: token);
        await _secureStorage.write(
          key: 'last_active_time',
          value: DateTime.now().millisecondsSinceEpoch.toString(),
        );
      }

      currentStudent = Student.fromMap(currentUserMap);

      getSystemConfig();

      notifyListeners();
    } catch (e) {
      debugPrint('Authentication Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    completeCurrentSession();
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'last_active_time');
    onlineDatabase.setToken(null);
    currentStudent = null;
    currentSession = null;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final lastActiveStr = await _secureStorage.read(key: 'last_active_time');

      if (token == null || lastActiveStr == null) {
        return false;
      }

      final lastActive = int.tryParse(lastActiveStr);
      if (lastActive == null) {
        return false;
      }

      final difference = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastActive));
      // Inactivity timeout: 24 hours
      if (difference.inHours >= 24) {
        debugPrint("TESTING: Session expired due to inactivity.");
        await _secureStorage.delete(key: 'jwt_token');
        await _secureStorage.delete(key: 'last_active_time');
        return false;
      }

      // Verify token with backend
      final Map<String, Object?>? studentMap = await onlineDatabase.verifySession(token);
      if (studentMap == null) {
        debugPrint("TESTING: Invalid token on backend session check.");
        await _secureStorage.delete(key: 'jwt_token');
        await _secureStorage.delete(key: 'last_active_time');
        return false;
      }

      // Update session last active time
      await _secureStorage.write(
        key: 'last_active_time',
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      currentStudent = Student.fromMap(studentMap);
      if (token == null || lastActiveStr == null) return false;

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastActive > 24 * 60 * 60 * 1000) {
        signOut();
        return false;
      }

      onlineDatabase.setToken(token);
      final profile = await onlineDatabase.verifySession(token);
      if (profile != null) {
        currentStudent = Student.fromMap(profile);
        await _secureStorage.write(key: 'last_active_time', value: now.toString());
        getSystemConfig();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("TESTING: Auto-login failed: $e");
      return false;
    }
  }

  Future<void> getSystemConfig() async {
    if (currentStudent == null) throw Exception("No student logged in.");
    
    try {
      final configs = await onlineDatabase.getSystemConfig();
      remoteDictVersion = configs['dictVersion'];
      appVersion = configs['appVersion']!;
      webVersion = configs['webVersion']!;
      debugPrint("TESTING: Successfully loaded system config. "
          "remoteDictVersion: $remoteDictVersion, appVersion: $appVersion, webVersion: $webVersion");
    } catch (e) {
      debugPrint("TESTING: Failed to fetch system config: $e");
    }
  }

  Future<Map<String, dynamic>> getRawStatistics() async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("Fetching statistics for student: ${currentStudent!.uid}");
    try {
      final stats = await onlineDatabase.getStudentStatistics(currentStudent!.uid);
      saveRawStatistics(stats);
      return stats;
    } catch (e) {
      debugPrint("Offline: Fetching statistics from local database...: $e");
      final cached = await database.getConfig('statistics_${currentStudent!.uid}');
      if (cached != null) {
        return jsonDecode(cached) as Map<String, dynamic>;
      }
      throw Exception("Không có kết nối mạng và không có dữ liệu thống kê ngoại tuyến.");
    }
  }

  Future<void> saveRawStatistics(Map<String, dynamic> stats) async {
    await database.setConfig('statistics_${currentStudent!.uid}', jsonEncode(stats));
  }

  Future<List<TestInfo>> getTestList() async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("TESTING: RepoMan getting data...${currentStudent?.uid} in ${currentStudent?.classid}");
    final List<Map<String, Object?>> testList = await onlineDatabase.getTestList(currentStudent!.uid);
    debugPrint("TESTING: RepoMan got data");
    return testList.map((map) => TestInfo.fromMap(map)).toList();
  }

  Future<List<Lesson>> getLessonList() async {

    debugPrint("TESTING: RepoMan getting lesson list...${currentStudent?.uid} in ${currentStudent?.classid}");
    try {
      if (currentStudent == null) throw Exception("No student logged in.");
      final List<Map<String, Object?>> lessonList = await onlineDatabase.getLessonList(currentStudent!.uid, currentStudent!.classid);
      final lessons = lessonList.map((map) => Lesson.fromMap(map)).toList();
      await database.saveLessons(lessons);
      return lessons;
    } catch (e) {
      debugPrint("Offline: Fetching lessons from local database...: $e");
      final localLessons = await database.getAllLessons();
      if (localLessons.isNotEmpty) {
        return localLessons;
      }
      throw Exception("Không có kết nối mạng và không có dữ liệu bài học ngoại tuyến.");
    }
  }

  Future<Test> getTestDetailsAndQuestions(String testId) async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("TESTING: RepoMan getting test data...$testId");
    Map<String, Object?> test = await onlineDatabase.getTestDetails(testId, currentStudent!.uid);
    debugPrint("TESTING: RepoMan got test data");
    final List<Map<String, Object?>> questionsList =
      List<Map<String, Object?>>.from(test['questions'] as List);
    test['questions'] = questionsList.map((map) => Question.fromMap(map)).toList();
    return Test.fromMap(test);
  }

  Future<void> sendTestSessionStatus(TestSession testSession) async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("TESTING: RepoMan sending test session data...");
    await onlineDatabase.sendTestSessionStatus(testSession);
  }

  Future<void> sendTestAnswers(TestSession testSession, Map<String, dynamic> answersList) async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("TESTING: RepoMan sending test answers data...");
    Map<String, Object?> answersMapList = <String, Object?>{
      'studentId': testSession.studentId,
      'testId': testSession.testId,
      'startTime': testSession.startTime,
      'answers': []
    };
    for (final entry in answersList.entries) {
      final Map<String, Object?> answerMap = {
        'questionId': entry.key,
        'answer': entry.value
      };
      (answersMapList['answers'] as List).add(answerMap);
    }
    await onlineDatabase.sendTestAnswers(answersMapList);
  }

  Future<void> sendUsageTime(int totalUsageTime) async {
    if (currentStudent == null) return;
    debugPrint("TESTING: RepoMan sending usage time data...");
    final cached = await database.getConfig('statistics_${currentStudent!.uid}');
    if (cached != null) {
      var stats = jsonDecode(cached) as Map<String, dynamic>;
      stats['totalUsageTime'] = totalUsageTime;
      await saveRawStatistics(stats);
      debugPrint("TESTING: RepoMan saved usage time to cache");
    }

    await onlineDatabase.sendUsageTime(totalUsageTime, currentStudent!.uid);
  }

  Future<void> sendLessonResult(String lessonId, Map<String, dynamic> results) async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("TESTING: RepoMan sending lesson result data...");
    await onlineDatabase.sendLessonResult(currentStudent!.uid, lessonId, results);
  }
}