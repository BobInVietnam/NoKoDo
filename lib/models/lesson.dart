import 'dart:convert';

class Lesson {
  final int? id; // Nullable: Database handles auto-increment on insertion
  final String name;
  final int type;
  final String description;
  final Map<String, dynamic> content; // Maps to Prisma Json layout
  final int difficulty;
  final int dateCreated; // Maps to Prisma BigInt Unix/Epoch timestamp integer
  final bool isDone;

  Lesson({
    this.id,
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
      // Serializes dynamic maps into a flat JSON string value for safe SQL storage
      'content': jsonEncode(content),
      'difficulty': difficulty,
      'date_created': dateCreated,
      'is_done': isDone
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
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as int,
      description: map['description'] as String,
      content: parsedContent,
      difficulty: map['difficulty'] as int,
      dateCreated: (map['date_created'] ?? map['dateCreated']) as int,
      isDone: (map['is_done'] ?? map['isDone'] ?? false) as bool,
    );
  }
}