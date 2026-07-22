import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nodyslexia/models/student.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/remote_database.dart';

class RepoManager extends ChangeNotifier {
  // Get the instance of Firebase Auth.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RemoteDatabase onlineDatabase;
  final LocalDatabase database;

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
    // Since the authentication process takes time, we wait for its completion using await.
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If sign-in is successful, return the user object obtained from Firebase.
      print('Sign-in successful! User: ${userCredential.user!.email}');
      final Map<String, Object?>? currentUserMap = await onlineDatabase.getUser(userCredential.user!.uid);
      currentStudent = Student.fromMap(currentUserMap!);

      try {
        final configs = await onlineDatabase.getSystemConfig();
        remoteDictVersion = configs['dictVersion'];
        debugPrint("TESTING: Successfully loaded system config. remoteDictVersion: $remoteDictVersion");
      } catch (e) {
        debugPrint("TESTING: Failed to fetch system config during login: $e");
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors.
      String errorMessage;

      // Set a user-friendly error message based on the error code (e.code).
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address format is invalid.';
          break;
        case 'missing-password':
        case 'invalid-credential':
        case 'wrong-password':
          errorMessage = 'The email address or password is incorrect.';
          break;
        default:
          errorMessage = 'An unexpected error occurred during authentication.';
      }

      // Print the Firebase authentication error to the debug console.
      debugPrint('Firebase Auth Error [${e.code}]: $errorMessage');
      rethrow;
    } catch (e) {
      // Handle other unexpected errors, such as network issues.
      debugPrint('An unexpected error occurred: $e');
      rethrow;
    }
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    currentStudent = null;
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