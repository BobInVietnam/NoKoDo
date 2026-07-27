import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';

import '../../data/repository_manager.dart';

enum GameState {
  START,
  COUNTDOWN,
  IN_PROGRESS,
  FINISHED
}

class LetterSearchViewModel extends ChangeNotifier {
  static const List<Map<String, dynamic>> defaultMockContent = [
    {
      "height": 7,
      "width": 9,
      "target": "d",
      "noise": ["b", "p", "q"],
      "chance": 0.35,
      "spacing": 0.0,
      "size": 42.0
    },
    {
      "height": 7,
      "width": 9,
      "target": "t",
      "noise": ["f", "l", "i"],
      "chance": 0.40,
      "spacing": 6.0,
      "size": 28.0
    },
    {
      "height": 7,
      "width": 9,
      "target": "n",
      "noise": ["u", "m", "h"],
      "chance": 0.45,
      "spacing": 2.0,
      "size": 56.0
    },
    {
      "height": 5,
      "width": 7,
      "target": "ă",
      "noise": ["a", "ã", "â"],
      "chance": 0.80,
      "spacing": 1.0,
      "size": 40.0
    },
    {
      "height": 5,
      "width": 11,
      "target": "ê",
      "noise": ["ẽ", "è", "é"],
      "chance": 0.80,
      "spacing": 3.0,
      "size": 66.0
    }
  ];

  final List<Map<String, dynamic>> _content;
  final String lessonId;
  final RepoManager? repoManager;

  int _currentRound = 0;
  int _totalRounds = 0;
  GameState _currentState = GameState.START;
  
  List<Map<String, dynamic>> _results = [];
  List<List<String>> _displayGrid = List.generate(7, (_) => List.filled(9, ""));
  
  int _countdownSeconds = 3;
  Timer? _countdownTimer;
  String _target = "";
  
  double _elapsedSeconds = 0.0;
  Timer? _gameTimer;
  
  int _attempts = 0;
  String? _feedbackMessage;

  // Getters
  int get currentRound => _currentRound;
  int get totalRound => _totalRounds;
  List<List<String>> get displayGrid => _displayGrid;
  GameState get currentState => _currentState;
  int get countdownSeconds => _countdownSeconds;
  String get target => _target;
  double get elapsedSeconds => _elapsedSeconds;
  int get attempts => _attempts;
  String? get feedbackMessage => _feedbackMessage;
  List<Map<String, dynamic>> get results => _results;
  double get currentSpacing => (_content[_currentRound]['spacing'] as num?)?.toDouble() ?? 4.0;
  double get currentSize => (_content[_currentRound]['size'] as num?)?.toDouble() ?? 22.0;
  int get currentGridHeight => _content[_currentRound]['height'] as int;
  int get currentGridWidth => _content[_currentRound]['width'] as int;

  LetterSearchViewModel({
    List<Map<String, dynamic>>? content,
    required this.lessonId,
    this.repoManager,
  }) : _content = content ?? defaultMockContent {
    _totalRounds = _content.length;
    startGame();
  }

  void syncLessonResultIfCompleted() {
    if (_currentState == GameState.FINISHED && repoManager != null) {
      debugPrint("LETTER_SEARCH: Game completed. Syncing result.");
      repoManager!.sendLessonResult(lessonId!, {
        'completed': true,
        'results': _results,
      });
    } else {
      debugPrint("LETTER_SEARCH: Exit checked. Game NOT completed or missing references.");
    }
  }

  void startGame() {
    _currentRound = 0;
    _results = [];
    _startCountdown();
  }

  void _startCountdown() {
    _currentState = GameState.COUNTDOWN;
    _countdownSeconds = 3;
    _feedbackMessage = null;
    notifyListeners();

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        _startRound();
      }
    });
  }

  void _startRound() {
    _currentState = GameState.IN_PROGRESS;
    _attempts = 0;
    _elapsedSeconds = 0.0;
    _feedbackMessage = null;
    _loadSymbols();

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _elapsedSeconds += 0.1;
      notifyListeners();
    });
  }

  void _loadSymbols() {
    final currentRoundData = _content[_currentRound];
    _target = currentRoundData['target'] as String;
    final double chance = (currentRoundData['chance'] as num).toDouble();
    final List<String> noiseList = List<String>.from(currentRoundData['noise'] as List);

    final Random random = Random();
    _displayGrid = List.generate(currentGridHeight,
            (_) => List.filled(currentGridWidth, ""));

    int targetRow = random.nextInt(currentGridHeight);
    int targetCol = random.nextInt(currentGridWidth);
    _displayGrid[targetRow][targetCol] = target;

    for (int r = 0; r < currentGridHeight; r++) {
      for (int c = 0; c < currentGridWidth; c++) {
        if (r == targetRow && c == targetCol) continue;
        if (random.nextDouble() < chance) {
          String selectedNoise = noiseList[random.nextInt(noiseList.length)];
          _displayGrid[r][c] = selectedNoise;
        }
      }
    }
    notifyListeners();
  }

  void handleCellTap(int row, int col) {
    if (_currentState != GameState.IN_PROGRESS) return;

    final tappedChar = _displayGrid[row][col];

    if (tappedChar == target) {
      _attempts++;
      _feedbackMessage = "Chính xác!";
      _gameTimer?.cancel();
      notifyListeners();

      _results.add({
        "round": _currentRound + 1,
        "target": target,
        "time": _elapsedSeconds,
        "attempts": _attempts,
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (_currentRound + 1 < _totalRounds) {
          _currentRound++;
          _startCountdown();
        } else {
          _currentState = GameState.FINISHED;
          notifyListeners();
        }
      });
    } else {
      if (tappedChar.isNotEmpty) {
        _attempts++;
        _feedbackMessage = "Sai rồi! Hãy tìm tiếp.";
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }
}