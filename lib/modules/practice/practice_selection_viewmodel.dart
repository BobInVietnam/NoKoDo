import 'package:flutter/material.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/data/repository_manager.dart';

enum SortOption { name, dateAdded, difficulty }

class PracticeSelectionViewModel extends ChangeNotifier {
  final RepoManager repoManager;

  List<Lesson> _allLessons = [];
  List<Lesson> _filteredLessons = [];
  bool _showReading = true; // type 0
  bool _showFinding = true; // type 1
  bool _isLoading = false;
  SortOption _currentSortOption = SortOption.dateAdded;
  bool _sortAscending = true;
  String _searchQuery = '';
  final String unitId; // only lessons of this unit
  final int category;          // only lessons of this PracticeCategory (its index)
  final String categoryName;

  PracticeSelectionViewModel({
    required this.repoManager,
    required this.unitId,
    required this.category, required this.categoryName,
  }) {
    fetchLessons();
  }

  List<Lesson> get filteredLessons => _filteredLessons;
  bool get isLoading => _isLoading;
  bool get showReading => _showReading;
  bool get showFinding => _showFinding;
  SortOption get currentSortOption => _currentSortOption;
  bool get sortAscending => _sortAscending;
  String get searchQuery => _searchQuery;

  Future<void> fetchLessons() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allLessons = await repoManager.getLessonList(unitId, category);
      _filterAndSortLessons();
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setShowReading(bool value) {
    _showReading = value;
    _filterAndSortLessons();
  }

  void setShowFinding(bool value) {
    _showFinding = value;
    _filterAndSortLessons();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterAndSortLessons();
  }

  void setSortOption(SortOption option) {
    if (_currentSortOption == option) {
      _sortAscending = !_sortAscending;
    } else {
      _currentSortOption = option;
      _sortAscending = true;
    }
    _filterAndSortLessons();
  }

  void _filterAndSortLessons() {
    final query = _searchQuery.toLowerCase();

    // Filter
    _filteredLessons =
        _allLessons.where((lesson) {
          final matchesQuery = lesson.name.toLowerCase().contains(query);
          final matchesType =
              lesson.type == 0
                  ? _showReading
                  : lesson.type == 1
                  ? _showFinding
                  : true;
          return matchesQuery && matchesType;
        }).toList();

    // Sort
    _filteredLessons.sort((a, b) {
      int comparison;
      switch (_currentSortOption) {
        case SortOption.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortOption.dateAdded:
          comparison = a.dateCreated.compareTo(b.dateCreated);
          break;
        case SortOption.difficulty:
          comparison = a.difficulty.compareTo(b.difficulty);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    notifyListeners();
  }
}
