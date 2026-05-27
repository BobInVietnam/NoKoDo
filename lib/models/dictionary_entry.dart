class DictionaryEntry {
  final int? id; // Nullable: Database handles auto-increment on insertion
  final String word;
  final String description;
  final String imageName; // Stores the file name asset reference (e.g., 'ball.jpg')

  DictionaryEntry({
    this.id,
    required this.word,
    required this.description,
    required this.imageName,
  });

  // Map representation for Database insertions
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id, // Let SQLite handle auto-increment if id is null
      'word': word,
      'description': description,
      'image_name': imageName,
    };
  }

  // Deserialization mapping factory
  factory DictionaryEntry.fromMap(Map<String, Object?> map) {
    return DictionaryEntry(
      id: map['id'] as int?,
      word: map['word'] as String,
      description: map['description'] as String,
      imageName: map['image_name'] as String,
    );
  }
}