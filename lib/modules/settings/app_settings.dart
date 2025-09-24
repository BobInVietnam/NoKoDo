import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppFont { openSans, roboto, lato, galindo }

class AppSettings {
  static final AppSettings instance = AppSettings._internal();
  factory AppSettings() => instance;
  AppSettings._internal();

  // --- State ---
  String studentName = "Nguyễn Văn A";
  String studentClass = "1A";
  AppFont fontFamily = AppFont.openSans;
  double fontSize = 16.0;
  Color textColor = Colors.black87;
  double letterSpacing = 0.0;
  double lineSpacing = 1.2;

  // --- Keys ---
  static const _nameKey = 'studentName';
  static const _classKey = 'studentClass';
  static const _fontKey = 'fontFamily';
  static const _sizeKey = 'fontSize';
  static const _colorKey = 'textColor';
  static const _letterKey = 'letterSpacing';
  static const _lineKey = 'lineSpacing';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    studentName = prefs.getString(_nameKey) ?? studentName;
    studentClass = prefs.getString(_classKey) ?? studentClass;

    final fontStr = prefs.getString(_fontKey);
    if (fontStr != null) {
      fontFamily = AppFont.values.firstWhere(
        (f) => f.toString() == fontStr,
        orElse: () => AppFont.openSans,
      );
    }

    fontSize = prefs.getDouble(_sizeKey) ?? fontSize;
    letterSpacing = prefs.getDouble(_letterKey) ?? letterSpacing;
    lineSpacing = prefs.getDouble(_lineKey) ?? lineSpacing;

    final colorVal = prefs.getInt(_colorKey);
    if (colorVal != null) {
      textColor = Color(colorVal);
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, studentName);
    await prefs.setString(_classKey, studentClass);
    await prefs.setString(_fontKey, fontFamily.toString());
    await prefs.setDouble(_sizeKey, fontSize);
    await prefs.setDouble(_letterKey, letterSpacing);
    await prefs.setDouble(_lineKey, lineSpacing);
    await prefs.setInt(_colorKey, textColor.value);
  }

  Future<void> reset() async {
    studentName = "Chưa có";
    studentClass = "Chưa có";
    fontFamily = AppFont.openSans;
    fontSize = 16.0;
    textColor = Colors.black87;
    letterSpacing = 0.0;
    lineSpacing = 1.2;
    await save();
  }

  ThemeData buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.teal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.galindo(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        displayLarge: GoogleFonts.rowdies(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.teal[700],
        ),
        bodyMedium: GoogleFonts.poppins(fontSize: 20),
        displayMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
