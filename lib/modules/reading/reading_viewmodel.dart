import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/dictionary_entry.dart';
import 'package:nodyslexia/utils/tts_service.dart';

enum TtsMode { none, paragraph, all, selection }

class ReadingViewModel extends ChangeNotifier {
  final String? lessonId;
  final RepoManager? repoManager;

  String _extractedText = "";
  List<String> _paragraphs = List.empty();
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

  bool _hasReadParagraph = false;
  bool _hasReadAll = false;
  bool _scrolledToBottom = false;

  // Getters
  String? get currentSelection => _currentSelection;
  double get currentReadingSpeed => _currentReadingSpeed;
  int get currentWordStart => _currentWordStart;
  int get currentWordEnd => _currentWordEnd;
  TtsService get ttsService => _ttsService;
  TtsState get ttsState => _ttsService.ttsState;
  bool get isMenuOpen => _selectionMenuOverlay != null;
  String get extractedText => _extractedText;
  List<String> get paragraphs => _paragraphs;
  int get selectedParagraphIndex => _selectedParagraphIndex;
  TtsMode get currentTtsMode => _currentTtsMode;
  bool get scrolledToBottom => _scrolledToBottom;
  bool get hasReadParagraph => _hasReadParagraph;
  bool get hasReadAll => _hasReadAll;

  void selectParagraph(int index) {
    if (index >= 0 && index < _paragraphs.length) {
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

  ReadingViewModel({
    required String text,
    required TtsService ttsService,
    required LocalDatabase localDatabase,
    this.lessonId,
    this.repoManager,
  })  : _ttsService = ttsService,
        _extractedText = text,
        _localDatabase = localDatabase {
    _initializeTts();
    _extractParagraphs();

    if (repoManager != null) {
      repoManager!.trialLogger.startTrial(
        trialType: 'READING',
        trialCode: 'r',
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

  Future<void> _initializeTts() async {
    try {
      _ttsService.addListener(_onTtsChanged);
      _ttsService.onWordProgress = (text, start, end, word) {
        _currentWordStart = start + _currentOffset;
        _currentWordEnd = end + _currentOffset;
        notifyListeners();
      };
    } catch (e) {
      debugPrint("TTS Initialization failed: $e");
    }
  }

  void _onTtsChanged() {
    notifyListeners();
  }

  void _extractParagraphs() {
    _paragraphs = extractedText
        .split('\n\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
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
      _hasReadParagraph = true;
      _currentOffset = 0;
      _currentWordStart = -1;
      _currentWordEnd = -1;
      if (_paragraphs.isNotEmpty && _selectedParagraphIndex < _paragraphs.length) {
        final textToRead = _paragraphs[_selectedParagraphIndex];
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
      _hasReadAll = true;
      repoManager?.trialLogger.logEvent(
        eventType: 'TTS_START',
        eventCode: 'ttsstart',
        payload: {'content': _extractedText},
      );
      _readParagraphSequentially(_selectedParagraphIndex);
    }
  }

  void markScrolledToBottom() {
    if (!_scrolledToBottom) {
      _scrolledToBottom = true;
      debugPrint("READING: User scrolled to the bottom of the text.");
      notifyListeners();
    }
  }

  void syncLessonResultIfCriteriaMet() {
    final hasRead = _hasReadParagraph || _hasReadAll;
    if (hasRead && _scrolledToBottom && lessonId != null && repoManager != null) {
      debugPrint("READING: Criteria met. Sending lesson result.");
      repoManager!.sendLessonResult(lessonId!, {
        'completed': true,
        'hasReadParagraph': _hasReadParagraph,
        'hasReadAll': _hasReadAll,
        'scrolledToBottom': _scrolledToBottom,
      });
    } else {
      debugPrint("READING: Criteria NOT met. hasRead: $hasRead, scrolledToBottom: $_scrolledToBottom");
    }
  }

  void _readParagraphSequentially(int index) {
    if (index < _paragraphs.length) {
      _selectedParagraphIndex = index;
      _currentOffset = 0;
      _currentWordStart = -1;
      _currentWordEnd = -1;
      notifyListeners();

      _ttsService.speak(_paragraphs[index], onComplete: () {
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
    if (ttsState == TtsState.playing) {
      repoManager?.trialLogger.logEvent(
        eventType: 'TTS_STOP',
        eventCode: 'ttsstop',
        payload: {},
      );
    }
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