import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _db;

  /// Khởi tạo hoặc lấy database
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'library_words.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE words(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT UNIQUE
          )
        ''');
      },
    );
  }

  static Future<void> addWord(String word) async {
    if (word.trim().isEmpty) return;
    final db = await database;
    await db.insert('words', {
      'word': word.trim(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<String>> getWords() async {
    final db = await database;
    final result = await db.query('words', orderBy: 'id DESC');
    return result.map((row) => row['word'] as String).toList();
  }

  static Future<void> deleteWord(String word) async {
    final db = await database;
    await db.delete('words', where: 'word = ?', whereArgs: [word]);
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('words');
  }
}
