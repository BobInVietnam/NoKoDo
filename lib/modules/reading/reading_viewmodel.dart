// viewmodels/reading_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/utils/tts_service.dart'; // Import your TTS service

class ReadingViewModel extends ChangeNotifier {
  final String extractedText;
  final TtsService _ttsService;
  int _currentWordStart = -1;
  int _currentWordEnd = -1;
  int _currentOffset = 0;
  String? _currentSelection;
  OverlayEntry? _selectionMenuOverlay;
  double _currentReadingSpeed = 0.5;

  // Getters
  String? get currentSelection => _currentSelection;
  double get currentReadingSpeed => _currentReadingSpeed;
  int get currentWordStart => _currentWordStart;
  int get currentWordEnd => _currentWordEnd;
  TtsState get ttsState => _ttsService.ttsState;
  bool get isMenuOpen => _selectionMenuOverlay != null;

  ReadingViewModel({
    required this.extractedText,
    required TtsService ttsService,}) : _ttsService = ttsService {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      // Ensure the engine is fully awake before configuring
      await _ttsService.setSpeechRate(_currentReadingSpeed);
      _ttsService.onWordProgress = (text, start, end, word) {
        _currentWordStart = start + _currentOffset;
        _currentWordEnd = end + _currentOffset;
        notifyListeners(); // Force UI to highlight the active indexes
      };
    } catch (e) {
      debugPrint("TTS Initialization failed: $e");
    }
  }

  void toggleTts() {
    if (ttsState != TtsState.playing) {
      if (currentSelection == null) {
        handleReadAll();
      } else {
        _handleReadSelected();
      }
    } else {
      handleStopReading();
    }
  }

  void handleReadAll() {
    _ttsService.speak(extractedText, onComplete: () {
      notifyListeners();
    });
    notifyListeners();
  }

  void _handleReadSelected() {
    _ttsService.speak(currentSelection!, onComplete: () {
      notifyListeners();
    });
    // removeSelectionMenu();
  }

  void handleStopReading() {
    _ttsService.stop();
    notifyListeners();
  }

  void handleSpeedChange(double speed) {
    _currentReadingSpeed = speed;
    _ttsService.setSpeechRate(speed);
    notifyListeners();
  }

  void updateSelection(String? selection, int offset) {
    if (selection == null) {
      if (ttsState == TtsState.playing) {
        handleStopReading();
      }
      debugPrint("READING: Removed selection");
    }
    _currentSelection = selection;
    _currentOffset = offset;
    debugPrint("READING: Current selection: $currentSelection");
    notifyListeners();
  }

  @override
  void dispose() {
    _ttsService.stop();
    // Ensure overlay entries are safely detached out of global stack references
    _selectionMenuOverlay?.remove();
    _selectionMenuOverlay = null;
    super.dispose();
  }
}