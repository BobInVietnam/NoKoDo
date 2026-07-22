import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/models/dictionary_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class LibraryViewModel extends ChangeNotifier {
  final LocalDatabase localDatabase;
  final RepoManager repoManager;

  List<ConvertedFile> _savedFiles = [];
  bool _isLoading = false;

  // --- Dictionary State Variables ---
  List<DictionaryEntry> _dictionaryEntries = [];
  bool _isDictLoading = false;
  String _searchQuery = "";

  // Pagination configs
  int _currentOffset = 0;
  final int _pageSize = 15;
  bool _hasMoreDictEntries = true;
  Timer? _searchDebounce;

  // Update State Variables
  bool _isDictUpdating = false;
  double _dictUpdateProgress = 0.0;
  String _dictUpdateStatus = "";

  // Getters
  List<ConvertedFile> get savedFiles => _savedFiles;
  bool get isLoading => _isLoading;
  bool get isLibraryEmpty => _savedFiles.isEmpty;

  // Dictionary Getters
  List<DictionaryEntry> get dictionaryEntries => _dictionaryEntries;
  bool get isDictLoading => _isDictLoading;
  String get searchQuery => _searchQuery;
  bool get hasMoreDictEntries => _hasMoreDictEntries;

  // Update Getters
  bool get isDictUpdating => _isDictUpdating;
  double get dictUpdateProgress => _dictUpdateProgress;
  String get dictUpdateStatus => _dictUpdateStatus;

  LibraryViewModel({required this.localDatabase, required this.repoManager}) {
    loadSavedFiles();
    _checkAndUpdateDictionary();
  }

  Future<void> _checkAndUpdateDictionary() async {
    final String localVersion = await localDatabase.getConfig('dictVersion') ?? '';
    final String remoteVersion = repoManager.remoteDictVersion ?? 'v1';

    debugPrint("DICTIONARY SYNC CHECK: local: '$localVersion', remote: '$remoteVersion'");
    if (localVersion != remoteVersion) {
      await _performDictionaryUpdate(remoteVersion);
    } else {
      loadInitialDictionary();
    }
  }

  Future<void> _performDictionaryUpdate(String remoteVersion) async {
    _isDictUpdating = true;
    _dictUpdateProgress = 0.0;
    _dictUpdateStatus = "Đang tải dữ liệu từ máy chủ...";
    notifyListeners();

    try {
      final Map<String, dynamic> data = await repoManager.onlineDatabase.getDictionaryData();
      final List<dynamic> entries = data['entries'] ?? [];
      final int total = entries.length;

      if (total > 0) {
        // Clear local cache dictionary table
        await localDatabase.clearDictionary();

        final docDir = await getApplicationDocumentsDirectory();

        for (int i = 0; i < total; i++) {
          final entry = entries[i] as Map<String, dynamic>;
          final String word = entry['word'] ?? '';
          final String description = entry['description'] ?? '';
          final String imageName = entry['imageName'] ?? entry['image_name'] ?? '';
          final String? imageData = entry['imageData'] ?? entry['image_data'];

          // If raw base64 data is supplied, decode and save to app document path
          if (imageData != null && imageData.isNotEmpty && imageName.isNotEmpty) {
            try {
              final File file = File(p.join(docDir.path, imageName));
              await file.writeAsBytes(base64Decode(imageData));
            } catch (e) {
              debugPrint("Error writing dictionary image file: $e");
            }
          }

          // Insert clean DictionaryEntry mapping
          await localDatabase.insertDictionaryEntry(DictionaryEntry(
            word: word,
            description: description,
            imageName: imageName,
          ));

          _dictUpdateProgress = (i + 1) / total;
          _dictUpdateStatus = "Đang lưu từ vựng: ${i + 1}/$total...";
          notifyListeners();
        }
      }

      // Overwrite version values
      await localDatabase.setConfig('dictVersion', remoteVersion);
      _dictUpdateStatus = "Hoàn thành!";
      
    } catch (e) {
      debugPrint("Error updating dictionary: $e");
      _dictUpdateStatus = "Lỗi cập nhật: $e";
    } finally {
      _isDictUpdating = false;
      notifyListeners();
      loadInitialDictionary();
    }
  }

  /// Fetches the latest saved files snapshot array from the persistence database
  Future<void> loadSavedFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
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
      await localDatabase.deleteConvertedFile(fileId);
      _savedFiles.removeWhere((file) => file.id == fileId);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ [LibraryViewModel]: Deletion execution pipeline failed: $e");
    }
  }

  // --- Core Dictionary Methods ---

  /// Initial load or reset for the dictionary entries
  Future<void> loadInitialDictionary() async {
    _isDictLoading = true;
    _currentOffset = 0;
    _hasMoreDictEntries = true;
    _dictionaryEntries.clear();
    notifyListeners();

    await _fetchDictionaryPage();
  }

  /// Handles real-time text input string mutations with a 300ms query debounce safety switch
  void updateSearchQuery(String query) {
    _searchQuery = query;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      loadInitialDictionary();
    });
  }

  /// Pulls the next incremental segment of dictionary values from persistence records
  Future<void> loadNextDictionaryPage() async {
    if (_isDictLoading || !_hasMoreDictEntries || _isDictUpdating) return;

    _isDictLoading = true;
    notifyListeners();

    await _fetchDictionaryPage();
  }

  Future<void> _fetchDictionaryPage() async {
    try {
      List<DictionaryEntry> fetchedPage;

      if (_searchQuery.trim().isEmpty) {
        fetchedPage = await localDatabase.getDictionaryEntriesPaginated(_pageSize, _currentOffset);
      } else {
        fetchedPage = await localDatabase.searchDictionaryWords(_searchQuery, _pageSize, _currentOffset);
      }

      if (fetchedPage.length < _pageSize) {
        _hasMoreDictEntries = false;
      }

      _dictionaryEntries.addAll(fetchedPage);
      _currentOffset += fetchedPage.length;
    } catch (e) {
      debugPrint("❌ [LibraryViewModel]: Dictionary fetch processing issue: $e");
    } finally {
      _isDictLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}