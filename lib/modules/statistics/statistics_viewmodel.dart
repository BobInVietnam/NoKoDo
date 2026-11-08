import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
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
    required this._repoManager,
    required this._usageTimeTracker,
  }) {
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

  String _escapeCsv(String? input) {
    if (input == null) return '""';
    final escaped = input.replaceAll('"', '""');
    return '"$escaped"';
  }

  Future<List<String>> exportCsvFiles() async {
    final localDb = _repoManager.database;

    final sessions = await localDb.getAllSessions();
    final trials = await localDb.getAllTrialLogs();
    final events = await localDb.getAllEventLogs();

    // 1. Sessions CSV
    final sessionCsvContent = StringBuffer();
    sessionCsvContent.writeln(
      'sessionId,studentId,sessionStartTime,sessionEndTime,examinerId,siteId,device,screenWidth,screenHeight,completed',
    );
    for (final s in sessions) {
      sessionCsvContent.writeln(
        '${_escapeCsv(s.sessionId)},${_escapeCsv(s.studentId)},${s.sessionStartTime},${s.sessionEndTime ?? ''},${_escapeCsv(s.examinerId)},${_escapeCsv(s.siteId)},${_escapeCsv(s.device)},${s.screenWidth},${s.screenHeight},${s.completed}',
      );
    }

    // 2. Trials CSV
    final trialCsvContent = StringBuffer();
    trialCsvContent.writeln(
      'sessionId,trialId,trialType,trialStartTime,trialEndTime,conditionId,conditionName,comment,validTrial,assistanceGiven,interrupted,technicalIssue,invalidReason',
    );
    for (final t in trials) {
      trialCsvContent.writeln(
        '${_escapeCsv(t.sessionId)},${_escapeCsv(t.trialId)},${_escapeCsv(t.trialType)},${t.trialStartTime},${t.trialEndTime ?? ''},${_escapeCsv(t.conditionId)},${_escapeCsv(t.conditionName)},${_escapeCsv(t.comment)},${t.validTrial},${t.assistanceGiven},${t.interrupted},${t.technicalIssue},${_escapeCsv(t.invalidReason)}',
      );
    }

    // 3. Events CSV
    final eventCsvContent = StringBuffer();
    eventCsvContent.writeln(
      'trialId,eventId,eventType,eventTimestamp,payloadJson',
    );
    for (final e in events) {
      final payloadJsonStr = jsonEncode(e.payloadJson);
      eventCsvContent.writeln(
        '${_escapeCsv(e.trialId)},${_escapeCsv(e.eventId)},${_escapeCsv(e.eventType)},${e.eventTimestamp},${_escapeCsv(payloadJsonStr)}',
      );
    }

    final sessionBytes = Uint8List.fromList(
      utf8.encode(sessionCsvContent.toString()),
    );
    final trialBytes = Uint8List.fromList(
      utf8.encode(trialCsvContent.toString()),
    );
    final eventBytes = Uint8List.fromList(
      utf8.encode(eventCsvContent.toString()),
    );

    final sessionPath = await FileSaver.instance.saveFile(
      name: 'sessions_export.csv',
      bytes: sessionBytes,
      mimeType: MimeType.csv,
    );

    final trialPath = await FileSaver.instance.saveFile(
      name: 'trials_export.csv',
      bytes: trialBytes,
      mimeType: MimeType.csv,
    );

    final eventPath = await FileSaver.instance.saveFile(
      name: 'events_export.csv',
      bytes: eventBytes,
      mimeType: MimeType.csv,
    );

    return [sessionPath, trialPath, eventPath];
  }

  @override
  void dispose() {
    _usageTimeTracker.removeListener(_onTrackerTick);
    super.dispose();
  }
}
