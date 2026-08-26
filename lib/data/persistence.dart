import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/converted_file.dart';
import '../models/dictionary_entry.dart';
import '../models/lesson.dart';
import '../models/session.dart';
import '../models/trial_log.dart';
import '../models/event_log.dart';

abstract class LocalDatabase extends ChangeNotifier{
  Future<void> test();
  Future<int> insertConvertedFile(ConvertedFile file);
  Future<List<ConvertedFile>> getAllConvertedFiles();
  Future<ConvertedFile?> getConvertedFileById(int id);
  Future<int> deleteConvertedFile(int id);
  /// Inserts a new dictionary entry and returns its auto-generated ID.
  Future<int> insertDictionaryEntry(DictionaryEntry entry);
  /// Fetches a paginated slice of all entries in the dictionary.
  Future<List<DictionaryEntry>> getDictionaryEntriesPaginated(int limit, int offset);
  /// Searches for words matching the query with pagination.
  Future<List<DictionaryEntry>> searchDictionaryWords(String query, int limit, int offset);
  /// Looks up a precise singular word entry (Returns null if not found).
  Future<DictionaryEntry?> getDictionaryEntryByWord(String word);
  /// Clears all entries from the dictionary table.
  Future<void> clearDictionary();
  /// Saves a key-value configuration pair.
  Future<void> setConfig(String key, String value);
  /// Retrieves a value by key (Returns null if not found).
  Future<String?> getConfig(String key);
  /// Inserts a new highlighted word/phrase and returns its ID.
  Future<int> insertHighlight(String text);
  /// Retrieves all highlighted phrases saved on the local device.
  Future<List<String>> getAllHighlights();
  /// Removes a highlighted phrase from the local database.
  Future<void> deleteHighlight(String text);
  /// Saves the full set of lessons in the local database.
  Future<void> saveLessons(List<Lesson> lessons);
  /// Retrieves all lessons from the local database.
  Future<List<Lesson>> getAllLessons();
  /// Saves or updates a Session locally with ConflictAlgorithm.replace.
  Future<void> saveSession(Session session);
  /// Retrieves a Session by sessionId.
  Future<Session?> getSessionById(String sessionId);
  /// Retrieves all Sessions stored locally.
  Future<List<Session>> getAllSessions();
  /// Saves or updates a TrialLog locally.
  Future<void> saveTrialLog(TrialLog trial);
  /// Retrieves a TrialLog by trialId.
  Future<TrialLog?> getTrialLogById(String trialId);
  /// Retrieves all TrialLogs for a specific session.
  Future<List<TrialLog>> getTrialLogsBySession(String sessionId);
  /// Retrieves all TrialLogs stored locally.
  Future<List<TrialLog>> getAllTrialLogs();
  /// Saves or updates an EventLog locally.
  Future<void> saveEventLog(EventLog event);
  /// Retrieves all EventLogs for a specific trial.
  Future<List<EventLog>> getEventLogsByTrial(String trialId);
  /// Retrieves all EventLogs stored locally.
  Future<List<EventLog>> getAllEventLogs();
}

class TestLocalDatabase extends LocalDatabase {
  static final TestLocalDatabase _instance = TestLocalDatabase._internal();
  factory TestLocalDatabase() => _instance;
  TestLocalDatabase._internal();

  Database? _database;
  static const String _dbFileName = 'userdata.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb(false);
    return _database!;
  }

  Future<Database> _initDb(bool overwrite) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbFileName);

    if (await databaseExists(path)) {
      if (overwrite) {
        await deleteDatabase(path);
      }
    }
    onCreate(Database db, int version) async {
      debugPrint("DATABASE: Loading database...");
      await db.execute('PRAGMA foreign_keys = ON');
    }
    final db = await openDatabase(path, version: 1, onCreate: onCreate);
    await db.execute("CREATE TABLE IF NOT EXISTS Lesson (id TEXT PRIMARY KEY, name TEXT, type INTEGER, description TEXT, content TEXT, difficulty INTEGER, dateCreated INTEGER, isDone INTEGER)");
    await db.execute("CREATE TABLE IF NOT EXISTS SystemConfig (key TEXT PRIMARY KEY, value TEXT)");
    await db.execute("CREATE TABLE IF NOT EXISTS Highlight (id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT UNIQUE)");
    await db.execute("CREATE TABLE IF NOT EXISTS Session (sessionId TEXT PRIMARY KEY, studentId TEXT, sessionStartTime TEXT, sessionEndTime TEXT, examinerId TEXT, siteId TEXT, device TEXT, screenWidth REAL, screenHeight REAL, appVersion TEXT, webVersion TEXT, completed INTEGER)");
    await db.execute("CREATE TABLE IF NOT EXISTS TrialLog (sessionId TEXT, trialId TEXT PRIMARY KEY, trialType TEXT, trialName TEXT, trialStartTime INTEGER, trialEndTime INTEGER, conditionId TEXT, conditionName TEXT, comment TEXT, validTrial INTEGER, assistanceGiven INTEGER, interrupted INTEGER, technicalIssue INTEGER, invalidReason TEXT)");
    await db.execute("CREATE TABLE IF NOT EXISTS EventLog (trialId TEXT, eventId TEXT PRIMARY KEY, eventType TEXT, eventTimestamp INTEGER, payloadJson TEXT)");
    return db;
  }

// 1. INSERT A CONVERTED FILE RECORD
  @override
  Future<int> insertConvertedFile(ConvertedFile file) async {
    final db = await database;
    // Inserts record and returns the auto-incremented primary key ID
    return await db.insert(
      'ConvertedFile',
      file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> test() async {
    final db = await database;
    debugPrint("DATABASE: Online!");
  }

  // 2. QUERY ALL CONVERTED FILES
  @override
  Future<List<ConvertedFile>> getAllConvertedFiles() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('ConvertedFile');

    return List.generate(maps.length, (i) {
      return ConvertedFile.fromMap(maps[i]);
    });
  }

  @override
  Future<ConvertedFile?> getConvertedFileById(int id) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'ConvertedFile',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Optimizes execution since IDs are unique
    );

    if (maps.isEmpty) return null;
    return ConvertedFile.fromMap(maps.first);
  }

  // 3. DELETE A CONVERTED FILE RECORD BY INT ID
  @override
  Future<int> deleteConvertedFile(int id) async {
    final db = await database;
    return await db.delete(
      'ConvertedFile',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> insertDictionaryEntry(DictionaryEntry entry) async {
    final db = await database;
    return await db.insert(
      'DictionaryEntry',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<DictionaryEntry>> getDictionaryEntriesPaginated(int limit, int offset) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'DictionaryEntry',
      limit: limit,
      offset: offset,
      orderBy: 'word ASC', // Keeps listings strictly alphabetical
    );
    return List.generate(maps.length, (i) => DictionaryEntry.fromMap(maps[i]));
  }

  @override
  Future<DictionaryEntry?> getDictionaryEntryByWord(String word) async {
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(
      'DictionaryEntry',
      where: 'word = ?',
      whereArgs: [word.trim()],
      limit: 1, // Ends index query parsing immediately once matching node is located
    );

    if (maps.isEmpty) return null;
    return DictionaryEntry.fromMap(maps.first);
  }

  @override
  Future<List<DictionaryEntry>> searchDictionaryWords(String query, int limit, int offset) async {
    final db = await database;
    if (query.trim().isEmpty) return [];

    final List<Map<String, Object?>> maps = await db.query(
      'DictionaryEntry',
      where: 'word LIKE ?',
      // Using '%' wildcards allows matching prefixes, suffixes, or sub-substring fragments
      whereArgs: ['%${query.trim()}%'],
      limit: limit,
      offset: offset,
      orderBy: 'word ASC',
    );

    return List.generate(maps.length, (i) => DictionaryEntry.fromMap(maps[i]));
  }

  @override
  Future<void> clearDictionary() async {
    final db = await database;
    await db.delete('DictionaryEntry');
  }

  @override
  Future<void> setConfig(String key, String value) async {
    final db = await database;
    await db.insert(
      'SystemConfig',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<String?> getConfig(String key) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'SystemConfig',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String?;
  }

  @override
  Future<int> insertHighlight(String text) async {
    final db = await database;
    return await db.insert(
      'Highlight',
      {'text': text},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<String>> getAllHighlights() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('Highlight');
    return List.generate(maps.length, (i) => maps[i]['text'] as String);
  }

  @override
  Future<void> deleteHighlight(String text) async {
    final db = await database;
    await db.delete(
      'Highlight',
      where: 'text = ?',
      whereArgs: [text],
    );
  }

  @override
  Future<void> saveLessons(List<Lesson> lessons) async {
    final db = await database;
    final batch = db.batch();
    for (var lesson in lessons) {
      batch.insert(
        'Lesson',
        lesson.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Lesson>> getAllLessons() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('Lesson');
    return List.generate(maps.length, (i) => Lesson.fromMap(maps[i]));
  }

  @override
  Future<void> saveSession(Session session) async {
    final db = await database;
    await db.insert(
      'Session',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("DATABASE: Saved/replaced session ${session.sessionId} (completed: ${session.completed})");
  }

  @override
  Future<Session?> getSessionById(String sessionId) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'Session',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Session.fromMap(maps.first);
  }

  @override
  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('Session');
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  @override
  Future<void> saveTrialLog(TrialLog trial) async {
    final db = await database;
    await db.insert(
      'TrialLog',
      trial.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("DATABASE: Saved/replaced TrialLog ${trial.trialId}");
  }

  @override
  Future<TrialLog?> getTrialLogById(String trialId) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'TrialLog',
      where: 'trialId = ?',
      whereArgs: [trialId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return TrialLog.fromMap(maps.first);
  }

  @override
  Future<List<TrialLog>> getTrialLogsBySession(String sessionId) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'TrialLog',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'trialStartTime ASC',
    );
    return List.generate(maps.length, (i) => TrialLog.fromMap(maps[i]));
  }

  @override
  Future<List<TrialLog>> getAllTrialLogs() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('TrialLog');
    return List.generate(maps.length, (i) => TrialLog.fromMap(maps[i]));
  }

  @override
  Future<void> saveEventLog(EventLog event) async {
    final db = await database;
    await db.insert(
      'EventLog',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("DATABASE: Saved EventLog ${event.eventId}");
  }

  @override
  Future<List<EventLog>> getEventLogsByTrial(String trialId) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'EventLog',
      where: 'trialId = ?',
      whereArgs: [trialId],
      orderBy: 'eventTimestamp ASC',
    );
    return List.generate(maps.length, (i) => EventLog.fromMap(maps[i]));
  }

  @override
  Future<List<EventLog>> getAllEventLogs() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('EventLog');
    return List.generate(maps.length, (i) => EventLog.fromMap(maps[i]));
  }
}