import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  IntColumn get type => integer().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get difficulty => integer().nullable()();
  IntColumn get dateCreated => integer().nullable()();
  IntColumn get isDone => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DictionaryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get word => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get imageName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ConvertedFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get extractedText => text().nullable()();
  IntColumn get createdDate => integer().nullable()();
}

class SystemConfigs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().unique()();
}

class Sessions extends Table {
  TextColumn get sessionId => text()();
  TextColumn get studentId => text().nullable()();
  TextColumn get sessionStartTime => text().nullable()();
  TextColumn get sessionEndTime => text().nullable()();
  TextColumn get examinerId => text().nullable()();
  TextColumn get siteId => text().nullable()();
  TextColumn get device => text().nullable()();
  RealColumn get screenWidth => real().nullable()();
  RealColumn get screenHeight => real().nullable()();
  TextColumn get appVersion => text().nullable()();
  TextColumn get webVersion => text().nullable()();
  IntColumn get completed => integer().nullable()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

class TrialLogs extends Table {
  TextColumn get sessionId => text().nullable()();
  TextColumn get trialId => text()();
  TextColumn get trialType => text().nullable()();
  TextColumn get trialName => text().nullable()();
  IntColumn get trialStartTime => integer().nullable()();
  IntColumn get trialEndTime => integer().nullable()();
  TextColumn get conditionId => text().nullable()();
  TextColumn get conditionName => text().nullable()();
  TextColumn get comment => text().nullable()();
  IntColumn get validTrial => integer().nullable()();
  IntColumn get assistanceGiven => integer().nullable()();
  IntColumn get interrupted => integer().nullable()();
  IntColumn get technicalIssue => integer().nullable()();
  TextColumn get invalidReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {trialId};
}

class EventLogs extends Table {
  TextColumn get trialId => text().nullable()();
  TextColumn get eventId => text()();
  TextColumn get eventType => text().nullable()();
  IntColumn get eventTimestamp => integer().nullable()();
  TextColumn get payloadJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {eventId};
}

@DriftDatabase(
  tables: [
    Lessons,
    DictionaryEntries,
    ConvertedFiles,
    SystemConfigs,
    Highlights,
    Sessions,
    TrialLogs,
    EventLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
