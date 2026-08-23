import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/repository_manager.dart';

class UsageTimeTracker extends ChangeNotifier with WidgetsBindingObserver {
  final RepoManager _repoManager;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _uiTimer;

  // Track total accrued time across past states if you need to add to an existing database baseline
  int _previouslyAccruedSeconds = -1;

  UsageTimeTracker({required RepoManager repoManager}) : _repoManager = repoManager {
    // 1. Register this class into the global system lifecycle observer registry
    WidgetsBinding.instance.addObserver(this);
    _resumeTracking();
  }

  /// Total elapsed active usage time in seconds
  int get totalSecondsElapsed => _previouslyAccruedSeconds + _stopwatch.elapsed.inSeconds;

  void resumeWithUserData(int accruedSeconds) {
    _stopwatch.reset();
    _previouslyAccruedSeconds = -1;
    debugPrint("Resuming tracking with accrued seconds = $accruedSeconds");
    _previouslyAccruedSeconds = accruedSeconds;
    _resumeTracking();
    notifyListeners();
  }

  /// Returns a cleanly formatted string layout (HH:MM:SS) of the active session time
  String get formattedDuration {
    final duration = Duration(seconds: totalSecondsElapsed);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// System-triggered event hook that listens to global app state alterations
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      // App minimized, closed, or detached -> Pause background timing leak and mark session complete
      _pauseTracking();
    } else if (state == AppLifecycleState.resumed && _previouslyAccruedSeconds >= 0) {
      // App brought back to foreground focus -> Restart tracking seamlessly
      _resumeTracking();
    }

    if (state == AppLifecycleState.detached) {
      debugPrint("USAGE_TRACKER: Saving current session...");
      _repoManager.completeCurrentSession();
    }
  }

  void _resumeTracking() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();

      // Start a background periodic ticker loop to notify UI listeners every second
      _uiTimer?.cancel(); // Safety cleanup
      _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        debugPrint("USAGE_TRACKER: $totalSecondsElapsed");
        notifyListeners(); // Redraws any consumers watching this tracker class
      });
    }
  }

  Future<void> _pauseTracking() async {
    _stopwatch.stop();
    _uiTimer?.cancel();
    notifyListeners(); // Final broadcast to ensure data synchronicity
    
    // Trigger background synchronization with the web server
    await _repoManager.sendUsageTime(totalSecondsElapsed);
  }

  /// Optional hook: Use this to clear or increment baseline totals when saving to an external database
  Future<void> resetTracker() async {
    await _pauseTracking();
    _stopwatch.reset();
    _previouslyAccruedSeconds = -1;
    notifyListeners();
  }

  @override
  void dispose() {
    // Crucial: Always unregister global observers to avoid memory tracking leaks
    WidgetsBinding.instance.removeObserver(this);
    _uiTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}