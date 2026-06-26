class ConvertedFile {
  final int? id; // Nullable: Database handles auto-increment on insertion
  final String fileName;
  final String extractedText;
  final DateTime dateConverted;

  ConvertedFile({
    this.id,
    required this.fileName,
    required this.extractedText,
    required this.dateConverted,
  });

  List<String> get paragraphs {
    return extractedText
        .split('\n\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  // Map representation for Database insertions
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id, // Let SQLite handle auto-increment if id is null
      'name': fileName,
      'extracted_text': extractedText,
      'created_date': dateConverted.millisecondsSinceEpoch,
    };
  }

  // Deserialization mapping factory
  factory ConvertedFile.fromMap(Map<String, Object?> map) {
    return ConvertedFile(
      id: map['id'] as int?,
      fileName: map['name'] as String,
      extractedText: map['extracted_text'] as String,
      dateConverted: DateTime.fromMillisecondsSinceEpoch(map['created_date'] as int),
    );
  }
}