class Student {
  final String uid;
  final String firstname;
  final String lastname;
  final String classid;
  int totalTime;

  Student({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.classid,
    required this.totalTime,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'classid': classid,
      'totalTime': totalTime,
    };
  }

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      uid: map['uid'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      classid: map['classid'] as String,
      totalTime: map['totalTime'] as int,
    );
  }
}