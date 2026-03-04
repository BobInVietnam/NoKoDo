import 'package:flutter/cupertino.dart';

class StatisticsUpdater extends ChangeNotifier {
  int _testNumber = 0;
  int _testFinishedNumber = 0;
  int _averateTestScore = 0;
  int _lessonNumber = 0;
  int _lessonFinishedNumber = 0;
  List<int> _activityCounts = [];

  StatisticsUpdater();

  Future<void> gatherStatisticData() async {
    
  }

}