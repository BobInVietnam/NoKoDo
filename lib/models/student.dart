import 'dart:convert';

class Student {
  final String uid;
  final int sid;
  final String firstname;
  final String lastname;
  final String classid;
  Map<String, dynamic> settings;
  int totalTime;

  Student({
    required this.uid,
    required this.sid,
    required this.firstname,
    required this.lastname,
    required this.classid,
    required this.settings,
    required this.totalTime,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'sid': sid,
      'firstname': firstname,
      'lastname': lastname,
      'classid': classid,
      'totalTime': totalTime,
      'settings': settings
    };
  }

  String getFormattedSid() {
    return "S${sid.toString().padLeft(4, '0')}";
  }

  factory Student.fromMap(Map<String, Object?> map) {
    Map<String, dynamic> parsedSettings = {};
    if (map['settings'] is Map) {
      parsedSettings = Map<String, dynamic>.from(map['settings'] as Map);
    } else if (map['settings'] is String && (map['settings'] as String).isNotEmpty) {
      try {
        parsedSettings = Map<String, dynamic>.from(jsonDecode(map['settings'] as String));
      } catch (_) {}
    }

    return Student(
      uid: map['uid'] as String,
      sid: (map['sid'] ?? map['s_id'] ?? 0) as int,
      firstname: (map['firstname'] ?? map['first_name'] ?? '') as String,
      lastname: (map['lastname'] ?? map['last_name'] ?? '') as String,
      classid: (map['classid'] ?? map['class_id'] ?? '') as String,
      totalTime: (map['totalTime'] ?? map['total_time'] ?? 0) as int,
      settings: parsedSettings,
    );
  }
}