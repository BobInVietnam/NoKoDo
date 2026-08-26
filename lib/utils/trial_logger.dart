import 'package:flutter/foundation.dart';
import '../models/trial_log.dart';
import '../models/event_log.dart';
import '../data/repository_manager.dart';

class TrialLogger {
  final RepoManager repoManager;

  int _sessionTrialIndex = 0;
  TrialLog? _currentTrial;
  int _currentTrialEventIndex = 0;
  final List<EventLog> _eventBuffer = [];

  TrialLogger(this.repoManager);

  TrialLog? get currentTrial => _currentTrial;
  int get currentTrialEventIndex => _currentTrialEventIndex;

  /// Flushes all pending event logs in the buffer to the remote server.
  Future<void> flushEvents() async {
    if (_eventBuffer.isEmpty) return;
    final eventsToSend = List<EventLog>.from(_eventBuffer);
    _eventBuffer.clear();
    debugPrint("TRIAL_LOGGER: Flushing ${eventsToSend.length} event log(s) to remote database.");
    await repoManager.onlineDatabase.sendEventLogsBatch(eventsToSend);
  }

  /// Starts a new trial for the current active session.
  /// Example trialId: S0001_20200101_1_02_r
  TrialLog? startTrial({
    required String trialType,
    required String trialCode,
    required String trialName,
    String? conditionId,
    String? conditionName,
    String? comment,
  }) {
    final session = repoManager.currentSession;
    if (session == null) {
      debugPrint("TRIAL_LOGGER: Cannot start trial. No active Session.");
      return null;
    }

    // Flush any pending events from previous trial
    flushEvents();

    _sessionTrialIndex++;
    final String paddedTrialIndex = _sessionTrialIndex.toString().padLeft(2, '0');
    final String trialId = '${session.sessionId}_${paddedTrialIndex}_$trialCode';

    _currentTrialEventIndex = 0;
    _currentTrial = TrialLog(
      sessionId: session.sessionId,
      trialId: trialId,
      trialType: trialType,
      trialStartTime: DateTime.now().millisecondsSinceEpoch,
      conditionId: conditionId,
      conditionName: conditionName,
      comment: comment,
      trialName: trialName,
    );

    debugPrint("TRIAL_LOGGER: Started trial $trialId ($trialType)");

    // Save locally
    repoManager.database.saveTrialLog(_currentTrial!);

    // Sync online
    repoManager.onlineDatabase.sendTrialLog(_currentTrial!);

    return _currentTrial;
  }

  /// Logs a single event within the active trial.
  /// Example eventId: S0001_20200101_1_02_r_009_highlight
  EventLog? logEvent({
    required String eventType,
    required String eventCode,
    required Map<String, dynamic> payload,
  }) {
    if (_currentTrial == null) {
      debugPrint("TRIAL_LOGGER: Cannot log event $eventType ($eventCode). No active Trial.");
      return null;
    }

    _currentTrialEventIndex++;
    final String paddedEventIndex = _currentTrialEventIndex.toString().padLeft(3, '0');
    final String eventId = '${_currentTrial!.trialId}_${paddedEventIndex}_$eventCode';

    final eventLog = EventLog(
      trialId: _currentTrial!.trialId,
      eventId: eventId,
      eventType: eventType,
      eventTimestamp: DateTime.now().millisecondsSinceEpoch,
      payloadJson: payload,
    );

    debugPrint("TRIAL_LOGGER: Logged event $eventId");

    // Save locally immediately
    repoManager.database.saveEventLog(eventLog);

    // Buffer for batch sending online
    _eventBuffer.add(eventLog);

    // If 10 events have accumulated, flush batch to server
    if (_eventBuffer.length >= 10) {
      flushEvents();
    }

    return eventLog;
  }

  /// Ends the active trial and updates validTrial/interrupted flags.
  Future<void> endTrial({
    bool validTrial = true,
    bool assistanceGiven = false,
    bool interrupted = false,
    bool technicalIssue = false,
    String? invalidReason,
    String? comment,
  }) async {
    if (_currentTrial == null) return;

    final trialToClose = _currentTrial!;
    _currentTrial = null; // Mark null to prevent double-ending

    // Log the END event first before closing
    _currentTrial = trialToClose; // temporarily restore to log END event
    logEvent(
      eventType: 'END',
      eventCode: 'end',
      payload: {},
    );
    _currentTrial = null;

    trialToClose.trialEndTime = DateTime.now().millisecondsSinceEpoch;
    trialToClose.validTrial = validTrial;
    trialToClose.assistanceGiven = assistanceGiven;
    trialToClose.interrupted = interrupted;
    trialToClose.technicalIssue = technicalIssue;
    if (invalidReason != null) trialToClose.invalidReason = invalidReason;
    if (comment != null) trialToClose.comment = comment;

    debugPrint("TRIAL_LOGGER: Ended trial ${trialToClose.trialId} at ${trialToClose.trialEndTime}");

    // Flush all accumulated event logs (including END event) to server
    await flushEvents();

    // Save updated trial locally
    await repoManager.database.saveTrialLog(trialToClose);

    // Sync updated trial online
    await repoManager.onlineDatabase.sendTrialLog(trialToClose);
  }
}
