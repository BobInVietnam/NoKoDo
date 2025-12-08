import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nodyslexia/models/student.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/utils/persistence.dart';
import 'package:nodyslexia/utils/remote_database_TEST.dart';

class RepoManager extends ChangeNotifier {
  // Get the instance of Firebase Auth.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Student? currentStudent;
  RemoteDatabase onlineDatabase = RemoteDatabase();
  LocalDatabase database = LocalDatabase();

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
      database.doSomething();
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

  Future<List<TestInfo>> getTestList() async {
    await Future.delayed(const Duration(seconds: 2)); //TODO: remove in prod
    debugPrint("TESTING: RepoMan getting data...${currentStudent?.uid} in ${currentStudent?.classid}");
    final List<Map<String, Object?>> testList = await onlineDatabase.getTestList(currentStudent!.uid!);
    debugPrint("TESTING: RepoMan got data");
    return testList.map((map) => TestInfo.fromMap(map)).toList();
  }

  Future<Test> getTestDetailsAndQuestions(int testId) async {
    await Future.delayed(const Duration(seconds: 2)); //TODO: remove in prod
    debugPrint("TESTING: RepoMan getting test data...$testId");
    final Map<String, Object?> test = await onlineDatabase.getTestDetails(testId);
    debugPrint("TESTING: RepoMan got test data");
    final List<Map<String, Object?>> questionsList = await onlineDatabase.getTestQuestions(testId);
    debugPrint("TESTING: RepoMan got questions data");
    final mutableTest = Map<String, Object?>.from(test);
    mutableTest['questions'] = questionsList.map((map) => Question.fromMap(map)).toList();
    return Test.fromMap(mutableTest);
  }

  Future<int> sendTestSessionStatus(TestSession testSession) async {
    await Future.delayed(const Duration(seconds: 2)); //TODO: remove in prod
    debugPrint("TESTING: RepoMan sending test session data...");
    final int sessionId = await onlineDatabase.sendTestSessionStatus(testSession);
    return sessionId;
  }

  Future<void> updateTestSessionStatus(TestSession testSession) async {
    await Future.delayed(const Duration(seconds: 2)); //TODO: remove in prod
    debugPrint("TESTING: RepoMan sending test session data...");
    await onlineDatabase.updateTestSessionStatus(testSession);
  }

  Future<void> sendTestAnswers(TestSession testSession, Map<int, dynamic> answersList) async {
    await Future.delayed(const Duration(seconds: 2)); //TODO: remove in prod
    debugPrint("TESTING: RepoMan sending test answers data...");
    final List<Map<String, Object?>> answersMapList = [];
    for (final entry in answersList.entries) {
      final Map<String, Object?> answerMap = {
        'sessionid': testSession.id,
        'questionid': entry.key,
        'answer': entry.value
      };
      answersMapList.add(answerMap);
    }
    await onlineDatabase.sendTestAnswers(answersMapList);
  }
}