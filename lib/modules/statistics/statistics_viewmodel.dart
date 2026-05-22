import 'package:flutter/cupertino.dart';

import '../../data/repository_manager.dart';

class StatisticsViewmodel extends ChangeNotifier {
  int _testNumber = 0;
  int _testFinishedNumber = 0;
  int _averageTestScore = 0;
  int _lessonNumber = 0;
  int _lessonFinishedNumber = 0;
  List<int> _activityCounts = [];
  Duration _totalUsageTimer = Duration(hours: 12, minutes: 35);
  bool _isLoading = true;

  int get testNumber => _testNumber;
  int get testFinishedNumber => _testFinishedNumber;
  int get averageTestScore => _averageTestScore;
  int get lessonNumber => _lessonNumber;
  int get lessonFinishedNumber => _lessonFinishedNumber;
  List<int> get activityCounts => _activityCounts;
  Duration get totalUsageTimer => _totalUsageTimer;
  bool get isLoading => _isLoading;
  RepoManager _repoManager;

  StatisticsViewmodel({required RepoManager repoManager}) : _repoManager = repoManager;

  Future<void> gatherStatisticData() async {
    _isLoading = true;
    notifyListeners(); // Show a loading spinner in the UI

    try {
      final rawData = await _repoManager.getRawStatistics();

      // Map raw data fields to your UI properties
      _testNumber = rawData['test_count'] ?? 0;
      _testFinishedNumber = rawData['completed_tests'] ?? 0;
      _averageTestScore = rawData['average_score'] ?? 0;
      _lessonNumber = rawData['total_lessons'] ?? 0;
      _lessonFinishedNumber = rawData['completed_lessons'] ?? 0;

    } catch (e) {
      debugPrint("Error loading statistics: $e");
      // Handle error state gracefully if needed
    } finally {
      _isLoading = false;
      notifyListeners(); // Tell the UI to draw the real data numbers
    }
  }

}