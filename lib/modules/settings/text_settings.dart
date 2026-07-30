import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/persistence.dart';

class TextStyleSettings extends ChangeNotifier {
  // Default values
  double _fontSize = 20.0;
  Color _color = Colors.black;
  String _fontFamily = 'Roboto';
  double _letterSpacing = 1.5;
  double _wordSpacing = 1.0;
  List<String> _highlights = [];
  Color _backgroundColor = Colors.white;
  int _fontWeightValue = 400;

  // Getters
  double get fontSize => _fontSize;
  Color get color => _color;
  String get fontFamily => _fontFamily;
  double get letterSpacing => _letterSpacing;
  double get wordSpacing => _wordSpacing;
  List<String> get highlights => _highlights;
  Color get backgroundColor => _backgroundColor;
  int get fontWeightValue => _fontWeightValue;

  FontWeight get fontWeight {
    switch (_fontWeightValue) {
      case 100: return FontWeight.w100;
      case 200: return FontWeight.w200;
      case 300: return FontWeight.w300;
      case 400: return FontWeight.w400;
      case 500: return FontWeight.w500;
      case 600: return FontWeight.w600;
      case 700: return FontWeight.w700;
      case 800: return FontWeight.w800;
      case 900: return FontWeight.w900;
      default: return FontWeight.w400;
    }
  }

  // Constructor: Triggers loading immediately when the provider is created
  TextStyleSettings([LocalDatabase? db]) {
    _loadFromPrefs();
    if (db != null) {
      _loadHighlightsFromDb(db);
    }
  }

  Future<void> _loadHighlightsFromDb(LocalDatabase db) async {
    try {
      _highlights = await db.getAllHighlights();
      notifyListeners();
    } catch (e) {
      debugPrint("HIGHLIGHTS: Load from database failed: $e");
    }
  }

  Future<void> addHighlight(LocalDatabase db, String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;
    if (_highlights.contains(cleanText)) return;
    try {
      await db.insertHighlight(cleanText);
      _highlights.add(cleanText);
      notifyListeners();
    } catch (e) {
      debugPrint("HIGHLIGHTS: Add failed: $e");
    }
  }

  Future<void> removeHighlight(LocalDatabase db, String text) async {
    final cleanText = text.trim();
    try {
      await db.deleteHighlight(cleanText);
      _highlights.remove(cleanText);
      notifyListeners();
    } catch (e) {
      debugPrint("HIGHLIGHTS: Remove failed: $e");
    }
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

    int bgColorValue = prefs.getInt('backgroundColorValue') ?? Colors.white.toARGB32();
    _backgroundColor = Color(bgColorValue);

    _fontWeightValue = prefs.getInt('fontWeightValue') ?? 400;

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
    prefs.setInt('backgroundColorValue', _backgroundColor.toARGB32());
    prefs.setInt('fontWeightValue', _fontWeightValue);
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

  void setBackgroundColor(Color newColor) {
    _backgroundColor = newColor;
    _saveToPrefs();
    notifyListeners();
  }

  void setFontWeightValue(int newValue) {
    _fontWeightValue = newValue;
    _saveToPrefs();
    notifyListeners();
  }
}