class Unit {
  final String id;
  final String name;
  final String description;
  final int dateCreated; // epoch seconds, same as Lesson/Test
  final double progress; // 0.0 - 1.0

  const Unit({
    required this.id,
    required this.name,
    required this.description,
    required this.dateCreated,
    this.progress = 0.0,
  }) : assert(progress >= 0.0 && progress <= 1.0);

  factory Unit.fromMap(Map<String, Object?> map) {
    return Unit(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      dateCreated: map['dateCreated'] as int,
      progress: ((map['progress'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 1.0),
    );
  }
}