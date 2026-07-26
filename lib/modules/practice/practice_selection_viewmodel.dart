import 'package:flutter/material.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/data/repository_manager.dart';

enum SortOption { name, dateAdded, difficulty }

class PracticeSelectionViewModel extends ChangeNotifier {
  final RepoManager repoManager;

  List<Lesson> _allLessons = [];
  List<Lesson> _filteredLessons = [];
  bool _isLoading = false;
  SortOption _currentSortOption = SortOption.dateAdded;
  bool _sortAscending = true;
  String _searchQuery = '';

  PracticeSelectionViewModel({required this.repoManager}) {
    fetchLessons();
  }

  List<Lesson> get filteredLessons => _filteredLessons;
  bool get isLoading => _isLoading;
  SortOption get currentSortOption => _currentSortOption;
  bool get sortAscending => _sortAscending;
  String get searchQuery => _searchQuery;

  Future<void> fetchLessons() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allLessons = await repoManager.getLessonList();
      _filterAndSortLessons();
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
    _filteredLessons = _allLessons.where((lesson) {
      return lesson.name.toLowerCase().contains(query);
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
