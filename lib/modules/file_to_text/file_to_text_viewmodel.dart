
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';

import '../../utils/ocr_service.dart';

class FileToTextViewModel extends ChangeNotifier {
  final OCRService ocrService; // Use the interface for flexibility
  final LocalDatabase localDatabase;

  FileToTextViewModel({
    required this.ocrService,
    required this.localDatabase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<ConvertedFile> _history = [];
  List<ConvertedFile> get history => _history;

  /// Processes an image from either the camera or gallery.
  /// Returns the formatted extracted text, or null if it fails/cancels.
  Future<ConvertedFile?> processImageFromSource(int sourceIndex) async {
    setLoading(true);

    try {
      // 1. Pick the image using image_picker (Mocked here)
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: sourceIndex == 0 ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return null; // User cancelled

      // 2. Send to backend via ApiService (Mocked here)
      final String? formattedResult = await ocrService.extractText(File(image.path));

      final file = ConvertedFile(
          fileName: image.name,
          extractedText: formattedResult!,
          dateConverted: DateTime.now());
      final id = await localDatabase.insertConvertedFile(file);
      final fileWithId = await localDatabase.getConvertedFileById(id);
      _addToHistory(fileWithId!);

      return fileWithId;

    } catch (e) {
      debugPrint("Error processing image: $e");
      return null;
    } finally {
      setLoading(false);
    }
  }

  void updateHistory(ConvertedFile newFile) {
    var index = _history.indexWhere((file) => file.id == newFile.id);
    _history[index] = newFile;
    notifyListeners();
  }

  void _addToHistory(ConvertedFile file) {
    _history.add(file);
    notifyListeners(); // Tells the UI to update the history board
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}