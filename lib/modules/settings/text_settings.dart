import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextStyleSettings extends ChangeNotifier {
  // Default values
  double _fontSize = 20.0;
  Color _color = Colors.black;
  String _fontFamily = 'Roboto';
  double _letterSpacing = 1.5;
  double _wordSpacing = 1.0;

  // Getters
  double get fontSize => _fontSize;
  Color get color => _color;
  String get fontFamily => _fontFamily;
  double get letterSpacing => _letterSpacing;
  double get wordSpacing => _wordSpacing;

  // Constructor: Triggers loading immediately when the provider is created
  TextStyleSettings() {
    _loadFromPrefs();
  }

  // --- PERSISTENCE LOGIC ---

  // Load data from disk
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Load values, or use defaults if they don't exist
    _fontSize = prefs.getDouble('fontSize') ?? 20.0;
    _letterSpacing = prefs.getDouble('letterSpacing') ?? 1.5;
    _wordSpacing = prefs.getDouble('wordSpacing') ?? 1.0;
    _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';

    // Load Color (stored as an integer)
    int colorValue = prefs.getInt('colorValue') ?? Colors.black.toARGB32();
    _color = Color(colorValue);

    // Important: Tell the UI to rebuild with the loaded values
    notifyListeners();
  }

  // Save data to disk
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setDouble('fontSize', _fontSize);
    prefs.setDouble('letterSpacing', _letterSpacing);
    prefs.setDouble('wordSpacing', _wordSpacing);
    prefs.setString('fontFamily', _fontFamily);
    prefs.setInt('colorValue', _color.toARGB32()); // Save color as int
  }

  // --- SETTERS (Update variable -> Save -> Notify) ---

  void setFontSize(double newSize) {
    _fontSize = newSize;
    _saveToPrefs(); // Auto-save
    notifyListeners();
  }

  void setColor(Color newColor) {
    _color = newColor;
    _saveToPrefs(); // Auto-save
    notifyListeners();
  }

  void setFontFamily(String newFont) {
    _fontFamily = newFont;
    _saveToPrefs(); // Auto-save
    notifyListeners();
  }

  void setLetterSpacing(double newSpacing) {
    _letterSpacing = newSpacing;
    _saveToPrefs(); // Auto-save
    notifyListeners();
  }

  void setWordSpacing(double newSpacing) {
    _wordSpacing = newSpacing;
    _saveToPrefs(); // Auto-save
    notifyListeners();
  }
}