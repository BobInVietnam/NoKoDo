import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

abstract class OCRService {
  /// Takes a file and returns the full extracted text as a single string.
  Future<String?> extractText(File imageFile);
}

class LocalOCRService implements OCRService {
  final http.Client client;

  LocalOCRService({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<String?> extractText(File imageFile) async {
    // Handling localhost: Android Emulator uses 10.0.2.2, iOS uses 127.0.0.1
    final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
    final uri = Uri.parse('$baseUrl/predict');

    // 1. Create Multipart Request
    var request = http.MultipartRequest('POST', uri);

    // 1. Manually resolve the MIME type
    final String? mimeType = lookupMimeType(imageFile.path); // Returns e.g., 'image/jpeg'
    debugPrint("FILE_TO_TEXT: mime type = ${mimeType}");

    // 2. Parse into type and subtype
    final contentType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('image', 'jpeg'); // Fallback to jpeg if detection fails

    // 3. Attach the file with the explicit Content-Type header
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: contentType, // This fixes the server-side rejection
      ),
    );

    try {
      // 3. Send and get response
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // 4. Parse the JSON response
        // The Python server returns {"text_lines": ["line1", "line2"], ...}
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> lines = data['text_lines'];

        // 5. Join lines into a single content string
        return lines.join('\n');
      } else {
        debugPrint('OCR Server Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Network Error connecting to OCR Server: $e');
      return null;
    }
  }
}

class MockOCRService implements OCRService {
  /// Simulates network or processing latency (e.g., waiting for heavy ML inference)
  final Duration simulationDelay;

  /// Allows you to force a simulated network or server failure for testing error states
  final bool shouldFail;

  MockOCRService({
    this.simulationDelay = const Duration(seconds: 2),
    this.shouldFail = false,
  });

  @override
  Future<String?> extractText(File imageFile) async {
    debugPrint("⚡ [MockOCRService]: Processing file: ${imageFile.path}");

    // 1. Simulate the time it takes to upload and run PaddleX/VietOCR pipeline
    await Future.delayed(simulationDelay);

    // 2. Simulate server/network error if configured
    if (shouldFail) {
      debugPrint("❌ [MockOCRService]: Simulated server failure (500 internal error)");
      return null;
    }

    // 3. Return a realistic, multi-line Vietnamese sample string matching your production dataset
    final String mockExtractedText =
        "Chuyện kể rằng: vào đời Hùng Vương thứ 6, ở làng Gióng có hai vợ chồng ông lão chăm làm ăn và có tiếng là phúc đức. "
        "Hai ông bà ao ước có một đứa con. Một hôm bà ra đồng trông thấy một vết chân to quá, liền đặt bàn chân mình lên ướm thử để xem thua kém bao nhiêu.\n"
        "Không ngờ về nhà bà thụ thai và mười hai tháng sau sinh một thằng bé mặt mũi rất khôi ngô. Hai vợ chồng mừng lắm. "
        "Nhưng lạ thay! Ðứa trẻ cho đến khi lên ba vẫn không biết nói, biết cười, cũng chẳng biết đi, cứ đặt đâu thì nằm đấy.";

    debugPrint("✅ [MockOCRService]: Successfully returned mock text parsing matrix.");
    return mockExtractedText;
  }
}

