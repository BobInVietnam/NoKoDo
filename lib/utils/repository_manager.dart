import 'package:firebase_auth/firebase_auth.dart' hide Persistence;
import 'package:flutter/cupertino.dart';
import 'package:nodyslexia/models/student.dart';
import 'package:nodyslexia/utils/persistence_TEST.dart';

class RepoManager extends ChangeNotifier {
  // Get the instance of Firebase Auth.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Student? currentStudent;
  Persistence database = Persistence();

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
      currentStudent = await database.getUser(userCredential.user!.uid);
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


}