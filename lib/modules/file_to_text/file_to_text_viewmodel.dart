
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodyslexia/models/converted_file.dart';

import '../../utils/ocr_service.dart';

class FileToTextViewModel extends ChangeNotifier {
  final OCRService ocrService; // Use the interface for flexibility

  FileToTextViewModel({required this.ocrService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ConvertedFile> _history = [];
  List<ConvertedFile> get history => _history;

  /// Processes an image from either the camera or gallery.
  /// Returns the formatted extracted text, or null if it fails/cancels.
  Future<String?> processImageFromSource(int sourceIndex) async {
    _setLoading(true);

    try {
      // 1. Pick the image using image_picker (Mocked here)
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: sourceIndex == 0 ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return null; // User cancelled

      // 2. Send to backend via ApiService (Mocked here)
      debugPrint("FILE_TO_TEXT_VIEWMODEL: Image file MIME type: ${image.mimeType}");
      final String? formattedResult = await ocrService.extractText(File(image.path));

      // TODO: Remove this redundancy
//       await Future.delayed(const Duration(seconds: 1));
//       String rawResult = """Chuyện kể rằng: vào đời Hùng Vương thứ 6, ở làng Gióng có hai vợ chồng ông lão chăm làm ăn và có tiếng là phúc đức. Hai ông bà ao ước có một đứa con. Một hôm bà ra đồng trông thấy một vết chân to quá, liền đặt bàn chân mình lên ướm thử để xem thua kém bao nhiêu.
// Không ngờ về nhà bà thụ thai và mười hai tháng sau sinh một thằng bé mặt mũi rất khôi ngô. Hai vợ chồng mừng lắm. Nhưng lạ thay! Ðứa trẻ cho đến khi lên ba vẫn không biết nói, biết cười, cũng chẳng biết đi, cứ đặt đâu thì nằm đấy.""";
//
//       // 3. Format text: use literal "\n" instead of going down a new line
//       String formattedResult = rawResult.replaceAll('\n', '\\n');

      // 4. Update History State
      _addToHistory(image.name, formattedResult!);

      return formattedResult;

    } catch (e) {
      debugPrint("Error processing image: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _addToHistory(String fileName, String text) {
    _history.add(ConvertedFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      extractedText: text,
      dateConverted: DateTime.now(),
    ));
    notifyListeners(); // Tells the UI to update the history board
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}