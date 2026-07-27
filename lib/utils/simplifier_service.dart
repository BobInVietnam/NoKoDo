import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class SimplifierService {
  /// Takes a string and returns the simplified text version.
  Future<String?> simplifyText(String text);
}

class LocalSimplifierService implements SimplifierService {
  final http.Client client;
  final String? _token;

  LocalSimplifierService({http.Client? client, String? token})
      : client = client ?? http.Client(), _token = token;

  @override
  Future<String?> simplifyText(String text) async {
    // Handling localhost: Android Emulator uses 10.0.2.2, iOS/Others use 127.0.0.1
    // The Next.js API server runs on port 3000
    final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://127.0.0.1:3000';
    final uri = Uri.parse('$baseUrl/api/simplify');

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['simplifiedText'] as String?;
      } else {
        debugPrint('Simplifier Server Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Network Error connecting to Simplifier Server: $e');
      return null;
    }
  }
}

class MockSimplifierService implements SimplifierService {
  final Duration simulationDelay;
  final bool shouldFail;

  MockSimplifierService({
    this.simulationDelay = const Duration(seconds: 1),
    this.shouldFail = false,
  });

  @override
  Future<String?> simplifyText(String text) async {
    debugPrint("⚡ [MockSimplifierService]: Simplifying text: $text");
    await Future.delayed(simulationDelay);

    if (shouldFail) {
      debugPrint("❌ [MockSimplifierService]: Simulated failure.");
      return null;
    }

    return "Đây là câu văn đã được đơn giản hóa mẫu dành cho người dùng dễ đọc.";
  }
}
