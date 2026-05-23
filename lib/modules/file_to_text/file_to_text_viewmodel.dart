
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
      final String? formattedResult = await ocrService.extractText(File(image.path));

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