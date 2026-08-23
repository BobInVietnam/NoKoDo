class Session {
  final String studentId;
  final String sessionId;
  final DateTime sessionStartTime;
  DateTime? sessionEndTime;
  final String? examinerId;
  final String? siteId;
  final String device;
  final double screenWidth;
  final double screenHeight;
  bool completed;

  Session({
    required this.studentId,
    required this.sessionId,
    required this.sessionStartTime,
    this.sessionEndTime,
    this.examinerId,
    this.siteId,
    required this.device,
    required this.screenWidth,
    required this.screenHeight,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'sessionId': sessionId,
      'sessionStartTime': sessionStartTime.toIso8601String(),
      'sessionEndTime': sessionEndTime?.toIso8601String(),
      'examinerId': examinerId,
      'siteId': siteId,
      'device': device,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'completed': completed ? 1 : 0,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      studentId: map['studentId'] as String,
      sessionId: map['sessionId'] as String,
      sessionStartTime: DateTime.parse(map['sessionStartTime'] as String),
      sessionEndTime: map['sessionEndTime'] != null ? DateTime.parse(map['sessionEndTime'] as String) : null,
      examinerId: map['examinerId'] as String?,
      siteId: map['siteId'] as String?,
      device: map['device'] as String,
      screenWidth: (map['screenWidth'] as num).toDouble(),
      screenHeight: (map['screenHeight'] as num).toDouble(),
      completed: map['completed'] == 1 || map['completed'] == true,
    );
  }
}