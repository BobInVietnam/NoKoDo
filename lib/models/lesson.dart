import 'dart:convert';

class Lesson {
  final String id;
  final String name;
  final int type;
  final String description;
  final Map<String, dynamic> content; // Maps to Prisma Json layout
  final int difficulty;
  final int dateCreated; // Maps to Prisma BigInt Unix/Epoch timestamp integer
  final bool isDone;

  Lesson({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.content = const {},
    required this.difficulty,
    required this.dateCreated,
    required this.isDone
  });

  // Map representation for Database insertions
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'content': jsonEncode(content),
      'difficulty': difficulty,
      'dateCreated': dateCreated,
      'isDone': isDone
    };
  }

  // Deserialization mapping factory
  factory Lesson.fromMap(Map<String, Object?> map) {
    // Safely look up content from the map data boundary
    final rawContent = map['content'];
    Map<String, dynamic> parsedContent = const {};

    if (rawContent is String && rawContent.isNotEmpty) {
      parsedContent = jsonDecode(rawContent) as Map<String, dynamic>;
    } else if (rawContent is Map<String, dynamic>) {
      parsedContent = rawContent;
    }

    return Lesson(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as int,
      description: map['description'] as String,
      content: parsedContent,
      difficulty: map['difficulty'] as int,
      dateCreated: (map['dateCreated'] ?? map['date_created']) as int,
      isDone: (map['isDone'] ?? map['is_done'] ?? false) as bool,
    );
  }
}