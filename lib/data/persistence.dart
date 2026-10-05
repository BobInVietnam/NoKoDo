import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import 'database.dart' as d; // adjust path; prefix avoids name clashes with models
import '../models/converted_file.dart';
import '../models/dictionary_entry.dart';
import '../models/lesson.dart';
import '../models/session.dart';
import '../models/trial_log.dart';
import '../models/event_log.dart';

abstract class LocalDatabase extends ChangeNotifier {
  Future<void> test();
  Future<int> insertConvertedFile(ConvertedFile file);
  Future<List<ConvertedFile>> getAllConvertedFiles();
  Future<ConvertedFile?> getConvertedFileById(int id);
  Future<int> deleteConvertedFile(int id);
  Future<int> insertDictionaryEntry(DictionaryEntry entry);
  Future<List<DictionaryEntry>> getDictionaryEntriesPaginated(int limit, int offset);
  Future<List<DictionaryEntry>> searchDictionaryWords(String query, int limit, int offset);
  Future<DictionaryEntry?> getDictionaryEntryByWord(String word);
  Future<void> clearDictionary();
  Future<void> setConfig(String key, String value);
  Future<String?> getConfig(String key);
  Future<int> insertHighlight(String text);
  Future<List<String>> getAllHighlights();
  Future<void> deleteHighlight(String text);
  Future<void> saveLessons(List<Lesson> lessons);
  Future<List<Lesson>> getAllLessons();
  Future<void> saveSession(Session session);
  Future<Session?> getSessionById(String sessionId);
  Future<List<Session>> getAllSessions();
  Future<void> saveTrialLog(TrialLog trial);
  Future<TrialLog?> getTrialLogById(String trialId);
  Future<List<TrialLog>> getTrialLogsBySession(String sessionId);
  Future<List<TrialLog>> getAllTrialLogs();
  Future<void> saveEventLog(EventLog event);
  Future<List<EventLog>> getEventLogsByTrial(String trialId);
  Future<List<EventLog>> getAllEventLogs();
}

class TestLocalDatabase extends LocalDatabase {
  static final TestLocalDatabase _instance = TestLocalDatabase._internal();
  factory TestLocalDatabase() => _instance;
  TestLocalDatabase._internal();

  final d.AppDatabase _db = d.AppDatabase();

  // Drift rows -> model maps (column names match the model map keys)
  Map<String, Object?> _map(Insertable<dynamic> row) =>
      (row as dynamic).toJson() as Map<String, Object?>;

  @override
  Future<void> test() async {
    await _db.customSelect('SELECT 1').get();
    debugPrint("DATABASE: Online!");
  }

  // ---------- ConvertedFile ----------
  d.ConvertedFilesCompanion _fileCompanion(ConvertedFile f) {
    final m = f.toMap();
    return d.ConvertedFilesCompanion(
      id: m['id'] == null ? const Value.absent() : Value(m['id'] as int),
      name: Value(m['name'] as String?),
      extractedText: Value(m['extractedText'] as String?),
      createdDate: Value(m['createdDate'] as int?),
    );
  }

  @override
  Future<int> insertConvertedFile(ConvertedFile file) =>
      _db.into(_db.convertedFiles).insert(
        _fileCompanion(file),
        mode: InsertMode.insertOrReplace,
      );

  @override
  Future<List<ConvertedFile>> getAllConvertedFiles() async {
    final rows = await _db.select(_db.convertedFiles).get();
    return rows.map((r) => ConvertedFile.fromMap(_map(r))).toList();
  }

  @override
  Future<ConvertedFile?> getConvertedFileById(int id) async {
    final row = await (_db.select(_db.convertedFiles)
      ..where((t) => t.id.equals(id))
      ..limit(1))
        .getSingleOrNull();
    return row == null ? null : ConvertedFile.fromMap(_map(row));
  }

  @override
  Future<int> deleteConvertedFile(int id) =>
      (_db.delete(_db.convertedFiles)..where((t) => t.id.equals(id))).go();

  // ---------- Dictionary ----------
  @override
  Future<int> insertDictionaryEntry(DictionaryEntry entry) async {
    final c = d.DictionaryEntry.fromJson(entry.toMap()).toCompanion(true);
    return _db.into(_db.dictionaryEntries).insert(
      c,
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<List<DictionaryEntry>> getDictionaryEntriesPaginated(
      int limit, int offset) async {
    final rows = await (_db.select(_db.dictionaryEntries)
      ..orderBy([(t) => OrderingTerm.asc(t.word)])
      ..limit(limit, offset: offset))
        .get();
    return rows.map((r) => DictionaryEntry.fromMap(_map(r))).toList();
  }

  @override
  Future<DictionaryEntry?> getDictionaryEntryByWord(String word) async {
    final row = await (_db.select(_db.dictionaryEntries)
      ..where((t) => t.word.equals(word.trim()))
      ..limit(1))
        .getSingleOrNull();
    return row == null ? null : DictionaryEntry.fromMap(_map(row));
  }

  @override
  Future<List<DictionaryEntry>> searchDictionaryWords(
      String query, int limit, int offset) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final rows = await (_db.select(_db.dictionaryEntries)
      ..where((t) => t.word.like('%$q%'))
      ..orderBy([(t) => OrderingTerm.asc(t.word)])
      ..limit(limit, offset: offset))
        .get();
    return rows.map((r) => DictionaryEntry.fromMap(_map(r))).toList();
  }

  @override
  Future<void> clearDictionary() => _db.delete(_db.dictionaryEntries).go();

  // ---------- SystemConfig ----------
  @override
  Future<void> setConfig(String key, String value) =>
      _db.into(_db.systemConfigs).insert(
        d.SystemConfigsCompanion.insert(key: key, value: Value(value)),
        mode: InsertMode.insertOrReplace,
      );

  @override
  Future<String?> getConfig(String key) async {
    final row = await (_db.select(_db.systemConfigs)
      ..where((t) => t.key.equals(key))
      ..limit(1))
        .getSingleOrNull();
    return row?.value;
  }

  // ---------- Highlights ----------
  @override
  Future<int> insertHighlight(String text) =>
      _db.into(_db.highlights).insert(
        d.HighlightsCompanion.insert(content: text),
        mode: InsertMode.insertOrIgnore,
      );

  @override
  Future<List<String>> getAllHighlights() async {
    final rows = await _db.select(_db.highlights).get();
    return rows.map((r) => r.content).toList();
  }

  @override
  Future<void> deleteHighlight(String text) =>
      (_db.delete(_db.highlights)..where((t) => t.content.equals(text))).go();

  // ---------- Lessons ----------
  @override
  Future<void> saveLessons(List<Lesson> lessons) => _db.batch((b) {
    b.insertAll(
      _db.lessons,
      lessons.map((l) => d.Lesson.fromJson(l.toMap()).toCompanion(true)),
      mode: InsertMode.insertOrReplace,
    );
  });

  @override
  Future<List<Lesson>> getAllLessons() async {
    final rows = await _db.select(_db.lessons).get();
    return rows.map((r) => Lesson.fromMap(_map(r))).toList();
  }

  // ---------- Sessions ----------
  @override
  Future<void> saveSession(Session session) async {
    await _db.into(_db.sessions).insert(
      d.Session.fromJson(session.toMap()).toCompanion(true),
      mode: InsertMode.insertOrReplace,
    );
    debugPrint(
        "DATABASE: Saved/replaced session ${session.sessionId} (completed: ${session.completed})");
  }

  @override
  Future<Session?> getSessionById(String sessionId) async {
    final row = await (_db.select(_db.sessions)
      ..where((t) => t.sessionId.equals(sessionId))
      ..limit(1))
        .getSingleOrNull();
    return row == null ? null : Session.fromMap(_map(row));
  }

  @override
  Future<List<Session>> getAllSessions() async {
    final rows = await _db.select(_db.sessions).get();
    return rows.map((r) => Session.fromMap(_map(r))).toList();
  }

  // ---------- TrialLogs ----------
  @override
  Future<void> saveTrialLog(TrialLog trial) async {
    await _db.into(_db.trialLogs).insert(
      d.TrialLog.fromJson(trial.toMap()).toCompanion(true),
      mode: InsertMode.insertOrReplace,
    );
    debugPrint("DATABASE: Saved/replaced TrialLog ${trial.trialId}");
  }

  @override
  Future<TrialLog?> getTrialLogById(String trialId) async {
    final row = await (_db.select(_db.trialLogs)
      ..where((t) => t.trialId.equals(trialId))
      ..limit(1))
        .getSingleOrNull();
    return row == null ? null : TrialLog.fromMap(_map(row));
  }

  @override
  Future<List<TrialLog>> getTrialLogsBySession(String sessionId) async {
    final rows = await (_db.select(_db.trialLogs)
      ..where((t) => t.sessionId.equals(sessionId))
      ..orderBy([(t) => OrderingTerm.asc(t.trialStartTime)]))
        .get();
    return rows.map((r) => TrialLog.fromMap(_map(r))).toList();
  }

  @override
  Future<List<TrialLog>> getAllTrialLogs() async {
    final rows = await _db.select(_db.trialLogs).get();
    return rows.map((r) => TrialLog.fromMap(_map(r))).toList();
  }

  // ---------- EventLogs ----------
  @override
  Future<void> saveEventLog(EventLog event) async {
    await _db.into(_db.eventLogs).insert(
      d.EventLog.fromJson(event.toMap()).toCompanion(true),
      mode: InsertMode.insertOrReplace,
    );
    debugPrint("DATABASE: Saved EventLog ${event.eventId}");
  }

  @override
  Future<List<EventLog>> getEventLogsByTrial(String trialId) async {
    final rows = await (_db.select(_db.eventLogs)
      ..where((t) => t.trialId.equals(trialId))
      ..orderBy([(t) => OrderingTerm.asc(t.eventTimestamp)]))
        .get();
    return rows.map((r) => EventLog.fromMap(_map(r))).toList();
  }

  @override
  Future<List<EventLog>> getAllEventLogs() async {
    final rows = await _db.select(_db.eventLogs).get();
    return rows.map((r) => EventLog.fromMap(_map(r))).toList();
  }
}