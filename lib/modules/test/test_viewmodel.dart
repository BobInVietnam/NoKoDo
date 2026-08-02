import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/data/repository_manager.dart';

class TestViewModel extends ChangeNotifier {
  final Test test;
  final TestSession testSession;
  final RepoManager _repoManager;

  final PageController pageController = PageController();

  Timer? _uiTimer;
  int _remainingTime = -1;
  int _currentPage = 0;
  bool _isTrayExpanded = false;
  bool _isTimeOutDialogOpen = false;
  final Map<String, String?> _answers = {};
  final Map<int, TextEditingController> _textControllers = {};

  int get remainingTime => _remainingTime;
  int get currentPage => _currentPage;
  bool get isTrayExpanded => _isTrayExpanded;
  bool get isTimeOutDialogOpen => _isTimeOutDialogOpen;
  Map<String, String?> get answers => _answers;
  Map<int, TextEditingController> get textControllers => _textControllers;
  List<Question> get questions => test.questions;

  TestViewModel({
    required this.test,
    required this.testSession,
    required RepoManager repoManager,
  }) : _repoManager = repoManager {
    _remainingTime = test.timeLimit;
    for (int i = 0; i < questions.length; i++) {
      _answers[questions[i].id] = null;
      if (questions[i] is FillBlankQuestion) {
        _textControllers[i] = TextEditingController();
      }
    }
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingTime = remainingTime - 1;
      if (remainingTime <= 0) {
        _isTimeOutDialogOpen = true;
        _uiTimer?.cancel();
      }
      notifyListeners();
    });
  }

  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void registerAnswer(String questionId, String answer) {
    _answers[questionId] = answer;
    notifyListeners();

    if (_currentPage < questions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void jumpToPage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void toggleExpandTray() {
    _isTrayExpanded = !_isTrayExpanded;
    notifyListeners();
  }

  Future<void> submitTest() async {
    final double finalScore = Question.calculateScore(questions, _answers);
    final TestSession submitTestSession = TestSession(
      testId: testSession.testId,
      studentId: testSession.studentId,
      startTime: testSession.startTime,
      endTime: min(DateTime.now().millisecondsSinceEpoch,
          testSession.startTime + test.timeLimit * 1000),
      score: finalScore,
    );
    try {
      await _repoManager.sendTestSessionStatus(submitTestSession);
      await _repoManager.sendTestAnswers(testSession, _answers);
      debugPrint("Test submitted with answers: $_answers");
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    pageController.dispose();
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
