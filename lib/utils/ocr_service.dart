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