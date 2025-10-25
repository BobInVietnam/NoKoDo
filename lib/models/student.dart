class Student {
  final String? uid;
  final String? firstname;
  final String? lastname;

  Student({
    this.uid,
    this.firstname,
    this.lastname
  });

  Map<String, Object?> toMap() {
    return {'uid': uid, 'firstname': firstname, 'lastname': lastname};
  }
}