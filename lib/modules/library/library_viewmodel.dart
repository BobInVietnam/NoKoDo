// viewmodels/library_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';

import '../../models/dictionary_entry.dart'; // Make sure to import your Dictionary model

class LibraryViewModel extends ChangeNotifier {
  final LocalDatabase localDatabase;

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

  // Getters
  List<ConvertedFile> get savedFiles => _savedFiles;
  bool get isLoading => _isLoading;
  bool get isLibraryEmpty => _savedFiles.isEmpty;

  // Dictionary Getters
  List<DictionaryEntry> get dictionaryEntries => _dictionaryEntries;
  bool get isDictLoading => _isDictLoading;
  String get searchQuery => _searchQuery;
  bool get hasMoreDictEntries => _hasMoreDictEntries;

  LibraryViewModel({required this.localDatabase}) {
    loadSavedFiles();
    loadInitialDictionary();
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
    if (_isDictLoading || !_hasMoreDictEntries) return;

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