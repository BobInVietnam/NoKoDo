import 'package:flutter/material.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/utils/tts_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final NokodoSettings _settings;
  final TtsService _ttsService;

  SettingsViewModel({
    required NokodoSettings settings,
    required TtsService ttsService,
  }) : _settings = settings,
       _ttsService = ttsService {
    _settings.addListener(notifyListeners);
    _ttsService.addListener(notifyListeners);
  }

  // Expose values safely to the View
  double get fontSize => _settings.fontSize;
  double get fontOpacity => _settings.fontOpacity;
  double get letterSpacing => _settings.letterSpacing;
  double get wordSpacing => _settings.wordSpacing;
  Color get color => _settings.color;
  String get fontFamily => _settings.fontFamily;
  Color get backgroundColor => _settings.backgroundColor;
  int get fontWeightValue => _settings.fontWeightValue;
  double get speechRate => _settings.ttsSpeechRate;
  double get volume => _settings.ttsVolume;

  // Wrapped modification methods
  void updateFontSize(double value) {
    _settings.setFontSize(value);
  }

  void updateFontOpacity(double value) {
    _settings.setFontOpacity(value);
  }

  void updateLetterSpacing(double value) {
    _settings.setLetterSpacing(value);
  }

  void updateWordSpacing(double value) {
    _settings.setWordSpacing(value);
  }

  void updateColor(Color newColor) {
    _settings.setColor(newColor);
  }

  void updateFontFamily(String family) {
    _settings.setFontFamily(family);
  }

  void updateBackgroundColor(Color newColor) {
    _settings.setBackgroundColor(newColor);
  }

  void updateFontWeight(int value) {
    _settings.setFontWeightValue(value);
  }

  Future<void> updateSpeechRate(double value) async {
    _settings.setTtsSpeechRate(value);
  }

  Future<void> updateVolume(double value) async {
    _settings.setTtsVolume(value);
  }

  void playTestSound() {
    _ttsService.speak("Xin chào");
  }

  @override
  void dispose() {
    _settings.removeListener(notifyListeners);
    _ttsService.removeListener(notifyListeners);
    super.dispose();
  }
}
