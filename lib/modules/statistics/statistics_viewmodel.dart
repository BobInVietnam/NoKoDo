import 'package:flutter/material.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import '../../data/repository_manager.dart';

class StatisticsViewmodel extends ChangeNotifier {
  int _testNumber = 0;
  int _testFinishedNumber = 0;
  double _averageTestScore = 0;
  int _lessonNumber = 0;
  int _lessonFinishedNumber = 0;
  List<int> _activityCounts = [];
  bool _isLoading = true;
  bool _hasError = false;

  int get testNumber => _testNumber;
  int get testFinishedNumber => _testFinishedNumber;
  double get averageTestScore => _averageTestScore;
  int get lessonNumber => _lessonNumber;
  int get lessonFinishedNumber => _lessonFinishedNumber;
  List<int> get activityCounts => _activityCounts;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  final RepoManager _repoManager;
  final UsageTimeTracker _usageTimeTracker;

  StatisticsViewmodel({
    required RepoManager repoManager,
    required UsageTimeTracker usageTimeTracker,
  })  : _repoManager = repoManager,
        _usageTimeTracker = usageTimeTracker {
    _loadStatistics();
    _usageTimeTracker.addListener(_onTrackerTick);
  }

  String get formattedUsageTime => _usageTimeTracker.formattedDuration;

  void _onTrackerTick() {
    notifyListeners();
  }

  Future<void> _loadStatistics() async {
    try {
      await _repoManager.sendUsageTime(_usageTimeTracker.totalSecondsElapsed);
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      _hasError = true;
    }

    try {
      final Map<String, dynamic> data = await _repoManager.getRawStatistics();
      _testNumber = data['testNumber'] as int? ?? 0;
      _testFinishedNumber = data['testFinishedNumber'] as int? ?? 0;
      _averageTestScore = (data['averageTestScore'] as num?)?.toDouble() ?? 0.0;
      _lessonNumber = data['lessonNumber'] as int? ?? 0;
      _lessonFinishedNumber = data['lessonFinishedNumber'] as int? ?? 0;
      _activityCounts = List<int>.from(data['activityCounts'] as List? ?? []);

      // If the timer hasn't been set with a profile baseline yet, initialize it
      final totalUsageTime = data['totalUsageTime'] as int? ?? 0;
      _usageTimeTracker.resumeWithUserData(totalUsageTime);
    } catch (e) {
      debugPrint("❌ StatisticsViewModel Load Error: $e");
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _hasError = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _usageTimeTracker.removeListener(_onTrackerTick);
    super.dispose();
  }
}