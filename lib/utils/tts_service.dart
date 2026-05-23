// lib/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class TtsService {
  static final TtsService _instance = TtsService._internal();

  // 2. Expose a public factory constructor that always returns the same instance
  factory TtsService() => _instance;

  late FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  TtsState get ttsState => _ttsState;
  double _speechRate = 0.5;

  Function? _onComplete;
  void Function(String, int, int, String)? onWordProgress;
  // 3. Convert the original constructor into a private internal named constructor (_internal)
  // This guarantees no other file can accidentally call 'TtsService()' to create duplicate engines
  TtsService._internal() {
    _flutterTts = FlutterTts();
    _setTtsEventHandlers();
    _initializeDefaultSettings();
  }

  Future<void> _initializeDefaultSettings() async {
    await _flutterTts.setLanguage("vi-VN");
    await _flutterTts.setSpeechRate(_speechRate);
  }

  void _setTtsEventHandlers() {
    _flutterTts.setStartHandler(() {
      _ttsState = TtsState.playing;
      // Notify listeners if using a state management solution
    });

    _flutterTts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
      _onComplete?.call();
      // Notify listeners
    });

    _flutterTts.setErrorHandler((msg) {
      _ttsState = TtsState.stopped;
      print("TTS Error: $msg");
      // Notify listeners
    });

    _flutterTts.setProgressHandler((String text, int start, int end, String word) {
      onWordProgress?.call(text, start, end, word);
    });

    // Optional: setCancelHandler, setPauseHandler, setContinueHandler
  }


  Future<void> speak(String text, {Function? onComplete}) async {
    _onComplete = onComplete;
    if (text.isNotEmpty) {
      _ttsState = TtsState.playing;
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) _ttsState = TtsState.stopped;
  }

  Future<void> setSpeechRate(double rate) async {
    // Clamp rate between 0.0 and 1.0 for flutter_tts,
    // though some platforms might support higher rates for speak()
    // but setSpeechRate itself often expects 0.0 to 1.0.
    // Adjust if your testing shows different behavior on target devices.
    _speechRate = rate.clamp(0.1, 2.0); // Example practical range for slider
    await _flutterTts.setSpeechRate(_speechRate);
  }


  Future<void> setLanguage(String languageCode) async {
    // e.g., "en-US", "vi-VN"
    await _flutterTts.setLanguage(languageCode);
  }

  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }

  Future<List<dynamic>> getVoices() async {
    return await _flutterTts.getVoices;
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _flutterTts.setVoice(voice);
  }

  void dispose() {
    // No explicit dispose method in flutter_tts,
    // but good practice to stop if playing
    stop();
  }
}

