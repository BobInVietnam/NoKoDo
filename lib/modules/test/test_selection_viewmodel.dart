import 'package:flutter/material.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/data/repository_manager.dart';

enum SortOption { name, dateCreated, difficulty }

class TestSelectionViewModel extends ChangeNotifier {
  final RepoManager _repoManager;
  final TextEditingController searchController = TextEditingController();

  List<TestInfo> _allTests = [];
  List<TestInfo> _filteredTests = [];
  bool _isLoading = true;

  SortOption _currentSortOption = SortOption.dateCreated;
  bool _sortAscending = true;

  List<TestInfo> get filteredTests => _filteredTests;
  bool get isLoading => _isLoading;
  SortOption get currentSortOption => _currentSortOption;
  bool get sortAscending => _sortAscending;

  TestSelectionViewModel({required RepoManager repoManager}) : _repoManager = repoManager {
    _loadData();
    searchController.addListener(_filterTests);
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allTests = await _repoManager.getTestList();
      _filterTests();
    } catch (e) {
      debugPrint("Error loading tests: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshData() {
    _loadData();
  }

  void _filterTests() {
    final query = searchController.text.toLowerCase();
    _filteredTests = _allTests.where((testInfo) {
      return testInfo.name.toLowerCase().contains(query);
    }).toList();
    _sortTests();
    notifyListeners();
  }

  void _sortTests() {
    _filteredTests.sort((a, b) {
      int comparison;
      switch (_currentSortOption) {
        case SortOption.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortOption.dateCreated:
          comparison = a.dateCreated.compareTo(b.dateCreated);
          break;
        case SortOption.difficulty:
          comparison = a.difficulty.compareTo(b.difficulty);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });
  }

  void setSortOption(SortOption option) {
    if (_currentSortOption == option) {
      _sortAscending = !_sortAscending;
    } else {
      _currentSortOption = option;
      _sortAscending = true;
    }
    _sortTests();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterTests);
    searchController.dispose();
    super.dispose();
  }
}
