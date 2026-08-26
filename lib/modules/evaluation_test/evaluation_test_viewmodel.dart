import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';

import 'package:nodyslexia/data/repository_manager.dart';

enum EvalTestState {
  START,
  IN_PROGRESS,
  END,
}

class EvaluationTestViewModel extends ChangeNotifier {
  final RepoManager? repoManager;

  List<Map<String, dynamic>> _evaluationTestList = [];
  int _currentIndex = 0;
  int _currentRepeat = 0;
  Map<String, dynamic>? _currentQuestion;

  int currentType = 0;
  String currentTarget = "";
  List<Map<String, dynamic>> displayAnswerList = [];
  List<Map<String, dynamic>> results = [];
  EvalTestState currentState = EvalTestState.START;

  // Error feedback & timing for Type 0
  String? errorMessage;
  int _wrongAttemptsCount = 0;
  final Stopwatch _stopwatch = Stopwatch();

  EvaluationTestViewModel({this.repoManager}) {
    _loadTestContents();
  }

  Future<void> _loadTestContents() async {
    try {
      final jsonString = await rootBundle.loadString("assets/eval_test_contents.json");
      final List<dynamic> rawList = jsonDecode(jsonString);
      _evaluationTestList = rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading eval_test_contents.json: $e");
    }
  }

  void startTest() {
    if (_evaluationTestList.isEmpty) return;
    results.clear();
    _currentIndex = 0;
    _currentRepeat = 0;
    errorMessage = null;
    _wrongAttemptsCount = 0;
    currentState = EvalTestState.IN_PROGRESS;

    repoManager?.trialLogger.startTrial(
      trialType: 'EVALUATION_TEST',
      trialCode: 'e',
      trialName: 'Evaluation Test'
    );

    _setupQuestion();
  }

  void resetTest() {
    currentState = EvalTestState.START;
    results.clear();
    _currentIndex = 0;
    _currentRepeat = 0;
    errorMessage = null;
    _wrongAttemptsCount = 0;
    notifyListeners();
  }

  void _setupQuestion() {
    if (_currentIndex >= _evaluationTestList.length) {
      _finishTest();
      return;
    }

    _currentQuestion = _evaluationTestList[_currentIndex];
    currentType = _currentQuestion!["type"] ?? 0;
    currentTarget = _currentQuestion!["target"] ?? "";
    errorMessage = null;
    _wrongAttemptsCount = 0;

    _loadAnswerList();

    if (currentType == 0) {
      _stopwatch.reset();
      _stopwatch.start();
    }
  }

  void _loadAnswerList() {
    displayAnswerList = [];
    final random = Random();

    switch (currentType) {
      case 0:
        List<String> fontList = List<String>.from(_currentQuestion!["font"] ?? ["VniAvo"]);
        List<dynamic> rawSizeList = _currentQuestion!["size"] ?? [18];
        List<double> sizeList = rawSizeList.map((e) => (e as num).toDouble()).toList();
        List<String> noiseList = List<String>.from(_currentQuestion!["noise"] ?? ["a"]);
        String target = currentTarget;

        for (String f in fontList) {
          for (double s in sizeList) {
            displayAnswerList.add({
              "letter": target,
              "font": f,
              "size": s
            });
          }
        }
        noiseList.add(target);
        while (displayAnswerList.length < 10) {
          final letter = noiseList[random.nextInt(noiseList.length)];
          displayAnswerList.add({
            "letter": letter,
            "font": fontList[random.nextInt(fontList.length)],
            "size": sizeList[random.nextInt(sizeList.length)]
          });
        }
        displayAnswerList.shuffle();
        break;

      case 1:
        List<String> fontList = List<String>.from(_currentQuestion!["font"] ?? ["VniAvo"]);
        List<dynamic> rawSizeList = _currentQuestion!["size"] ?? [18];
        List<double> sizeList = rawSizeList.map((e) => (e as num).toDouble()).toList();
        List<dynamic> rawWordSList = _currentQuestion!["word_spacing"] ?? [0];
        List<double> wordSList = rawWordSList.map((e) => (e as num).toDouble()).toList();
        List<dynamic> rawLetterSList = _currentQuestion!["letter_spacing"] ?? [0];
        List<double> letterSList = rawLetterSList.map((e) => (e as num).toDouble()).toList();

        List<Map<String, dynamic>> combinations = [];
        for (String f in fontList) {
          for (double s in sizeList) {
            for (double ws in wordSList) {
              for (double ls in letterSList) {
                combinations.add({
                  "word": currentTarget,
                  "font": f,
                  "size": s,
                  "word_spacing": ws,
                  "letter_spacing": ls,
                });
              }
            }
          }
        }

        while (combinations.length < 10) {
          combinations.add({
            "word": currentTarget,
            "font": fontList[random.nextInt(fontList.length)],
            "size": sizeList[random.nextInt(sizeList.length)],
            "word_spacing": wordSList[random.nextInt(wordSList.length)],
            "letter_spacing": letterSList[random.nextInt(letterSList.length)],
          });
        }
        if (combinations.length > 10) {
          combinations = combinations.sublist(0, 10);
        }

        combinations.shuffle();
        displayAnswerList = combinations;
        break;

      case 2:
        List<Color> bgColors = [
          Colors.white,
          const Color(0xFFE5E5E5), // Light Grey
          const Color(0xFFFFFCE4), // Cream/Light Yellow
        ];

        for (Color color in bgColors) {
          displayAnswerList.add({
            "word": currentTarget,
            "bg_color": color,
          });
        }
        break;

      default:
        break;
    }

    notifyListeners();
  }

  void selectAnswer(Map<String, dynamic> selectedOption) {
    final selectedIndex = displayAnswerList.indexOf(selectedOption);
    final position = selectedIndex >= 0 ? selectedIndex + 1 : 1;
    final String optionContent = selectedOption['letter'] ?? selectedOption['font'] ?? (selectedOption['bg_color'] is Color ? (selectedOption['bg_color'] as Color).value.toString() : '');

    if (currentType == 0) {
      bool isCorrect = selectedOption["letter"] == currentTarget;

      if (!isCorrect) {
        _wrongAttemptsCount++;
        errorMessage = "Chưa chính xác, em hãy thử lại nhé!";
        repoManager?.trialLogger.logEvent(
          eventType: 'INCORRECT',
          eventCode: 'incorrect',
          payload: {
            'content': optionContent,
            'position': position,
          },
        );
        notifyListeners();
        return; // Prompt user to try again without advancing
      }

      _stopwatch.stop();
      int elapsedMs = _stopwatch.elapsedMilliseconds;
      errorMessage = null;

      repoManager?.trialLogger.logEvent(
        eventType: 'CORRECT',
        eventCode: 'correct',
        payload: {
          'content': optionContent,
          'position': position,
        },
      );

      results.add({
        "type": 0,
        "target": currentTarget,
        "selected": selectedOption["letter"],
        "is_correct": true,
        "wrong_attempts": _wrongAttemptsCount,
        "time_ms": elapsedMs,
      });

      _wrongAttemptsCount = 0;
    } else if (currentType == 1) {
      repoManager?.trialLogger.logEvent(
        eventType: 'OPTION_SELECT',
        eventCode: 'select',
        payload: {
          'content': optionContent,
          'position': position,
        },
      );

      results.add({
        "type": 1,
        "font": selectedOption["font"],
        "size": (selectedOption["size"] as num).toDouble(),
        "word_spacing": (selectedOption["word_spacing"] as num).toDouble(),
        "letter_spacing": (selectedOption["letter_spacing"] as num).toDouble(),
      });
    } else if (currentType == 2) {
      repoManager?.trialLogger.logEvent(
        eventType: 'OPTION_SELECT',
        eventCode: 'select',
        payload: {
          'content': optionContent,
          'position': position,
        },
      );

      results.add({
        "type": 2,
        "bg_color": selectedOption["bg_color"],
      });
    }

    _nextQuestion();
  }

  void _nextQuestion() {
    int maxRepeat = _currentQuestion!["repeat"] ?? 1;
    _currentRepeat++;

    if (_currentRepeat < maxRepeat) {
      _setupQuestion();
    } else {
      _currentRepeat = 0;
      _currentIndex++;
      _setupQuestion();
    }
  }

  void _finishTest() {
    currentState = EvalTestState.END;
    notifyListeners();
    repoManager?.trialLogger.endTrial();
  }

  // --- RESULT METRICS ---

  double get type0Accuracy {
    final type0Results = results.where((r) => r["type"] == 0).toList();
    if (type0Results.isEmpty) return 100.0;
    int totalWrong = type0Results.fold(0, (sum, r) => sum + (r["wrong_attempts"] as int? ?? 0));
    int totalRounds = type0Results.length;
    if (totalRounds + totalWrong == 0) return 100.0;
    return (totalRounds / (totalRounds + totalWrong)) * 100.0;
  }

  double get type0AverageTimeSeconds {
    final type0Results = results.where((r) => r["type"] == 0).toList();
    if (type0Results.isEmpty) return 0.0;
    int totalMs = type0Results.fold(0, (sum, r) => sum + (r["time_ms"] as int));
    return (totalMs / type0Results.length) / 1000.0;
  }

  String get preferredFontFamily {
    final type1Results = results.where((r) => r["type"] == 1).toList();
    if (type1Results.isEmpty) return "VniAvo";
    return _getMode<String>(type1Results.map((r) => r["font"] as String).toList(), "VniAvo");
  }

  double get preferredFontSize {
    final type1Results = results.where((r) => r["type"] == 1).toList();
    if (type1Results.isEmpty) return 20.0;
    return _getMode<double>(type1Results.map((r) => r["size"] as double).toList(), 20.0);
  }

  double get preferredWordSpacing {
    final type1Results = results.where((r) => r["type"] == 1).toList();
    if (type1Results.isEmpty) return 1.0;
    return _getMode<double>(type1Results.map((r) => r["word_spacing"] as double).toList(), 1.0);
  }

  double get preferredLetterSpacing {
    final type1Results = results.where((r) => r["type"] == 1).toList();
    if (type1Results.isEmpty) return 1.5;
    return _getMode<double>(type1Results.map((r) => r["letter_spacing"] as double).toList(), 1.5);
  }

  Color get preferredBackgroundColor {
    final type2Results = results.where((r) => r["type"] == 2).toList();
    if (type2Results.isEmpty) return Colors.white;
    return _getMode<Color>(type2Results.map((r) => r["bg_color"] as Color).toList(), Colors.white);
  }

  T _getMode<T>(List<T> list, T fallback) {
    if (list.isEmpty) return fallback;
    final frequencyMap = <T, int>{};
    for (var item in list) {
      frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
    }
    T mostFrequent = fallback;
    int maxCount = 0;
    frequencyMap.forEach((key, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = key;
      }
    });
    return mostFrequent;
  }

  void applyPreferredSettings(NokodoSettings textSettings) {
    textSettings.setFontFamily(preferredFontFamily);
    textSettings.setFontSize(preferredFontSize);
    textSettings.setWordSpacing(preferredWordSpacing);
    textSettings.setLetterSpacing(preferredLetterSpacing);
    textSettings.setBackgroundColor(preferredBackgroundColor);
  }

  @override
  void dispose() {
    repoManager?.trialLogger.endTrial();
    super.dispose();
  }
}