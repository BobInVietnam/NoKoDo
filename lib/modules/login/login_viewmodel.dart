// lib/modules/login/login_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/utils/url_provider.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';

enum LoginState { checkingAutoLogin, idle, loading, success }

class LoginViewModel extends ChangeNotifier {
  final RepoManager repoManager;
  final NokodoSettings textSettings;
  final UsageTimeTracker usageTimeTracker;
  final UrlProvider _urlProvider = UrlProvider();

  LoginState _state = LoginState.checkingAutoLogin;
  String _displayMessage = '';

  LoginState get state => _state;
  String get displayMessage => _displayMessage;
  bool get isLoading => _state == LoginState.loading;
  bool get isCheckingAutoLogin => _state == LoginState.checkingAutoLogin;

  LoginViewModel({
    required this.repoManager,
    required this.textSettings,
    required this.usageTimeTracker,
  }) {
    checkAutoLogin();
  }

  Future<bool> checkAutoLogin() async {
    _state = LoginState.checkingAutoLogin;
    notifyListeners();

    try {
      final success = await repoManager.tryAutoLogin();
      if (success) {
        _state = LoginState.success;
        _onLoginSuccess();
        return true;
      } else {
        debugPrint("Auto login failed. Back to manual login.");
      }
    } catch (e) {
      debugPrint("Auto login error: $e");
    }

    _state = LoginState.idle;
    notifyListeners();
    return false;
  }

  Future<bool> submitLogin({
    required String email,
    required String password,
  }) async {
    _state = LoginState.loading;
    _displayMessage = '';
    notifyListeners();

    try {
      await repoManager.signIn(email: email, password: password);
      _onLoginSuccess();
      return true;
    } catch (e) {
      _displayMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('Exception', '');
      _state = LoginState.idle;
      notifyListeners();
      return false;
    }
  }

  bool loginAsOffline() {
    try {
      repoManager.signOut();
      _state = LoginState.idle;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Offline mode error: $e");
      return false;
    }
  }

  Future<String> saveUrl(String url) async {
    await _urlProvider.setUrl(url);
    return _urlProvider.url;
  }

  void _onLoginSuccess() {
    if (repoManager.currentStudent?.settings != null) {
      try {
        textSettings.updateFromMap(repoManager.currentStudent!.settings);
      } catch (e) {
        debugPrint("LOGIN: Personal settings sync failed: $e");
      }
    }

    usageTimeTracker.resumeWithUserData(repoManager.currentStudent?.totalTime ?? 0);
    notifyListeners();
  }

  void setState(LoginState state) {
    _state = state;
    notifyListeners();
  }
}