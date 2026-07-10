class Student {
  final String uid;
  final String firstname;
  final String lastname;
  final int classid;
  int totalTime;
  int totalLessonDone;
  int totalExamDone;
  double averageScore;

  Student({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.classid,
    required this.totalTime,
    required this.totalExamDone,
    required this.totalLessonDone,
    required this.averageScore
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'classid': classid,
      'totalTime': totalTime,
      'totalExamDone': totalExamDone,
      'totalLessonDone': totalLessonDone,
      'averageScore': averageScore,
    };
  }

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      uid: map['uid'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      classid: map['classid'] as int,
      totalTime: map['totalTime'] as int,
      totalExamDone: map['totalExamDone'] as int,
      totalLessonDone: map['totalLessonDone'] as int,
      averageScore: (map['averageScore'] as num?)?.toDouble() ?? 0.0
    );
  }
}