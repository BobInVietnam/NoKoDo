import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextStyleSettings extends ChangeNotifier {
  // Default values
  double _fontSize = 20.0;
  Color _color = Colors.black;
  String _fontFamily = 'Roboto';

  // Getters
  double get fontSize => _fontSize;
  Color get color => _color;
  String get fontFamily => _fontFamily;

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
}