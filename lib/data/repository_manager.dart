import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nodyslexia/models/student.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/remote_database.dart';

class RepoManager extends ChangeNotifier {
  final RemoteDatabase onlineDatabase;
  final LocalDatabase database;
  final _secureStorage = const FlutterSecureStorage();

  Student? currentStudent;
  String? remoteDictVersion;

  // Constructor Injection: Pass the dependencies here
  RepoManager({
    required this.onlineDatabase,
    required this.database,
  });

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

      try {
        final configs = await onlineDatabase.getSystemConfig();
        remoteDictVersion = configs['dictVersion'];
        debugPrint("TESTING: Successfully loaded system config. remoteDictVersion: $remoteDictVersion");
      } catch (e) {
        debugPrint("TESTING: Failed to fetch system config during login: $e");
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Authentication Error: $e');
      rethrow;
    }
  }

  void signOut() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'last_active_time');
    onlineDatabase.setToken(null);
    currentStudent = null;
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

      try {
        final configs = await onlineDatabase.getSystemConfig();
        remoteDictVersion = configs['dictVersion'];
      } catch (e) {
        debugPrint("TESTING: Failed to fetch system config during auto-login: $e");
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("TESTING: Auto-login failed: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getRawStatistics() async {
    if (currentStudent == null) throw Exception("No student logged in.");

    debugPrint("Fetching statistics for student: ${currentStudent!.uid}");
    // Assuming onlineDatabase or local database handles the heavy query aggregation
    return await onlineDatabase.getStudentStatistics(currentStudent!.uid);
  }

  Future<List<TestInfo>> getTestList() async {
    debugPrint("TESTING: RepoMan getting data...${currentStudent?.uid} in ${currentStudent?.classid}");
    final List<Map<String, Object?>> testList = await onlineDatabase.getTestList(currentStudent!.uid);
    debugPrint("TESTING: RepoMan got data");
    return testList.map((map) => TestInfo.fromMap(map)).toList();
  }

  Future<List<Lesson>> getLessonList() async {
    if (currentStudent == null) throw Exception("No student logged in.");
    debugPrint("TESTING: RepoMan getting lesson list...${currentStudent?.uid} in ${currentStudent?.classid}");
    final List<Map<String, Object?>> lessonList = await onlineDatabase.getLessonList(currentStudent!.uid, currentStudent!.classid);
    debugPrint("TESTING: RepoMan got lesson list");
    return lessonList.map((map) => Lesson.fromMap(map)).toList();
  }

  Future<Test> getTestDetailsAndQuestions(int testId) async {
    debugPrint("TESTING: RepoMan getting test data...$testId");
    Map<String, Object?> test = await onlineDatabase.getTestDetails(testId, currentStudent!.uid);
    debugPrint("TESTING: RepoMan got test data");
    final List<Map<String, Object?>> questionsList =
      List<Map<String, Object?>>.from(test['questions'] as List);
    test['questions'] = questionsList.map((map) => Question.fromMap(map)).toList();
    return Test.fromMap(test);
  }

  Future<void> sendTestSessionStatus(TestSession testSession) async {
    debugPrint("TESTING: RepoMan sending test session data...");
    await onlineDatabase.sendTestSessionStatus(testSession);
  }

  Future<void> sendTestAnswers(TestSession testSession, Map<int, dynamic> answersList) async {
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
    debugPrint("TESTING: RepoMan sending usage time data...");
    await onlineDatabase.sendUsageTime(totalUsageTime, currentStudent!.uid);
  }

  Future<void> sendLessonResult(int lessonId, Map<String, dynamic> results) async {
    if (currentStudent == null) {
      debugPrint("TESTING: RepoMan cannot send lesson result: currentStudent is null.");
      return;
    }
    debugPrint("TESTING: RepoMan sending lesson result data...");
    await onlineDatabase.sendLessonResult(currentStudent!.uid, lessonId, results);
  }
}