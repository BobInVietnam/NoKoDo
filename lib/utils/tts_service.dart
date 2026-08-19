import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';

enum TtsState { playing, stopped, paused }

class TtsService extends ChangeNotifier {

  late FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  TtsState get ttsState => _ttsState;
  bool get isPlaying => _ttsState == TtsState.playing;

  Function? _onComplete;
  void Function(String, int, int, String)? onWordProgress;

  NokodoSettings settings;

  TtsService({required this.settings})  {
    _flutterTts = FlutterTts();
    _setTtsEventHandlers();
    _initializeDefaultSettings();
  }

  Future<void> _initializeDefaultSettings() async {
    await _flutterTts.setLanguage("vi-VN");
    await _flutterTts.setSpeechRate(settings.ttsSpeechRate);
    await _flutterTts.setVolume(settings.ttsVolume);
  }

  void _setTtsEventHandlers() {
    _flutterTts.setStartHandler(() {
      _ttsState = TtsState.playing;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
      _onComplete?.call();
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _ttsState = TtsState.stopped;
      debugPrint("TTS Error: $msg");
      notifyListeners();
    });

    _flutterTts.setPauseHandler(() {
      _ttsState = TtsState.paused;
      notifyListeners();
    });

    _flutterTts.setContinueHandler(() {
      _ttsState = TtsState.playing;
      notifyListeners();
    });

    _flutterTts.setCancelHandler(() {
      _ttsState = TtsState.stopped;
      notifyListeners();
    });

    _flutterTts.setProgressHandler((String text, int start, int end, String word) {
      onWordProgress?.call(text, start, end, word);
    });
  }

  Future<void> speak(String text, {Function? onComplete}) async {
    _onComplete = onComplete;
    if (text.isNotEmpty) {
      _ttsState = TtsState.playing;
      notifyListeners();
      await _flutterTts.setSpeechRate(settings.ttsSpeechRate);
      await _flutterTts.setVolume(settings.ttsVolume);
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) {
      _ttsState = TtsState.stopped;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    notifyListeners();
  }

  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }

  Future<List<dynamic>> getVoices() async {
    return await _flutterTts.getVoices;
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _flutterTts.setVoice(voice);
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

