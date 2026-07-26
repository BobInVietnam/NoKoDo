import 'package:flutter/material.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/data/repository_manager.dart';

class TestDetailViewModel extends ChangeNotifier {
  final Test test;
  final RepoManager _repoManager;

  TestDetailViewModel({required this.test, required RepoManager repoManager})
      : _repoManager = repoManager;

  String formatTimestamp(int timestampMs) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return "$hour:$minute - $day/$month/$year";
  }

  String formatDuration(int startTimeMs, int endTimeMs) {
    final durationMs = endTimeMs - startTimeMs;
    final totalSeconds = (durationMs / 1000).round();
    if (totalSeconds < 60) {
      return "$totalSeconds giây";
    }
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "$minutes phút $seconds giây";
  }

  double? get maxScore {
    if (test.studentStatuses.isEmpty) return null;
    return test.studentStatuses.map((s) => s.score).reduce((a, b) => a > b ? a : b);
  }

  Future<TestSession> startNewSession() async {
    final studentId = _repoManager.currentStudent!.uid;
    final TestSession testSession = TestSession(
      testId: test.id,
      studentId: studentId,
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().millisecondsSinceEpoch,
      score: 0,
    );
    await _repoManager.sendTestSessionStatus(testSession);
    return testSession;
  }
}
