import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UrlProvider {
  static final UrlProvider _instance = UrlProvider._internal();

  // Expose a public factory constructor that always returns the same instance
  factory UrlProvider() => _instance;

  String? _serverUrl;

  UrlProvider._internal() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _serverUrl = prefs.getString("server_url");
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("server_url", _serverUrl ?? "");
  }

  String get url {
    if (_serverUrl == null || _serverUrl == "") {
      debugPrint("No Url supplied. Fallback to default.");
      if (kIsWeb) return 'http://127.0.0.1:3000';
      return Platform.isAndroid
          ? 'http://10.0.2.2:3000'
          : 'http://127.0.0.1:3000';
    }
    debugPrint("Server URL: $_serverUrl");
    return _serverUrl!;
  }

  Future<void> setUrl(String newUrl) async {
    _serverUrl = newUrl;
    await _saveToPrefs();
  }
}
