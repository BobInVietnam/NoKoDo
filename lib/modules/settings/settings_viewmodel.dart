// viewmodels/settings_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart'; // Adjust path if needed

class SettingsViewModel extends ChangeNotifier {
  final TextStyleSettings _settings;

  SettingsViewModel({required TextStyleSettings settings}) : _settings = settings {
    // Listen to changes in the underlying model to alert the view layer
    _settings.addListener(notifyListeners);
  }

  // Expose values safely to the View
  double get fontSize => _settings.fontSize;
  double get letterSpacing => _settings.letterSpacing;
  double get wordSpacing => _settings.wordSpacing;
  Color get color => _settings.color;
  String get fontFamily => _settings.fontFamily;
  Color get backgroundColor => _settings.backgroundColor;
  int get fontWeightValue => _settings.fontWeightValue;

  // Wrapped modification methods
  void updateFontSize(double value) {
    _settings.setFontSize(value);
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

  @override
  void dispose() {
    // Remove the listener to prevent memory leaks when screen is destroyed
    _settings.removeListener(notifyListeners);
    super.dispose();
  }
}