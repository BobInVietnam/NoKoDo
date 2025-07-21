// lib/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum for font choices for clarity
enum AppFont { openSans, roboto, lato, galindo }

class ThemeProvider extends ChangeNotifier {
  // --- Theme Properties ---
  AppFont _currentFontFamily;
  double _currentFontSize;
  Color _currentTextColor;
  double _currentLetterSpacing;
  double _currentLineSpacing;

  ThemeData _currentTheme;

  // --- SharedPreferences Keys ---
  static const String _fontFamilyKey = 'fontFamily';
  static const String _fontSizeKey = 'fontSize';
  static const String _textColorKey = 'textColor';
  static const String _letterSpacingKey = 'letterSpacing';
  static const String _lineSpacingKey = 'lineSpacing';

  ThemeProvider()
      : _currentFontFamily = AppFont.openSans, // Default
        _currentFontSize = 16.0,             // Default
        _currentTextColor = Colors.black87,    // Default
        _currentLetterSpacing = 0.0,         // Default
        _currentLineSpacing = 0.0,         // Default
        _currentTheme = _buildTheme(
            AppFont.openSans, 16.0, Colors.black87, 0.0, 0.0) {
    _loadSettings(); // Load saved settings on initialization
  }

  // --- Getters ---
  ThemeData get currentTheme => _currentTheme;
  AppFont get currentFontFamily => _currentFontFamily;
  double get currentFontSize => _currentFontSize;
  Color get currentTextColor => _currentTextColor;
  double get currentLetterSpacing => _currentLetterSpacing;
  double get currentLineSpacing => _currentLineSpacing;

  // --- Helper to Build ThemeData ---
  static ThemeData _buildTheme(
      AppFont font, double fontSize, Color textColor, double letterSpacing, double lineSpacing) {
    TextTheme baseTextTheme;
    switch (font) {
      case AppFont.roboto:
        baseTextTheme = GoogleFonts.robotoTextTheme();
        break;
      case AppFont.lato:
        baseTextTheme = GoogleFonts.latoTextTheme();
        break;
      case AppFont.galindo:
        baseTextTheme = GoogleFonts.galindoTextTheme();
        break;
      case AppFont.openSans:
      default:
        baseTextTheme = GoogleFonts.openSansTextTheme();
        break;
    }

    // Apply custom styles to the base theme
    // We'll primarily focus on bodyMedium for this example
    final customTextTheme = baseTextTheme.copyWith(
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: fontSize,
        color: textColor,
        letterSpacing: letterSpacing,
        height: lineSpacing,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: fontSize,
        color: textColor,
        letterSpacing: letterSpacing,
        height: lineSpacing,
      ),
      // You can extend this to other TextStyles like headlineSmall, titleLarge etc.
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        color: textColor,
        letterSpacing: letterSpacing * 0.8,
        height: lineSpacing,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        // Use a slightly larger font size for titles relative to the base setting
        fontSize: fontSize * 1.2,
        color: textColor,
        letterSpacing: letterSpacing,
        height: lineSpacing,
      ),
    );

    return ThemeData(
      primarySwatch: Colors.teal, // Example primary color
      scaffoldBackgroundColor: Colors.white,
      textTheme: customTextTheme,
      // You can also theme other components based on these settings
      appBarTheme: AppBarTheme(
        titleTextStyle: customTextTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  void _rebuildThemeAndNotify() {
    _currentTheme = _buildTheme(
        _currentFontFamily, _currentFontSize, _currentTextColor, _currentLetterSpacing, _currentLineSpacing);
    notifyListeners();
  }

  // --- Update Methods (called from Settings UI) ---
  Future<void> updateFontFamily(AppFont newFontFamily) async {
    if (_currentFontFamily != newFontFamily) {
      _currentFontFamily = newFontFamily;
      _rebuildThemeAndNotify();
      await _saveFontFamily(newFontFamily);
    }
  }

  Future<void> updateFontSize(double newSize) async {
    if (_currentFontSize != newSize) {
      _currentFontSize = newSize;
      _rebuildThemeAndNotify();
      await _saveFontSize(newSize);
    }
  }

  Future<void> updateTextColor(Color newColor) async {
    if (_currentTextColor != newColor) {
      _currentTextColor = newColor;
      _rebuildThemeAndNotify();
      await _saveTextColor(newColor);
    }
  }

  Future<void> updateLetterSpacing(double newSpacing) async {
    if (_currentLetterSpacing != newSpacing) {
      _currentLetterSpacing = newSpacing;
      _rebuildThemeAndNotify();
      await _saveLetterSpacing(newSpacing);
    }
  }

  Future<void> updateLineSpacing(double newSpacing) async {
    if (_currentLineSpacing != newSpacing) {
      _currentLineSpacing = newSpacing;
      _rebuildThemeAndNotify();
      await _saveLineSpacing(newSpacing);
    }
  }

  // --- SharedPreferences Load Methods ---
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Font Family
    final String? savedFontFamily = prefs.getString(_fontFamilyKey);
    if (savedFontFamily != null) {
      _currentFontFamily = AppFont.values.firstWhere(
              (e) => e.toString() == savedFontFamily,
          orElse: () => AppFont.openSans);
    }

    // Load Font Size
    _currentFontSize = prefs.getDouble(_fontSizeKey) ?? _currentFontSize;

    // Load Text Color
    final int? savedTextColor = prefs.getInt(_textColorKey);
    if (savedTextColor != null) {
      _currentTextColor = Color(savedTextColor);
    }

    // Load Letter Spacing
    _currentLetterSpacing = prefs.getDouble(_letterSpacingKey) ?? _currentLetterSpacing;

    _rebuildThemeAndNotify(); // Rebuild theme with loaded values
  }

  // --- SharedPreferences Save Methods ---

  Future<void> _saveFontFamily(AppFont font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, font.toString());
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  Future<void> _saveTextColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_textColorKey, color.toARGB32());
  }

  Future<void> _saveLetterSpacing(double spacing) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_letterSpacingKey, spacing);
  }

  Future<void> _saveLineSpacing(double spacing) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lineSpacingKey, spacing);
  }
  // --- Reset to Defaults ---
  Future<void> resetToDefaults() async {
    _currentFontFamily = AppFont.openSans;
    _currentFontSize = 16.0;
    _currentTextColor = Colors.black87;
    _currentLetterSpacing = 0.0;
    _currentLineSpacing = 0.0;
    _rebuildThemeAndNotify();

    // Clear saved preferences for these settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fontFamilyKey);
    await prefs.remove(_fontSizeKey);
    await prefs.remove(_textColorKey);
    await prefs.remove(_letterSpacingKey);
    await prefs.remove(_lineSpacingKey);
  }
}
