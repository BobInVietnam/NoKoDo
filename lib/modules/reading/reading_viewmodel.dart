// viewmodels/reading_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/utils/tts_service.dart'; // Import your TTS service

class ReadingViewModel extends ChangeNotifier {
  final String extractedText;
  final TtsService _ttsService;
  int _currentWordStart = -1;
  int _currentWordEnd = -1;
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
        _currentWordStart = start;
        _currentWordEnd = end;
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

  //TODO: Remove unnecessary menu stuff or change this
  void updateSelection(String? selection, BuildContext context, GlobalKey textKey) {
    if (selection == null) {
      // removeSelectionMenu();
      if (ttsState == TtsState.playing) {
        handleStopReading();
      }
      debugPrint("READING: Removed selection");
    }
    _currentSelection = selection;
    debugPrint("READING: Current selection: $currentSelection");
    notifyListeners();
    // _showSelectionMenu(context, textKey);
  }

  // void _showSelectionMenu(BuildContext context, GlobalKey textKey) {
  //   removeSelectionMenu(); // Clear previous overlays
  //
  //   if (textKey.currentContext == null) return;
  //   final RenderBox renderBox = textKey.currentContext!.findRenderObject() as RenderBox;
  //
  //   // Rough approximate bounding calculations for selection toolbar placement
  //   final Offset menuPosition = renderBox.localToGlobal(
  //       Offset(
  //           (_currentSelection.start + (_currentSelection.end - _currentSelection.start) / 2) * (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16) * 0.5,
  //           _currentSelection.baseOffset * (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16) * 1.5 - 100
  //       )
  //   );
  //
  //   _selectionMenuOverlay = OverlayEntry(
  //     builder: (overlayContext) {
  //       final selectedText = extractedText.substring(_currentSelection.start, _currentSelection.end);
  //       return Positioned(
  //         left: menuPosition.dx - 50,
  //         top: menuPosition.dy - 50,
  //         child: Material(
  //           elevation: 4.0,
  //           borderRadius: BorderRadius.circular(8),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[800],
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 TextButton(
  //                   child: const Text('Đọc phần đã chọn', style: TextStyle(color: Colors.white)),
  //                   onPressed: () => handleReadSelected(selectedText),
  //                 ),
  //                 TextButton(
  //                   child: const Text('Đánh dấu', style: TextStyle(color: Colors.white)),
  //                   onPressed: () {
  //                     debugPrint('Highlight: "$selectedText"');
  //                     removeSelectionMenu();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  //   Overlay.of(context).insert(_selectionMenuOverlay!);
  //   notifyListeners();
  // }

  void removeSelectionMenu() {
    if (_selectionMenuOverlay != null) {
      _selectionMenuOverlay!.remove();
      _selectionMenuOverlay = null;
      notifyListeners();
    }
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