// viewmodels/library_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';

class LibraryViewModel extends ChangeNotifier {
  final LocalDatabase localDatabase;

  List<ConvertedFile> _savedFiles = [];
  bool _isLoading = false;

  // Getters
  List<ConvertedFile> get savedFiles => _savedFiles;
  bool get isLoading => _isLoading;
  bool get isLibraryEmpty => _savedFiles.isEmpty;

  LibraryViewModel({required this.localDatabase}) {
    loadSavedFiles();
  }

  /// Fetches the latest saved files snapshot array from the persistence database
  Future<void> loadSavedFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Assuming your LocalDatabase class implements a query selector method like this:
      // If your method name differs (e.g. getFiles()), adjust this call target accordingly.
      _savedFiles = await localDatabase.getAllConvertedFiles();
    } catch (e) {
      debugPrint("❌ [LibraryViewModel]: Failed to load database records: $e");
      _savedFiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a file record out of the database and triggers an in-memory collection layout filter
  Future<void> deleteFile(int fileId) async {
    try {
      // Assuming your LocalDatabase class has a deletion method contract:
      await localDatabase.deleteConvertedFile(fileId);

      // Update local memory list directly to provide snappy UI feedback
      _savedFiles.removeWhere((file) => file.id == fileId);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ [LibraryViewModel]: Deletion execution pipeline failed: $e");
    }
  }
}