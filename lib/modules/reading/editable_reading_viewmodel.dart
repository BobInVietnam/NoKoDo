// viewmodels/editable_reading_viewmodel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/models/dictionary_entry.dart';
import 'package:nodyslexia/utils/tts_service.dart'; // Import your TTS service

enum TtsMode { none, paragraph, all, selection }

class EditableReadingViewModel extends ChangeNotifier {
  ConvertedFile _file;
  String _extractedText = "";
  int _fileId = 0;
  final TtsService _ttsService;
  final LocalDatabase _localDatabase;
  int _currentWordStart = -1;
  int _currentWordEnd = -1;
  int _currentOffset = 0;
  String? _currentSelection;
  OverlayEntry? _selectionMenuOverlay;
  double _currentReadingSpeed = 0.5;
  int _selectedParagraphIndex = 0;
  TtsMode _currentTtsMode = TtsMode.none;

  // Getters
  ConvertedFile get file => _file;
  String? get currentSelection => _currentSelection;
  double get currentReadingSpeed => _currentReadingSpeed;
  int get currentWordStart => _currentWordStart;
  int get currentWordEnd => _currentWordEnd;
  TtsService get ttsService => _ttsService;
  TtsState get ttsState => _ttsService.ttsState;
  bool get isMenuOpen => _selectionMenuOverlay != null;
  String get extractedText => _extractedText;
  int get fileId => _fileId;
  int get selectedParagraphIndex => _selectedParagraphIndex;
  List<String> get paragraphs => _file.paragraphs;
  TtsMode get currentTtsMode => _currentTtsMode;

  void selectParagraph(int index) {
    if (index >= 0 && index < paragraphs.length) {
      _selectedParagraphIndex = index;
      notifyListeners();
    }
  }

  EditableReadingViewModel({
    required ConvertedFile file,
    required TtsService ttsService,
    required LocalDatabase localDatabase})
      : _ttsService = ttsService, _file = file, _localDatabase = localDatabase {
    _extractedText = _file.extractedText;
    _fileId = _file.id!;
    _initializeTts();
  }

  void refreshContent(ConvertedFile file) {
    _extractedText = file.extractedText;
    _file = file;
    _selectedParagraphIndex = 0;
    notifyListeners();
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

  void toggleTtsParagraph() {
    if (ttsState == TtsState.playing && _currentTtsMode == TtsMode.paragraph) {
      handleStopReading();
    } else {
      if (ttsState == TtsState.playing) {
        _ttsService.stop();
      }
      _currentTtsMode = TtsMode.paragraph;
      _currentOffset = 0;
      _currentWordStart = -1;
      _currentWordEnd = -1;
      if (paragraphs.isNotEmpty && _selectedParagraphIndex < paragraphs.length) {
        _ttsService.speak(paragraphs[_selectedParagraphIndex], onComplete: () {
          _currentTtsMode = TtsMode.none;
          _currentWordStart = -1;
          _currentWordEnd = -1;
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }

  void toggleTtsSelection() {
    if (ttsState == TtsState.playing && _currentTtsMode == TtsMode.selection) {
      handleStopReading();
    } else {
      if (ttsState == TtsState.playing) {
        _ttsService.stop();
      }
      if (currentSelection != null) {
        _currentTtsMode = TtsMode.selection;
        _currentWordStart = -1;
        _currentWordEnd = -1;
        _ttsService.speak(currentSelection!, onComplete: () {
          _currentTtsMode = TtsMode.none;
          _currentWordStart = -1;
          _currentWordEnd = -1;
          notifyListeners();
        });
        notifyListeners();
      }
    }
  }

  void toggleTtsAll() {
    if (ttsState == TtsState.playing && _currentTtsMode == TtsMode.all) {
      handleStopReading();
    } else {
      if (ttsState == TtsState.playing) {
        _ttsService.stop();
      }
      _currentTtsMode = TtsMode.all;
      _readParagraphSequentially(_selectedParagraphIndex);
    }
  }

  void _readParagraphSequentially(int index) {
    if (index < paragraphs.length) {
      _selectedParagraphIndex = index;
      _currentOffset = 0;
      _currentWordStart = -1;
      _currentWordEnd = -1;
      notifyListeners();

      _ttsService.speak(paragraphs[index], onComplete: () {
        if (_currentTtsMode == TtsMode.all) {
          _readParagraphSequentially(index + 1);
        } else {
          _currentTtsMode = TtsMode.none;
          _currentWordStart = -1;
          _currentWordEnd = -1;
          notifyListeners();
        }
      });
    } else {
      handleStopReading();
    }
  }

  void handleStopReading() {
    _ttsService.stop();
    _currentTtsMode = TtsMode.none;
    _currentWordStart = -1;
    _currentWordEnd = -1;
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

  Future<DictionaryEntry?>  getWordDefinition() async {
    return await _localDatabase.getDictionaryEntryByWord(currentSelection!);
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