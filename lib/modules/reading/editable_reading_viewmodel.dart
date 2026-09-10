// viewmodels/editable_reading_viewmodel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/models/dictionary_entry.dart';
import 'package:nodyslexia/utils/audio_recorder.dart';
import 'package:nodyslexia/utils/tts_service.dart'; // Import your TTS service

import 'package:nodyslexia/data/repository_manager.dart';

enum TtsMode { none, paragraph, all, selection }

class EditableReadingViewModel extends ChangeNotifier {
  ConvertedFile _file;

  String _extractedText = "";
  int _fileId = 0;
  final TtsService _ttsService;
  final LocalDatabase _localDatabase;
  final RepoManager? repoManager;
  final AudioRecorder audioRecorder;
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
      final oldIndex = _selectedParagraphIndex;
      _selectedParagraphIndex = index;
      if (repoManager != null && oldIndex != index) {
        repoManager!.trialLogger.logEvent(
          eventType: 'PARAGRAPH_CHANGE',
          eventCode: 'pgchange',
          payload: {'from': oldIndex, 'to': index},
        );
      }
      notifyListeners();
    }
  }

  EditableReadingViewModel({
    required ConvertedFile file,
    required TtsService ttsService,
    required LocalDatabase localDatabase,
    required this.audioRecorder,
    this.repoManager,
  })  : _ttsService = ttsService, _file = file, _localDatabase = localDatabase {
    _extractedText = _file.extractedText;
    _fileId = _file.id!;
    _initializeTts();

    if (repoManager != null) {
      repoManager!.trialLogger.startTrial(
        trialType: 'READING_LOCAL',
        trialCode: 'rl',
        trialName: file.fileName
      );
      repoManager!.trialLogger.logEvent(
        eventType: 'STIMULUS_SHOWN',
        eventCode: 'shown',
        payload: {
          'content': _extractedText,
          'initialSettings': repoManager!.currentStudent?.settings ?? {},
        },
      );
    }
  }

  void refreshContent(ConvertedFile file) {
    _extractedText = file.extractedText;
    _file = file;
    _selectedParagraphIndex = 0;
    notifyListeners();
  }

  Future<void> _initializeTts() async {
    try {
      _ttsService.addListener(_onTtsChanged);
      _ttsService.onWordProgress = (text, start, end, word) {
        _currentWordStart = start + _currentOffset;
        _currentWordEnd = end + _currentOffset;
        notifyListeners(); // Force UI to highlight the active indexes
      };
    } catch (e) {
      debugPrint("TTS Initialization failed: $e");
    }
  }

  void _onTtsChanged() {
    notifyListeners();
  }

  void toggleTtsParagraph() {
    if (ttsState == TtsState.playing && _currentTtsMode == TtsMode.paragraph) {
      handleStopReading();
    } else {
      if (ttsState == TtsState.playing) {
        _ttsService.stop();
        repoManager?.trialLogger.logEvent(
          eventType: 'TTS_STOP',
          eventCode: 'ttsstop',
          payload: {},
        );
      }
      _currentTtsMode = TtsMode.paragraph;
      _currentOffset = 0;
      _currentWordStart = -1;
      _currentWordEnd = -1;
      if (paragraphs.isNotEmpty && _selectedParagraphIndex < paragraphs.length) {
        final textToRead = paragraphs[_selectedParagraphIndex];
        repoManager?.trialLogger.logEvent(
          eventType: 'TTS_START',
          eventCode: 'ttsstart',
          payload: {'content': textToRead},
        );
        _ttsService.speak(textToRead, onComplete: () {
          _currentTtsMode = TtsMode.none;
          _currentWordStart = -1;
          _currentWordEnd = -1;
          repoManager?.trialLogger.logEvent(
            eventType: 'TTS_STOP',
            eventCode: 'ttsstop',
            payload: {},
          );
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
        repoManager?.trialLogger.logEvent(
          eventType: 'TTS_STOP',
          eventCode: 'ttsstop',
          payload: {},
        );
      }
      if (currentSelection != null) {
        _currentTtsMode = TtsMode.selection;
        _currentWordStart = -1;
        _currentWordEnd = -1;
        final textToRead = currentSelection!;
        repoManager?.trialLogger.logEvent(
          eventType: 'TTS_START',
          eventCode: 'ttsstart',
          payload: {'content': textToRead},
        );
        _ttsService.speak(textToRead, onComplete: () {
          _currentTtsMode = TtsMode.none;
          _currentWordStart = -1;
          _currentWordEnd = -1;
          repoManager?.trialLogger.logEvent(
            eventType: 'TTS_STOP',
            eventCode: 'ttsstop',
            payload: {},
          );
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
        repoManager?.trialLogger.logEvent(
          eventType: 'TTS_STOP',
          eventCode: 'ttsstop',
          payload: {},
        );
      }
      selectParagraph(0);
      _currentTtsMode = TtsMode.all;
      repoManager?.trialLogger.logEvent(
        eventType: 'TTS_START',
        eventCode: 'ttsstart',
        payload: {'content': _extractedText},
      );
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
          repoManager?.trialLogger.logEvent(
            eventType: 'TTS_STOP',
            eventCode: 'ttsstop',
            payload: {},
          );
          notifyListeners();
        }
      });
    } else {
      handleStopReading();
    }
  }

  void handleStopReading() {
    repoManager?.trialLogger.logEvent(
      eventType: 'TTS_STOP',
      eventCode: 'ttsstop',
      payload: {},
    );
    _ttsService.stop();
    _currentTtsMode = TtsMode.none;
    _currentWordStart = -1;
    _currentWordEnd = -1;
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
    final entry = await _localDatabase.getDictionaryEntryByWord(currentSelection!.toLowerCase());
    if (repoManager != null && currentSelection != null) {
      repoManager!.trialLogger.logEvent(
        eventType: 'DICTIONARY_LOOKUP',
        eventCode: 'dictlookup',
        payload: {
          'content': currentSelection,
          'success': entry != null,
        },
      );
    }
    return entry;
  }

  void toggleRecording() {
    if (audioRecorder.isRecording) {
      stopRecorder();
    } else {
      startRecorder();
    }
  }

  Future<void> startRecorder() async {
    await audioRecorder.record(
        sid: repoManager?.currentStudent?.getFormattedSid() ?? "S0");
    repoManager?.trialLogger.logEvent(
        eventType: "RECORD_START",
        eventCode: "record",
        payload: {
          "name": audioRecorder.recordingName
        });
    notifyListeners();
  }

  Future<void> stopRecorder() async {
    await audioRecorder.stop();
    repoManager?.trialLogger.logEvent(
        eventType: "RECORD_END",
        eventCode: "recordend",
        payload: {});
    notifyListeners();
  }

  @override
  void dispose() {
    repoManager?.trialLogger.endTrial();
    _ttsService.removeListener(_onTtsChanged);
    _ttsService.stop();
    // Ensure overlay entries are safely detached out of global stack references
    _selectionMenuOverlay?.remove();
    _selectionMenuOverlay = null;
    super.dispose();
  }
}