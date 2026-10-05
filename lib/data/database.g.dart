// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateCreatedMeta = const VerificationMeta(
    'dateCreated',
  );
  @override
  late final GeneratedColumn<int> dateCreated = GeneratedColumn<int>(
    'date_created',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<int> isDone = GeneratedColumn<int>(
    'is_done',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    description,
    content,
    difficulty,
    dateCreated,
    isDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('date_created')) {
      context.handle(
        _dateCreatedMeta,
        dateCreated.isAcceptableOrUnknown(
          data['date_created']!,
          _dateCreatedMeta,
        ),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      ),
      dateCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_created'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_done'],
      ),
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final String id;
  final String? name;
  final int? type;
  final String? description;
  final String? content;
  final int? difficulty;
  final int? dateCreated;
  final int? isDone;
  const Lesson({
    required this.id,
    this.name,
    this.type,
    this.description,
    this.content,
    this.difficulty,
    this.dateCreated,
    this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<int>(difficulty);
    }
    if (!nullToAbsent || dateCreated != null) {
      map['date_created'] = Variable<int>(dateCreated);
    }
    if (!nullToAbsent || isDone != null) {
      map['is_done'] = Variable<int>(isDone);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      content:
          content == null && nullToAbsent
              ? const Value.absent()
              : Value(content),
      difficulty:
          difficulty == null && nullToAbsent
              ? const Value.absent()
              : Value(difficulty),
      dateCreated:
          dateCreated == null && nullToAbsent
              ? const Value.absent()
              : Value(dateCreated),
      isDone:
          isDone == null && nullToAbsent ? const Value.absent() : Value(isDone),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      type: serializer.fromJson<int?>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      content: serializer.fromJson<String?>(json['content']),
      difficulty: serializer.fromJson<int?>(json['difficulty']),
      dateCreated: serializer.fromJson<int?>(json['dateCreated']),
      isDone: serializer.fromJson<int?>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<int?>(type),
      'description': serializer.toJson<String?>(description),
      'content': serializer.toJson<String?>(content),
      'difficulty': serializer.toJson<int?>(difficulty),
      'dateCreated': serializer.toJson<int?>(dateCreated),
      'isDone': serializer.toJson<int?>(isDone),
    };
  }

  Lesson copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<int?> type = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<int?> difficulty = const Value.absent(),
    Value<int?> dateCreated = const Value.absent(),
    Value<int?> isDone = const Value.absent(),
  }) => Lesson(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    type: type.present ? type.value : this.type,
    description: description.present ? description.value : this.description,
    content: content.present ? content.value : this.content,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    dateCreated: dateCreated.present ? dateCreated.value : this.dateCreated,
    isDone: isDone.present ? isDone.value : this.isDone,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      content: data.content.present ? data.content.value : this.content,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      dateCreated:
          data.dateCreated.present ? data.dateCreated.value : this.dateCreated,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('difficulty: $difficulty, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    description,
    content,
    difficulty,
    dateCreated,
    isDone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.description == this.description &&
          other.content == this.content &&
          other.difficulty == this.difficulty &&
          other.dateCreated == this.dateCreated &&
          other.isDone == this.isDone);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<String> id;
  final Value<String?> name;
  final Value<int?> type;
  final Value<String?> description;
  final Value<String?> content;
  final Value<int?> difficulty;
  final Value<int?> dateCreated;
  final Value<int?> isDone;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.isDone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.isDone = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Lesson> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? description,
    Expression<String>? content,
    Expression<int>? difficulty,
    Expression<int>? dateCreated,
    Expression<int>? isDone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (content != null) 'content': content,
      if (difficulty != null) 'difficulty': difficulty,
      if (dateCreated != null) 'date_created': dateCreated,
      if (isDone != null) 'is_done': isDone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<int?>? type,
    Value<String?>? description,
    Value<String?>? content,
    Value<int?>? difficulty,
    Value<int?>? dateCreated,
    Value<int?>? isDone,
    Value<int>? rowid,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      content: content ?? this.content,
      difficulty: difficulty ?? this.difficulty,
      dateCreated: dateCreated ?? this.dateCreated,
      isDone: isDone ?? this.isDone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<int>(dateCreated.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<int>(isDone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('difficulty: $difficulty, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('isDone: $isDone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DictionaryEntriesTable extends DictionaryEntries
    with TableInfo<$DictionaryEntriesTable, DictionaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageNameMeta = const VerificationMeta(
    'imageName',
  );
  @override
  late final GeneratedColumn<String> imageName = GeneratedColumn<String>(
    'image_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, word, description, imageName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictionaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_name')) {
      context.handle(
        _imageNameMeta,
        imageName.isAcceptableOrUnknown(data['image_name']!, _imageNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DictionaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_name'],
      ),
    );
  }

  @override
  $DictionaryEntriesTable createAlias(String alias) {
    return $DictionaryEntriesTable(attachedDatabase, alias);
  }
}

class DictionaryEntry extends DataClass implements Insertable<DictionaryEntry> {
  final String id;
  final String? word;
  final String? description;
  final String? imageName;
  const DictionaryEntry({
    required this.id,
    this.word,
    this.description,
    this.imageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || word != null) {
      map['word'] = Variable<String>(word);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageName != null) {
      map['image_name'] = Variable<String>(imageName);
    }
    return map;
  }

  DictionaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DictionaryEntriesCompanion(
      id: Value(id),
      word: word == null && nullToAbsent ? const Value.absent() : Value(word),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      imageName:
          imageName == null && nullToAbsent
              ? const Value.absent()
              : Value(imageName),
    );
  }

  factory DictionaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryEntry(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String?>(json['word']),
      description: serializer.fromJson<String?>(json['description']),
      imageName: serializer.fromJson<String?>(json['imageName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String?>(word),
      'description': serializer.toJson<String?>(description),
      'imageName': serializer.toJson<String?>(imageName),
    };
  }

  DictionaryEntry copyWith({
    String? id,
    Value<String?> word = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> imageName = const Value.absent(),
  }) => DictionaryEntry(
    id: id ?? this.id,
    word: word.present ? word.value : this.word,
    description: description.present ? description.value : this.description,
    imageName: imageName.present ? imageName.value : this.imageName,
  );
  DictionaryEntry copyWithCompanion(DictionaryEntriesCompanion data) {
    return DictionaryEntry(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      description:
          data.description.present ? data.description.value : this.description,
      imageName: data.imageName.present ? data.imageName.value : this.imageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntry(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('description: $description, ')
          ..write('imageName: $imageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, description, imageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryEntry &&
          other.id == this.id &&
          other.word == this.word &&
          other.description == this.description &&
          other.imageName == this.imageName);
}

class DictionaryEntriesCompanion extends UpdateCompanion<DictionaryEntry> {
  final Value<String> id;
  final Value<String?> word;
  final Value<String?> description;
  final Value<String?> imageName;
  final Value<int> rowid;
  const DictionaryEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.description = const Value.absent(),
    this.imageName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionaryEntriesCompanion.insert({
    required String id,
    this.word = const Value.absent(),
    this.description = const Value.absent(),
    this.imageName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<DictionaryEntry> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? description,
    Expression<String>? imageName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (description != null) 'description': description,
      if (imageName != null) 'image_name': imageName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionaryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? word,
    Value<String?>? description,
    Value<String?>? imageName,
    Value<int>? rowid,
  }) {
    return DictionaryEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      description: description ?? this.description,
      imageName: imageName ?? this.imageName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageName.present) {
      map['image_name'] = Variable<String>(imageName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('description: $description, ')
          ..write('imageName: $imageName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConvertedFilesTable extends ConvertedFiles
    with TableInfo<$ConvertedFilesTable, ConvertedFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConvertedFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<int> createdDate = GeneratedColumn<int>(
    'created_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, extractedText, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'converted_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConvertedFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConvertedFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConvertedFile(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      ),
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_date'],
      ),
    );
  }

  @override
  $ConvertedFilesTable createAlias(String alias) {
    return $ConvertedFilesTable(attachedDatabase, alias);
  }
}

class ConvertedFile extends DataClass implements Insertable<ConvertedFile> {
  final int id;
  final String? name;
  final String? extractedText;
  final int? createdDate;
  const ConvertedFile({
    required this.id,
    this.name,
    this.extractedText,
    this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || extractedText != null) {
      map['extracted_text'] = Variable<String>(extractedText);
    }
    if (!nullToAbsent || createdDate != null) {
      map['created_date'] = Variable<int>(createdDate);
    }
    return map;
  }

  ConvertedFilesCompanion toCompanion(bool nullToAbsent) {
    return ConvertedFilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      extractedText:
          extractedText == null && nullToAbsent
              ? const Value.absent()
              : Value(extractedText),
      createdDate:
          createdDate == null && nullToAbsent
              ? const Value.absent()
              : Value(createdDate),
    );
  }

  factory ConvertedFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConvertedFile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      extractedText: serializer.fromJson<String?>(json['extractedText']),
      createdDate: serializer.fromJson<int?>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'extractedText': serializer.toJson<String?>(extractedText),
      'createdDate': serializer.toJson<int?>(createdDate),
    };
  }

  ConvertedFile copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> extractedText = const Value.absent(),
    Value<int?> createdDate = const Value.absent(),
  }) => ConvertedFile(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    extractedText:
        extractedText.present ? extractedText.value : this.extractedText,
    createdDate: createdDate.present ? createdDate.value : this.createdDate,
  );
  ConvertedFile copyWithCompanion(ConvertedFilesCompanion data) {
    return ConvertedFile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      extractedText:
          data.extractedText.present
              ? data.extractedText.value
              : this.extractedText,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConvertedFile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, extractedText, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConvertedFile &&
          other.id == this.id &&
          other.name == this.name &&
          other.extractedText == this.extractedText &&
          other.createdDate == this.createdDate);
}

class ConvertedFilesCompanion extends UpdateCompanion<ConvertedFile> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> extractedText;
  final Value<int?> createdDate;
  const ConvertedFilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  ConvertedFilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<ConvertedFile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? extractedText,
    Expression<int>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (extractedText != null) 'extracted_text': extractedText,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  ConvertedFilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? extractedText,
    Value<int?>? createdDate,
  }) {
    return ConvertedFilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      extractedText: extractedText ?? this.extractedText,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<int>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConvertedFilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $SystemConfigsTable extends SystemConfigs
    with TableInfo<$SystemConfigsTable, SystemConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SystemConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SystemConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemConfig(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $SystemConfigsTable createAlias(String alias) {
    return $SystemConfigsTable(attachedDatabase, alias);
  }
}

class SystemConfig extends DataClass implements Insertable<SystemConfig> {
  final String key;
  final String? value;
  const SystemConfig({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SystemConfigsCompanion toCompanion(bool nullToAbsent) {
    return SystemConfigsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory SystemConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemConfig(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  SystemConfig copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => SystemConfig(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  SystemConfig copyWithCompanion(SystemConfigsCompanion data) {
    return SystemConfig(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemConfig(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemConfig &&
          other.key == this.key &&
          other.value == this.value);
}

class SystemConfigsCompanion extends UpdateCompanion<SystemConfig> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const SystemConfigsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemConfigsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SystemConfig> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemConfigsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return SystemConfigsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemConfigsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightsTable extends Highlights
    with TableInfo<$HighlightsTable, Highlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Highlight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Highlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Highlight(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
    );
  }

  @override
  $HighlightsTable createAlias(String alias) {
    return $HighlightsTable(attachedDatabase, alias);
  }
}

class Highlight extends DataClass implements Insertable<Highlight> {
  final int id;
  final String content;
  const Highlight({required this.id, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    return map;
  }

  HighlightsCompanion toCompanion(bool nullToAbsent) {
    return HighlightsCompanion(id: Value(id), content: Value(content));
  }

  factory Highlight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Highlight(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
    };
  }

  Highlight copyWith({int? id, String? content}) =>
      Highlight(id: id ?? this.id, content: content ?? this.content);
  Highlight copyWithCompanion(HighlightsCompanion data) {
    return Highlight(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Highlight(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Highlight &&
          other.id == this.id &&
          other.content == this.content);
}

class HighlightsCompanion extends UpdateCompanion<Highlight> {
  final Value<int> id;
  final Value<String> content;
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
  });
  HighlightsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<Highlight> custom({
    Expression<int>? id,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
    });
  }

  HighlightsCompanion copyWith({Value<int>? id, Value<String>? content}) {
    return HighlightsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionStartTimeMeta = const VerificationMeta(
    'sessionStartTime',
  );
  @override
  late final GeneratedColumn<String> sessionStartTime = GeneratedColumn<String>(
    'session_start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionEndTimeMeta = const VerificationMeta(
    'sessionEndTime',
  );
  @override
  late final GeneratedColumn<String> sessionEndTime = GeneratedColumn<String>(
    'session_end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examinerIdMeta = const VerificationMeta(
    'examinerId',
  );
  @override
  late final GeneratedColumn<String> examinerId = GeneratedColumn<String>(
    'examiner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
    'device',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenWidthMeta = const VerificationMeta(
    'screenWidth',
  );
  @override
  late final GeneratedColumn<double> screenWidth = GeneratedColumn<double>(
    'screen_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenHeightMeta = const VerificationMeta(
    'screenHeight',
  );
  @override
  late final GeneratedColumn<double> screenHeight = GeneratedColumn<double>(
    'screen_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _webVersionMeta = const VerificationMeta(
    'webVersion',
  );
  @override
  late final GeneratedColumn<String> webVersion = GeneratedColumn<String>(
    'web_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<int> completed = GeneratedColumn<int>(
    'completed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    studentId,
    sessionStartTime,
    sessionEndTime,
    examinerId,
    siteId,
    device,
    screenWidth,
    screenHeight,
    appVersion,
    webVersion,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    }
    if (data.containsKey('session_start_time')) {
      context.handle(
        _sessionStartTimeMeta,
        sessionStartTime.isAcceptableOrUnknown(
          data['session_start_time']!,
          _sessionStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('session_end_time')) {
      context.handle(
        _sessionEndTimeMeta,
        sessionEndTime.isAcceptableOrUnknown(
          data['session_end_time']!,
          _sessionEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('examiner_id')) {
      context.handle(
        _examinerIdMeta,
        examinerId.isAcceptableOrUnknown(data['examiner_id']!, _examinerIdMeta),
      );
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    if (data.containsKey('device')) {
      context.handle(
        _deviceMeta,
        device.isAcceptableOrUnknown(data['device']!, _deviceMeta),
      );
    }
    if (data.containsKey('screen_width')) {
      context.handle(
        _screenWidthMeta,
        screenWidth.isAcceptableOrUnknown(
          data['screen_width']!,
          _screenWidthMeta,
        ),
      );
    }
    if (data.containsKey('screen_height')) {
      context.handle(
        _screenHeightMeta,
        screenHeight.isAcceptableOrUnknown(
          data['screen_height']!,
          _screenHeightMeta,
        ),
      );
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    if (data.containsKey('web_version')) {
      context.handle(
        _webVersionMeta,
        webVersion.isAcceptableOrUnknown(data['web_version']!, _webVersionMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_id'],
          )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      ),
      sessionStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_start_time'],
      ),
      sessionEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_end_time'],
      ),
      examinerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examiner_id'],
      ),
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      ),
      device: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device'],
      ),
      screenWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}screen_width'],
      ),
      screenHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}screen_height'],
      ),
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      ),
      webVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}web_version'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String sessionId;
  final String? studentId;
  final String? sessionStartTime;
  final String? sessionEndTime;
  final String? examinerId;
  final String? siteId;
  final String? device;
  final double? screenWidth;
  final double? screenHeight;
  final String? appVersion;
  final String? webVersion;
  final int? completed;
  const Session({
    required this.sessionId,
    this.studentId,
    this.sessionStartTime,
    this.sessionEndTime,
    this.examinerId,
    this.siteId,
    this.device,
    this.screenWidth,
    this.screenHeight,
    this.appVersion,
    this.webVersion,
    this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<String>(studentId);
    }
    if (!nullToAbsent || sessionStartTime != null) {
      map['session_start_time'] = Variable<String>(sessionStartTime);
    }
    if (!nullToAbsent || sessionEndTime != null) {
      map['session_end_time'] = Variable<String>(sessionEndTime);
    }
    if (!nullToAbsent || examinerId != null) {
      map['examiner_id'] = Variable<String>(examinerId);
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<String>(siteId);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<String>(device);
    }
    if (!nullToAbsent || screenWidth != null) {
      map['screen_width'] = Variable<double>(screenWidth);
    }
    if (!nullToAbsent || screenHeight != null) {
      map['screen_height'] = Variable<double>(screenHeight);
    }
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    if (!nullToAbsent || webVersion != null) {
      map['web_version'] = Variable<String>(webVersion);
    }
    if (!nullToAbsent || completed != null) {
      map['completed'] = Variable<int>(completed);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      sessionId: Value(sessionId),
      studentId:
          studentId == null && nullToAbsent
              ? const Value.absent()
              : Value(studentId),
      sessionStartTime:
          sessionStartTime == null && nullToAbsent
              ? const Value.absent()
              : Value(sessionStartTime),
      sessionEndTime:
          sessionEndTime == null && nullToAbsent
              ? const Value.absent()
              : Value(sessionEndTime),
      examinerId:
          examinerId == null && nullToAbsent
              ? const Value.absent()
              : Value(examinerId),
      siteId:
          siteId == null && nullToAbsent ? const Value.absent() : Value(siteId),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      screenWidth:
          screenWidth == null && nullToAbsent
              ? const Value.absent()
              : Value(screenWidth),
      screenHeight:
          screenHeight == null && nullToAbsent
              ? const Value.absent()
              : Value(screenHeight),
      appVersion:
          appVersion == null && nullToAbsent
              ? const Value.absent()
              : Value(appVersion),
      webVersion:
          webVersion == null && nullToAbsent
              ? const Value.absent()
              : Value(webVersion),
      completed:
          completed == null && nullToAbsent
              ? const Value.absent()
              : Value(completed),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      studentId: serializer.fromJson<String?>(json['studentId']),
      sessionStartTime: serializer.fromJson<String?>(json['sessionStartTime']),
      sessionEndTime: serializer.fromJson<String?>(json['sessionEndTime']),
      examinerId: serializer.fromJson<String?>(json['examinerId']),
      siteId: serializer.fromJson<String?>(json['siteId']),
      device: serializer.fromJson<String?>(json['device']),
      screenWidth: serializer.fromJson<double?>(json['screenWidth']),
      screenHeight: serializer.fromJson<double?>(json['screenHeight']),
      appVersion: serializer.fromJson<String?>(json['appVersion']),
      webVersion: serializer.fromJson<String?>(json['webVersion']),
      completed: serializer.fromJson<int?>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'studentId': serializer.toJson<String?>(studentId),
      'sessionStartTime': serializer.toJson<String?>(sessionStartTime),
      'sessionEndTime': serializer.toJson<String?>(sessionEndTime),
      'examinerId': serializer.toJson<String?>(examinerId),
      'siteId': serializer.toJson<String?>(siteId),
      'device': serializer.toJson<String?>(device),
      'screenWidth': serializer.toJson<double?>(screenWidth),
      'screenHeight': serializer.toJson<double?>(screenHeight),
      'appVersion': serializer.toJson<String?>(appVersion),
      'webVersion': serializer.toJson<String?>(webVersion),
      'completed': serializer.toJson<int?>(completed),
    };
  }

  Session copyWith({
    String? sessionId,
    Value<String?> studentId = const Value.absent(),
    Value<String?> sessionStartTime = const Value.absent(),
    Value<String?> sessionEndTime = const Value.absent(),
    Value<String?> examinerId = const Value.absent(),
    Value<String?> siteId = const Value.absent(),
    Value<String?> device = const Value.absent(),
    Value<double?> screenWidth = const Value.absent(),
    Value<double?> screenHeight = const Value.absent(),
    Value<String?> appVersion = const Value.absent(),
    Value<String?> webVersion = const Value.absent(),
    Value<int?> completed = const Value.absent(),
  }) => Session(
    sessionId: sessionId ?? this.sessionId,
    studentId: studentId.present ? studentId.value : this.studentId,
    sessionStartTime:
        sessionStartTime.present
            ? sessionStartTime.value
            : this.sessionStartTime,
    sessionEndTime:
        sessionEndTime.present ? sessionEndTime.value : this.sessionEndTime,
    examinerId: examinerId.present ? examinerId.value : this.examinerId,
    siteId: siteId.present ? siteId.value : this.siteId,
    device: device.present ? device.value : this.device,
    screenWidth: screenWidth.present ? screenWidth.value : this.screenWidth,
    screenHeight: screenHeight.present ? screenHeight.value : this.screenHeight,
    appVersion: appVersion.present ? appVersion.value : this.appVersion,
    webVersion: webVersion.present ? webVersion.value : this.webVersion,
    completed: completed.present ? completed.value : this.completed,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      sessionStartTime:
          data.sessionStartTime.present
              ? data.sessionStartTime.value
              : this.sessionStartTime,
      sessionEndTime:
          data.sessionEndTime.present
              ? data.sessionEndTime.value
              : this.sessionEndTime,
      examinerId:
          data.examinerId.present ? data.examinerId.value : this.examinerId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      device: data.device.present ? data.device.value : this.device,
      screenWidth:
          data.screenWidth.present ? data.screenWidth.value : this.screenWidth,
      screenHeight:
          data.screenHeight.present
              ? data.screenHeight.value
              : this.screenHeight,
      appVersion:
          data.appVersion.present ? data.appVersion.value : this.appVersion,
      webVersion:
          data.webVersion.present ? data.webVersion.value : this.webVersion,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('sessionStartTime: $sessionStartTime, ')
          ..write('sessionEndTime: $sessionEndTime, ')
          ..write('examinerId: $examinerId, ')
          ..write('siteId: $siteId, ')
          ..write('device: $device, ')
          ..write('screenWidth: $screenWidth, ')
          ..write('screenHeight: $screenHeight, ')
          ..write('appVersion: $appVersion, ')
          ..write('webVersion: $webVersion, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    studentId,
    sessionStartTime,
    sessionEndTime,
    examinerId,
    siteId,
    device,
    screenWidth,
    screenHeight,
    appVersion,
    webVersion,
    completed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.sessionId == this.sessionId &&
          other.studentId == this.studentId &&
          other.sessionStartTime == this.sessionStartTime &&
          other.sessionEndTime == this.sessionEndTime &&
          other.examinerId == this.examinerId &&
          other.siteId == this.siteId &&
          other.device == this.device &&
          other.screenWidth == this.screenWidth &&
          other.screenHeight == this.screenHeight &&
          other.appVersion == this.appVersion &&
          other.webVersion == this.webVersion &&
          other.completed == this.completed);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> sessionId;
  final Value<String?> studentId;
  final Value<String?> sessionStartTime;
  final Value<String?> sessionEndTime;
  final Value<String?> examinerId;
  final Value<String?> siteId;
  final Value<String?> device;
  final Value<double?> screenWidth;
  final Value<double?> screenHeight;
  final Value<String?> appVersion;
  final Value<String?> webVersion;
  final Value<int?> completed;
  final Value<int> rowid;
  const SessionsCompanion({
    this.sessionId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.sessionStartTime = const Value.absent(),
    this.sessionEndTime = const Value.absent(),
    this.examinerId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.device = const Value.absent(),
    this.screenWidth = const Value.absent(),
    this.screenHeight = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.webVersion = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String sessionId,
    this.studentId = const Value.absent(),
    this.sessionStartTime = const Value.absent(),
    this.sessionEndTime = const Value.absent(),
    this.examinerId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.device = const Value.absent(),
    this.screenWidth = const Value.absent(),
    this.screenHeight = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.webVersion = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId);
  static Insertable<Session> custom({
    Expression<String>? sessionId,
    Expression<String>? studentId,
    Expression<String>? sessionStartTime,
    Expression<String>? sessionEndTime,
    Expression<String>? examinerId,
    Expression<String>? siteId,
    Expression<String>? device,
    Expression<double>? screenWidth,
    Expression<double>? screenHeight,
    Expression<String>? appVersion,
    Expression<String>? webVersion,
    Expression<int>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (studentId != null) 'student_id': studentId,
      if (sessionStartTime != null) 'session_start_time': sessionStartTime,
      if (sessionEndTime != null) 'session_end_time': sessionEndTime,
      if (examinerId != null) 'examiner_id': examinerId,
      if (siteId != null) 'site_id': siteId,
      if (device != null) 'device': device,
      if (screenWidth != null) 'screen_width': screenWidth,
      if (screenHeight != null) 'screen_height': screenHeight,
      if (appVersion != null) 'app_version': appVersion,
      if (webVersion != null) 'web_version': webVersion,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? sessionId,
    Value<String?>? studentId,
    Value<String?>? sessionStartTime,
    Value<String?>? sessionEndTime,
    Value<String?>? examinerId,
    Value<String?>? siteId,
    Value<String?>? device,
    Value<double?>? screenWidth,
    Value<double?>? screenHeight,
    Value<String?>? appVersion,
    Value<String?>? webVersion,
    Value<int?>? completed,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
      examinerId: examinerId ?? this.examinerId,
      siteId: siteId ?? this.siteId,
      device: device ?? this.device,
      screenWidth: screenWidth ?? this.screenWidth,
      screenHeight: screenHeight ?? this.screenHeight,
      appVersion: appVersion ?? this.appVersion,
      webVersion: webVersion ?? this.webVersion,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (sessionStartTime.present) {
      map['session_start_time'] = Variable<String>(sessionStartTime.value);
    }
    if (sessionEndTime.present) {
      map['session_end_time'] = Variable<String>(sessionEndTime.value);
    }
    if (examinerId.present) {
      map['examiner_id'] = Variable<String>(examinerId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (screenWidth.present) {
      map['screen_width'] = Variable<double>(screenWidth.value);
    }
    if (screenHeight.present) {
      map['screen_height'] = Variable<double>(screenHeight.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (webVersion.present) {
      map['web_version'] = Variable<String>(webVersion.value);
    }
    if (completed.present) {
      map['completed'] = Variable<int>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('sessionStartTime: $sessionStartTime, ')
          ..write('sessionEndTime: $sessionEndTime, ')
          ..write('examinerId: $examinerId, ')
          ..write('siteId: $siteId, ')
          ..write('device: $device, ')
          ..write('screenWidth: $screenWidth, ')
          ..write('screenHeight: $screenHeight, ')
          ..write('appVersion: $appVersion, ')
          ..write('webVersion: $webVersion, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrialLogsTable extends TrialLogs
    with TableInfo<$TrialLogsTable, TrialLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrialLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialIdMeta = const VerificationMeta(
    'trialId',
  );
  @override
  late final GeneratedColumn<String> trialId = GeneratedColumn<String>(
    'trial_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trialTypeMeta = const VerificationMeta(
    'trialType',
  );
  @override
  late final GeneratedColumn<String> trialType = GeneratedColumn<String>(
    'trial_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialNameMeta = const VerificationMeta(
    'trialName',
  );
  @override
  late final GeneratedColumn<String> trialName = GeneratedColumn<String>(
    'trial_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialStartTimeMeta = const VerificationMeta(
    'trialStartTime',
  );
  @override
  late final GeneratedColumn<int> trialStartTime = GeneratedColumn<int>(
    'trial_start_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialEndTimeMeta = const VerificationMeta(
    'trialEndTime',
  );
  @override
  late final GeneratedColumn<int> trialEndTime = GeneratedColumn<int>(
    'trial_end_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionIdMeta = const VerificationMeta(
    'conditionId',
  );
  @override
  late final GeneratedColumn<String> conditionId = GeneratedColumn<String>(
    'condition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionNameMeta = const VerificationMeta(
    'conditionName',
  );
  @override
  late final GeneratedColumn<String> conditionName = GeneratedColumn<String>(
    'condition_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validTrialMeta = const VerificationMeta(
    'validTrial',
  );
  @override
  late final GeneratedColumn<int> validTrial = GeneratedColumn<int>(
    'valid_trial',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assistanceGivenMeta = const VerificationMeta(
    'assistanceGiven',
  );
  @override
  late final GeneratedColumn<int> assistanceGiven = GeneratedColumn<int>(
    'assistance_given',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interruptedMeta = const VerificationMeta(
    'interrupted',
  );
  @override
  late final GeneratedColumn<int> interrupted = GeneratedColumn<int>(
    'interrupted',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _technicalIssueMeta = const VerificationMeta(
    'technicalIssue',
  );
  @override
  late final GeneratedColumn<int> technicalIssue = GeneratedColumn<int>(
    'technical_issue',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invalidReasonMeta = const VerificationMeta(
    'invalidReason',
  );
  @override
  late final GeneratedColumn<String> invalidReason = GeneratedColumn<String>(
    'invalid_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    trialId,
    trialType,
    trialName,
    trialStartTime,
    trialEndTime,
    conditionId,
    conditionName,
    comment,
    validTrial,
    assistanceGiven,
    interrupted,
    technicalIssue,
    invalidReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trial_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrialLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('trial_id')) {
      context.handle(
        _trialIdMeta,
        trialId.isAcceptableOrUnknown(data['trial_id']!, _trialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trialIdMeta);
    }
    if (data.containsKey('trial_type')) {
      context.handle(
        _trialTypeMeta,
        trialType.isAcceptableOrUnknown(data['trial_type']!, _trialTypeMeta),
      );
    }
    if (data.containsKey('trial_name')) {
      context.handle(
        _trialNameMeta,
        trialName.isAcceptableOrUnknown(data['trial_name']!, _trialNameMeta),
      );
    }
    if (data.containsKey('trial_start_time')) {
      context.handle(
        _trialStartTimeMeta,
        trialStartTime.isAcceptableOrUnknown(
          data['trial_start_time']!,
          _trialStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('trial_end_time')) {
      context.handle(
        _trialEndTimeMeta,
        trialEndTime.isAcceptableOrUnknown(
          data['trial_end_time']!,
          _trialEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('condition_id')) {
      context.handle(
        _conditionIdMeta,
        conditionId.isAcceptableOrUnknown(
          data['condition_id']!,
          _conditionIdMeta,
        ),
      );
    }
    if (data.containsKey('condition_name')) {
      context.handle(
        _conditionNameMeta,
        conditionName.isAcceptableOrUnknown(
          data['condition_name']!,
          _conditionNameMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('valid_trial')) {
      context.handle(
        _validTrialMeta,
        validTrial.isAcceptableOrUnknown(data['valid_trial']!, _validTrialMeta),
      );
    }
    if (data.containsKey('assistance_given')) {
      context.handle(
        _assistanceGivenMeta,
        assistanceGiven.isAcceptableOrUnknown(
          data['assistance_given']!,
          _assistanceGivenMeta,
        ),
      );
    }
    if (data.containsKey('interrupted')) {
      context.handle(
        _interruptedMeta,
        interrupted.isAcceptableOrUnknown(
          data['interrupted']!,
          _interruptedMeta,
        ),
      );
    }
    if (data.containsKey('technical_issue')) {
      context.handle(
        _technicalIssueMeta,
        technicalIssue.isAcceptableOrUnknown(
          data['technical_issue']!,
          _technicalIssueMeta,
        ),
      );
    }
    if (data.containsKey('invalid_reason')) {
      context.handle(
        _invalidReasonMeta,
        invalidReason.isAcceptableOrUnknown(
          data['invalid_reason']!,
          _invalidReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trialId};
  @override
  TrialLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrialLog(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      trialId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}trial_id'],
          )!,
      trialType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_type'],
      ),
      trialName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_name'],
      ),
      trialStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trial_start_time'],
      ),
      trialEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trial_end_time'],
      ),
      conditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_id'],
      ),
      conditionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_name'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      validTrial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_trial'],
      ),
      assistanceGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assistance_given'],
      ),
      interrupted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interrupted'],
      ),
      technicalIssue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}technical_issue'],
      ),
      invalidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invalid_reason'],
      ),
    );
  }

  @override
  $TrialLogsTable createAlias(String alias) {
    return $TrialLogsTable(attachedDatabase, alias);
  }
}

class TrialLog extends DataClass implements Insertable<TrialLog> {
  final String? sessionId;
  final String trialId;
  final String? trialType;
  final String? trialName;
  final int? trialStartTime;
  final int? trialEndTime;
  final String? conditionId;
  final String? conditionName;
  final String? comment;
  final int? validTrial;
  final int? assistanceGiven;
  final int? interrupted;
  final int? technicalIssue;
  final String? invalidReason;
  const TrialLog({
    this.sessionId,
    required this.trialId,
    this.trialType,
    this.trialName,
    this.trialStartTime,
    this.trialEndTime,
    this.conditionId,
    this.conditionName,
    this.comment,
    this.validTrial,
    this.assistanceGiven,
    this.interrupted,
    this.technicalIssue,
    this.invalidReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['trial_id'] = Variable<String>(trialId);
    if (!nullToAbsent || trialType != null) {
      map['trial_type'] = Variable<String>(trialType);
    }
    if (!nullToAbsent || trialName != null) {
      map['trial_name'] = Variable<String>(trialName);
    }
    if (!nullToAbsent || trialStartTime != null) {
      map['trial_start_time'] = Variable<int>(trialStartTime);
    }
    if (!nullToAbsent || trialEndTime != null) {
      map['trial_end_time'] = Variable<int>(trialEndTime);
    }
    if (!nullToAbsent || conditionId != null) {
      map['condition_id'] = Variable<String>(conditionId);
    }
    if (!nullToAbsent || conditionName != null) {
      map['condition_name'] = Variable<String>(conditionName);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || validTrial != null) {
      map['valid_trial'] = Variable<int>(validTrial);
    }
    if (!nullToAbsent || assistanceGiven != null) {
      map['assistance_given'] = Variable<int>(assistanceGiven);
    }
    if (!nullToAbsent || interrupted != null) {
      map['interrupted'] = Variable<int>(interrupted);
    }
    if (!nullToAbsent || technicalIssue != null) {
      map['technical_issue'] = Variable<int>(technicalIssue);
    }
    if (!nullToAbsent || invalidReason != null) {
      map['invalid_reason'] = Variable<String>(invalidReason);
    }
    return map;
  }

  TrialLogsCompanion toCompanion(bool nullToAbsent) {
    return TrialLogsCompanion(
      sessionId:
          sessionId == null && nullToAbsent
              ? const Value.absent()
              : Value(sessionId),
      trialId: Value(trialId),
      trialType:
          trialType == null && nullToAbsent
              ? const Value.absent()
              : Value(trialType),
      trialName:
          trialName == null && nullToAbsent
              ? const Value.absent()
              : Value(trialName),
      trialStartTime:
          trialStartTime == null && nullToAbsent
              ? const Value.absent()
              : Value(trialStartTime),
      trialEndTime:
          trialEndTime == null && nullToAbsent
              ? const Value.absent()
              : Value(trialEndTime),
      conditionId:
          conditionId == null && nullToAbsent
              ? const Value.absent()
              : Value(conditionId),
      conditionName:
          conditionName == null && nullToAbsent
              ? const Value.absent()
              : Value(conditionName),
      comment:
          comment == null && nullToAbsent
              ? const Value.absent()
              : Value(comment),
      validTrial:
          validTrial == null && nullToAbsent
              ? const Value.absent()
              : Value(validTrial),
      assistanceGiven:
          assistanceGiven == null && nullToAbsent
              ? const Value.absent()
              : Value(assistanceGiven),
      interrupted:
          interrupted == null && nullToAbsent
              ? const Value.absent()
              : Value(interrupted),
      technicalIssue:
          technicalIssue == null && nullToAbsent
              ? const Value.absent()
              : Value(technicalIssue),
      invalidReason:
          invalidReason == null && nullToAbsent
              ? const Value.absent()
              : Value(invalidReason),
    );
  }

  factory TrialLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrialLog(
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      trialId: serializer.fromJson<String>(json['trialId']),
      trialType: serializer.fromJson<String?>(json['trialType']),
      trialName: serializer.fromJson<String?>(json['trialName']),
      trialStartTime: serializer.fromJson<int?>(json['trialStartTime']),
      trialEndTime: serializer.fromJson<int?>(json['trialEndTime']),
      conditionId: serializer.fromJson<String?>(json['conditionId']),
      conditionName: serializer.fromJson<String?>(json['conditionName']),
      comment: serializer.fromJson<String?>(json['comment']),
      validTrial: serializer.fromJson<int?>(json['validTrial']),
      assistanceGiven: serializer.fromJson<int?>(json['assistanceGiven']),
      interrupted: serializer.fromJson<int?>(json['interrupted']),
      technicalIssue: serializer.fromJson<int?>(json['technicalIssue']),
      invalidReason: serializer.fromJson<String?>(json['invalidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String?>(sessionId),
      'trialId': serializer.toJson<String>(trialId),
      'trialType': serializer.toJson<String?>(trialType),
      'trialName': serializer.toJson<String?>(trialName),
      'trialStartTime': serializer.toJson<int?>(trialStartTime),
      'trialEndTime': serializer.toJson<int?>(trialEndTime),
      'conditionId': serializer.toJson<String?>(conditionId),
      'conditionName': serializer.toJson<String?>(conditionName),
      'comment': serializer.toJson<String?>(comment),
      'validTrial': serializer.toJson<int?>(validTrial),
      'assistanceGiven': serializer.toJson<int?>(assistanceGiven),
      'interrupted': serializer.toJson<int?>(interrupted),
      'technicalIssue': serializer.toJson<int?>(technicalIssue),
      'invalidReason': serializer.toJson<String?>(invalidReason),
    };
  }

  TrialLog copyWith({
    Value<String?> sessionId = const Value.absent(),
    String? trialId,
    Value<String?> trialType = const Value.absent(),
    Value<String?> trialName = const Value.absent(),
    Value<int?> trialStartTime = const Value.absent(),
    Value<int?> trialEndTime = const Value.absent(),
    Value<String?> conditionId = const Value.absent(),
    Value<String?> conditionName = const Value.absent(),
    Value<String?> comment = const Value.absent(),
    Value<int?> validTrial = const Value.absent(),
    Value<int?> assistanceGiven = const Value.absent(),
    Value<int?> interrupted = const Value.absent(),
    Value<int?> technicalIssue = const Value.absent(),
    Value<String?> invalidReason = const Value.absent(),
  }) => TrialLog(
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    trialId: trialId ?? this.trialId,
    trialType: trialType.present ? trialType.value : this.trialType,
    trialName: trialName.present ? trialName.value : this.trialName,
    trialStartTime:
        trialStartTime.present ? trialStartTime.value : this.trialStartTime,
    trialEndTime: trialEndTime.present ? trialEndTime.value : this.trialEndTime,
    conditionId: conditionId.present ? conditionId.value : this.conditionId,
    conditionName:
        conditionName.present ? conditionName.value : this.conditionName,
    comment: comment.present ? comment.value : this.comment,
    validTrial: validTrial.present ? validTrial.value : this.validTrial,
    assistanceGiven:
        assistanceGiven.present ? assistanceGiven.value : this.assistanceGiven,
    interrupted: interrupted.present ? interrupted.value : this.interrupted,
    technicalIssue:
        technicalIssue.present ? technicalIssue.value : this.technicalIssue,
    invalidReason:
        invalidReason.present ? invalidReason.value : this.invalidReason,
  );
  TrialLog copyWithCompanion(TrialLogsCompanion data) {
    return TrialLog(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      trialId: data.trialId.present ? data.trialId.value : this.trialId,
      trialType: data.trialType.present ? data.trialType.value : this.trialType,
      trialName: data.trialName.present ? data.trialName.value : this.trialName,
      trialStartTime:
          data.trialStartTime.present
              ? data.trialStartTime.value
              : this.trialStartTime,
      trialEndTime:
          data.trialEndTime.present
              ? data.trialEndTime.value
              : this.trialEndTime,
      conditionId:
          data.conditionId.present ? data.conditionId.value : this.conditionId,
      conditionName:
          data.conditionName.present
              ? data.conditionName.value
              : this.conditionName,
      comment: data.comment.present ? data.comment.value : this.comment,
      validTrial:
          data.validTrial.present ? data.validTrial.value : this.validTrial,
      assistanceGiven:
          data.assistanceGiven.present
              ? data.assistanceGiven.value
              : this.assistanceGiven,
      interrupted:
          data.interrupted.present ? data.interrupted.value : this.interrupted,
      technicalIssue:
          data.technicalIssue.present
              ? data.technicalIssue.value
              : this.technicalIssue,
      invalidReason:
          data.invalidReason.present
              ? data.invalidReason.value
              : this.invalidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrialLog(')
          ..write('sessionId: $sessionId, ')
          ..write('trialId: $trialId, ')
          ..write('trialType: $trialType, ')
          ..write('trialName: $trialName, ')
          ..write('trialStartTime: $trialStartTime, ')
          ..write('trialEndTime: $trialEndTime, ')
          ..write('conditionId: $conditionId, ')
          ..write('conditionName: $conditionName, ')
          ..write('comment: $comment, ')
          ..write('validTrial: $validTrial, ')
          ..write('assistanceGiven: $assistanceGiven, ')
          ..write('interrupted: $interrupted, ')
          ..write('technicalIssue: $technicalIssue, ')
          ..write('invalidReason: $invalidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    trialId,
    trialType,
    trialName,
    trialStartTime,
    trialEndTime,
    conditionId,
    conditionName,
    comment,
    validTrial,
    assistanceGiven,
    interrupted,
    technicalIssue,
    invalidReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrialLog &&
          other.sessionId == this.sessionId &&
          other.trialId == this.trialId &&
          other.trialType == this.trialType &&
          other.trialName == this.trialName &&
          other.trialStartTime == this.trialStartTime &&
          other.trialEndTime == this.trialEndTime &&
          other.conditionId == this.conditionId &&
          other.conditionName == this.conditionName &&
          other.comment == this.comment &&
          other.validTrial == this.validTrial &&
          other.assistanceGiven == this.assistanceGiven &&
          other.interrupted == this.interrupted &&
          other.technicalIssue == this.technicalIssue &&
          other.invalidReason == this.invalidReason);
}

class TrialLogsCompanion extends UpdateCompanion<TrialLog> {
  final Value<String?> sessionId;
  final Value<String> trialId;
  final Value<String?> trialType;
  final Value<String?> trialName;
  final Value<int?> trialStartTime;
  final Value<int?> trialEndTime;
  final Value<String?> conditionId;
  final Value<String?> conditionName;
  final Value<String?> comment;
  final Value<int?> validTrial;
  final Value<int?> assistanceGiven;
  final Value<int?> interrupted;
  final Value<int?> technicalIssue;
  final Value<String?> invalidReason;
  final Value<int> rowid;
  const TrialLogsCompanion({
    this.sessionId = const Value.absent(),
    this.trialId = const Value.absent(),
    this.trialType = const Value.absent(),
    this.trialName = const Value.absent(),
    this.trialStartTime = const Value.absent(),
    this.trialEndTime = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.conditionName = const Value.absent(),
    this.comment = const Value.absent(),
    this.validTrial = const Value.absent(),
    this.assistanceGiven = const Value.absent(),
    this.interrupted = const Value.absent(),
    this.technicalIssue = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrialLogsCompanion.insert({
    this.sessionId = const Value.absent(),
    required String trialId,
    this.trialType = const Value.absent(),
    this.trialName = const Value.absent(),
    this.trialStartTime = const Value.absent(),
    this.trialEndTime = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.conditionName = const Value.absent(),
    this.comment = const Value.absent(),
    this.validTrial = const Value.absent(),
    this.assistanceGiven = const Value.absent(),
    this.interrupted = const Value.absent(),
    this.technicalIssue = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : trialId = Value(trialId);
  static Insertable<TrialLog> custom({
    Expression<String>? sessionId,
    Expression<String>? trialId,
    Expression<String>? trialType,
    Expression<String>? trialName,
    Expression<int>? trialStartTime,
    Expression<int>? trialEndTime,
    Expression<String>? conditionId,
    Expression<String>? conditionName,
    Expression<String>? comment,
    Expression<int>? validTrial,
    Expression<int>? assistanceGiven,
    Expression<int>? interrupted,
    Expression<int>? technicalIssue,
    Expression<String>? invalidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (trialId != null) 'trial_id': trialId,
      if (trialType != null) 'trial_type': trialType,
      if (trialName != null) 'trial_name': trialName,
      if (trialStartTime != null) 'trial_start_time': trialStartTime,
      if (trialEndTime != null) 'trial_end_time': trialEndTime,
      if (conditionId != null) 'condition_id': conditionId,
      if (conditionName != null) 'condition_name': conditionName,
      if (comment != null) 'comment': comment,
      if (validTrial != null) 'valid_trial': validTrial,
      if (assistanceGiven != null) 'assistance_given': assistanceGiven,
      if (interrupted != null) 'interrupted': interrupted,
      if (technicalIssue != null) 'technical_issue': technicalIssue,
      if (invalidReason != null) 'invalid_reason': invalidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrialLogsCompanion copyWith({
    Value<String?>? sessionId,
    Value<String>? trialId,
    Value<String?>? trialType,
    Value<String?>? trialName,
    Value<int?>? trialStartTime,
    Value<int?>? trialEndTime,
    Value<String?>? conditionId,
    Value<String?>? conditionName,
    Value<String?>? comment,
    Value<int?>? validTrial,
    Value<int?>? assistanceGiven,
    Value<int?>? interrupted,
    Value<int?>? technicalIssue,
    Value<String?>? invalidReason,
    Value<int>? rowid,
  }) {
    return TrialLogsCompanion(
      sessionId: sessionId ?? this.sessionId,
      trialId: trialId ?? this.trialId,
      trialType: trialType ?? this.trialType,
      trialName: trialName ?? this.trialName,
      trialStartTime: trialStartTime ?? this.trialStartTime,
      trialEndTime: trialEndTime ?? this.trialEndTime,
      conditionId: conditionId ?? this.conditionId,
      conditionName: conditionName ?? this.conditionName,
      comment: comment ?? this.comment,
      validTrial: validTrial ?? this.validTrial,
      assistanceGiven: assistanceGiven ?? this.assistanceGiven,
      interrupted: interrupted ?? this.interrupted,
      technicalIssue: technicalIssue ?? this.technicalIssue,
      invalidReason: invalidReason ?? this.invalidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (trialId.present) {
      map['trial_id'] = Variable<String>(trialId.value);
    }
    if (trialType.present) {
      map['trial_type'] = Variable<String>(trialType.value);
    }
    if (trialName.present) {
      map['trial_name'] = Variable<String>(trialName.value);
    }
    if (trialStartTime.present) {
      map['trial_start_time'] = Variable<int>(trialStartTime.value);
    }
    if (trialEndTime.present) {
      map['trial_end_time'] = Variable<int>(trialEndTime.value);
    }
    if (conditionId.present) {
      map['condition_id'] = Variable<String>(conditionId.value);
    }
    if (conditionName.present) {
      map['condition_name'] = Variable<String>(conditionName.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (validTrial.present) {
      map['valid_trial'] = Variable<int>(validTrial.value);
    }
    if (assistanceGiven.present) {
      map['assistance_given'] = Variable<int>(assistanceGiven.value);
    }
    if (interrupted.present) {
      map['interrupted'] = Variable<int>(interrupted.value);
    }
    if (technicalIssue.present) {
      map['technical_issue'] = Variable<int>(technicalIssue.value);
    }
    if (invalidReason.present) {
      map['invalid_reason'] = Variable<String>(invalidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrialLogsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('trialId: $trialId, ')
          ..write('trialType: $trialType, ')
          ..write('trialName: $trialName, ')
          ..write('trialStartTime: $trialStartTime, ')
          ..write('trialEndTime: $trialEndTime, ')
          ..write('conditionId: $conditionId, ')
          ..write('conditionName: $conditionName, ')
          ..write('comment: $comment, ')
          ..write('validTrial: $validTrial, ')
          ..write('assistanceGiven: $assistanceGiven, ')
          ..write('interrupted: $interrupted, ')
          ..write('technicalIssue: $technicalIssue, ')
          ..write('invalidReason: $invalidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventLogsTable extends EventLogs
    with TableInfo<$EventLogsTable, EventLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trialIdMeta = const VerificationMeta(
    'trialId',
  );
  @override
  late final GeneratedColumn<String> trialId = GeneratedColumn<String>(
    'trial_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventTimestampMeta = const VerificationMeta(
    'eventTimestamp',
  );
  @override
  late final GeneratedColumn<int> eventTimestamp = GeneratedColumn<int>(
    'event_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trialId,
    eventId,
    eventType,
    eventTimestamp,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trial_id')) {
      context.handle(
        _trialIdMeta,
        trialId.isAcceptableOrUnknown(data['trial_id']!, _trialIdMeta),
      );
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    }
    if (data.containsKey('event_timestamp')) {
      context.handle(
        _eventTimestampMeta,
        eventTimestamp.isAcceptableOrUnknown(
          data['event_timestamp']!,
          _eventTimestampMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  EventLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventLog(
      trialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_id'],
      ),
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_id'],
          )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      ),
      eventTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_timestamp'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
    );
  }

  @override
  $EventLogsTable createAlias(String alias) {
    return $EventLogsTable(attachedDatabase, alias);
  }
}

class EventLog extends DataClass implements Insertable<EventLog> {
  final String? trialId;
  final String eventId;
  final String? eventType;
  final int? eventTimestamp;
  final String? payloadJson;
  const EventLog({
    this.trialId,
    required this.eventId,
    this.eventType,
    this.eventTimestamp,
    this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || trialId != null) {
      map['trial_id'] = Variable<String>(trialId);
    }
    map['event_id'] = Variable<String>(eventId);
    if (!nullToAbsent || eventType != null) {
      map['event_type'] = Variable<String>(eventType);
    }
    if (!nullToAbsent || eventTimestamp != null) {
      map['event_timestamp'] = Variable<int>(eventTimestamp);
    }
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    return map;
  }

  EventLogsCompanion toCompanion(bool nullToAbsent) {
    return EventLogsCompanion(
      trialId:
          trialId == null && nullToAbsent
              ? const Value.absent()
              : Value(trialId),
      eventId: Value(eventId),
      eventType:
          eventType == null && nullToAbsent
              ? const Value.absent()
              : Value(eventType),
      eventTimestamp:
          eventTimestamp == null && nullToAbsent
              ? const Value.absent()
              : Value(eventTimestamp),
      payloadJson:
          payloadJson == null && nullToAbsent
              ? const Value.absent()
              : Value(payloadJson),
    );
  }

  factory EventLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventLog(
      trialId: serializer.fromJson<String?>(json['trialId']),
      eventId: serializer.fromJson<String>(json['eventId']),
      eventType: serializer.fromJson<String?>(json['eventType']),
      eventTimestamp: serializer.fromJson<int?>(json['eventTimestamp']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trialId': serializer.toJson<String?>(trialId),
      'eventId': serializer.toJson<String>(eventId),
      'eventType': serializer.toJson<String?>(eventType),
      'eventTimestamp': serializer.toJson<int?>(eventTimestamp),
      'payloadJson': serializer.toJson<String?>(payloadJson),
    };
  }

  EventLog copyWith({
    Value<String?> trialId = const Value.absent(),
    String? eventId,
    Value<String?> eventType = const Value.absent(),
    Value<int?> eventTimestamp = const Value.absent(),
    Value<String?> payloadJson = const Value.absent(),
  }) => EventLog(
    trialId: trialId.present ? trialId.value : this.trialId,
    eventId: eventId ?? this.eventId,
    eventType: eventType.present ? eventType.value : this.eventType,
    eventTimestamp:
        eventTimestamp.present ? eventTimestamp.value : this.eventTimestamp,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
  );
  EventLog copyWithCompanion(EventLogsCompanion data) {
    return EventLog(
      trialId: data.trialId.present ? data.trialId.value : this.trialId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      eventTimestamp:
          data.eventTimestamp.present
              ? data.eventTimestamp.value
              : this.eventTimestamp,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventLog(')
          ..write('trialId: $trialId, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(trialId, eventId, eventType, eventTimestamp, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventLog &&
          other.trialId == this.trialId &&
          other.eventId == this.eventId &&
          other.eventType == this.eventType &&
          other.eventTimestamp == this.eventTimestamp &&
          other.payloadJson == this.payloadJson);
}

class EventLogsCompanion extends UpdateCompanion<EventLog> {
  final Value<String?> trialId;
  final Value<String> eventId;
  final Value<String?> eventType;
  final Value<int?> eventTimestamp;
  final Value<String?> payloadJson;
  final Value<int> rowid;
  const EventLogsCompanion({
    this.trialId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventTimestamp = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventLogsCompanion.insert({
    this.trialId = const Value.absent(),
    required String eventId,
    this.eventType = const Value.absent(),
    this.eventTimestamp = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId);
  static Insertable<EventLog> custom({
    Expression<String>? trialId,
    Expression<String>? eventId,
    Expression<String>? eventType,
    Expression<int>? eventTimestamp,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trialId != null) 'trial_id': trialId,
      if (eventId != null) 'event_id': eventId,
      if (eventType != null) 'event_type': eventType,
      if (eventTimestamp != null) 'event_timestamp': eventTimestamp,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventLogsCompanion copyWith({
    Value<String?>? trialId,
    Value<String>? eventId,
    Value<String?>? eventType,
    Value<int?>? eventTimestamp,
    Value<String?>? payloadJson,
    Value<int>? rowid,
  }) {
    return EventLogsCompanion(
      trialId: trialId ?? this.trialId,
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      eventTimestamp: eventTimestamp ?? this.eventTimestamp,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trialId.present) {
      map['trial_id'] = Variable<String>(trialId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (eventTimestamp.present) {
      map['event_timestamp'] = Variable<int>(eventTimestamp.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventLogsCompanion(')
          ..write('trialId: $trialId, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $DictionaryEntriesTable dictionaryEntries =
      $DictionaryEntriesTable(this);
  late final $ConvertedFilesTable convertedFiles = $ConvertedFilesTable(this);
  late final $SystemConfigsTable systemConfigs = $SystemConfigsTable(this);
  late final $HighlightsTable highlights = $HighlightsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $TrialLogsTable trialLogs = $TrialLogsTable(this);
  late final $EventLogsTable eventLogs = $EventLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    lessons,
    dictionaryEntries,
    convertedFiles,
    systemConfigs,
    highlights,
    sessions,
    trialLogs,
    eventLogs,
  ];
}

typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      required String id,
      Value<String?> name,
      Value<int?> type,
      Value<String?> description,
      Value<String?> content,
      Value<int?> difficulty,
      Value<int?> dateCreated,
      Value<int?> isDone,
      Value<int> rowid,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<int?> type,
      Value<String?> description,
      Value<String?> content,
      Value<int?> difficulty,
      Value<int?> dateCreated,
      Value<int?> isDone,
      Value<int> rowid,
    });

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
          Lesson,
          PrefetchHooks Function()
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<int?> dateCreated = const Value.absent(),
                Value<int?> isDone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                name: name,
                type: type,
                description: description,
                content: content,
                difficulty: difficulty,
                dateCreated: dateCreated,
                isDone: isDone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<int?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<int?> dateCreated = const Value.absent(),
                Value<int?> isDone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                name: name,
                type: type,
                description: description,
                content: content,
                difficulty: difficulty,
                dateCreated: dateCreated,
                isDone: isDone,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$LessonsTable, Lesson>(table),
                          BaseReferences<_$AppDatabase, $LessonsTable, Lesson>(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
      Lesson,
      PrefetchHooks Function()
    >;
typedef $$DictionaryEntriesTableCreateCompanionBuilder =
    DictionaryEntriesCompanion Function({
      required String id,
      Value<String?> word,
      Value<String?> description,
      Value<String?> imageName,
      Value<int> rowid,
    });
typedef $$DictionaryEntriesTableUpdateCompanionBuilder =
    DictionaryEntriesCompanion Function({
      Value<String> id,
      Value<String?> word,
      Value<String?> description,
      Value<String?> imageName,
      Value<int> rowid,
    });

class $$DictionaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageName => $composableBuilder(
    column: $table.imageName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DictionaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageName => $composableBuilder(
    column: $table.imageName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DictionaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageName =>
      $composableBuilder(column: $table.imageName, builder: (column) => column);
}

class $$DictionaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DictionaryEntriesTable,
          DictionaryEntry,
          $$DictionaryEntriesTableFilterComposer,
          $$DictionaryEntriesTableOrderingComposer,
          $$DictionaryEntriesTableAnnotationComposer,
          $$DictionaryEntriesTableCreateCompanionBuilder,
          $$DictionaryEntriesTableUpdateCompanionBuilder,
          (
            DictionaryEntry,
            BaseReferences<
              _$AppDatabase,
              $DictionaryEntriesTable,
              DictionaryEntry
            >,
          ),
          DictionaryEntry,
          PrefetchHooks Function()
        > {
  $$DictionaryEntriesTableTableManager(
    _$AppDatabase db,
    $DictionaryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DictionaryEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$DictionaryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$DictionaryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> word = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DictionaryEntriesCompanion(
                id: id,
                word: word,
                description: description,
                imageName: imageName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> word = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DictionaryEntriesCompanion.insert(
                id: id,
                word: word,
                description: description,
                imageName: imageName,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$DictionaryEntriesTable, DictionaryEntry>(
                            table,
                          ),
                          BaseReferences<
                            _$AppDatabase,
                            $DictionaryEntriesTable,
                            DictionaryEntry
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DictionaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DictionaryEntriesTable,
      DictionaryEntry,
      $$DictionaryEntriesTableFilterComposer,
      $$DictionaryEntriesTableOrderingComposer,
      $$DictionaryEntriesTableAnnotationComposer,
      $$DictionaryEntriesTableCreateCompanionBuilder,
      $$DictionaryEntriesTableUpdateCompanionBuilder,
      (
        DictionaryEntry,
        BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntry>,
      ),
      DictionaryEntry,
      PrefetchHooks Function()
    >;
typedef $$ConvertedFilesTableCreateCompanionBuilder =
    ConvertedFilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> extractedText,
      Value<int?> createdDate,
    });
typedef $$ConvertedFilesTableUpdateCompanionBuilder =
    ConvertedFilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> extractedText,
      Value<int?> createdDate,
    });

class $$ConvertedFilesTableFilterComposer
    extends Composer<_$AppDatabase, $ConvertedFilesTable> {
  $$ConvertedFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConvertedFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConvertedFilesTable> {
  $$ConvertedFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConvertedFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConvertedFilesTable> {
  $$ConvertedFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$ConvertedFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConvertedFilesTable,
          ConvertedFile,
          $$ConvertedFilesTableFilterComposer,
          $$ConvertedFilesTableOrderingComposer,
          $$ConvertedFilesTableAnnotationComposer,
          $$ConvertedFilesTableCreateCompanionBuilder,
          $$ConvertedFilesTableUpdateCompanionBuilder,
          (
            ConvertedFile,
            BaseReferences<_$AppDatabase, $ConvertedFilesTable, ConvertedFile>,
          ),
          ConvertedFile,
          PrefetchHooks Function()
        > {
  $$ConvertedFilesTableTableManager(
    _$AppDatabase db,
    $ConvertedFilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ConvertedFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ConvertedFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ConvertedFilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                Value<int?> createdDate = const Value.absent(),
              }) => ConvertedFilesCompanion(
                id: id,
                name: name,
                extractedText: extractedText,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                Value<int?> createdDate = const Value.absent(),
              }) => ConvertedFilesCompanion.insert(
                id: id,
                name: name,
                extractedText: extractedText,
                createdDate: createdDate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$ConvertedFilesTable, ConvertedFile>(
                            table,
                          ),
                          BaseReferences<
                            _$AppDatabase,
                            $ConvertedFilesTable,
                            ConvertedFile
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConvertedFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConvertedFilesTable,
      ConvertedFile,
      $$ConvertedFilesTableFilterComposer,
      $$ConvertedFilesTableOrderingComposer,
      $$ConvertedFilesTableAnnotationComposer,
      $$ConvertedFilesTableCreateCompanionBuilder,
      $$ConvertedFilesTableUpdateCompanionBuilder,
      (
        ConvertedFile,
        BaseReferences<_$AppDatabase, $ConvertedFilesTable, ConvertedFile>,
      ),
      ConvertedFile,
      PrefetchHooks Function()
    >;
typedef $$SystemConfigsTableCreateCompanionBuilder =
    SystemConfigsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$SystemConfigsTableUpdateCompanionBuilder =
    SystemConfigsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$SystemConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SystemConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemConfigsTable,
          SystemConfig,
          $$SystemConfigsTableFilterComposer,
          $$SystemConfigsTableOrderingComposer,
          $$SystemConfigsTableAnnotationComposer,
          $$SystemConfigsTableCreateCompanionBuilder,
          $$SystemConfigsTableUpdateCompanionBuilder,
          (
            SystemConfig,
            BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>,
          ),
          SystemConfig,
          PrefetchHooks Function()
        > {
  $$SystemConfigsTableTableManager(_$AppDatabase db, $SystemConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SystemConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SystemConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SystemConfigsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SystemConfigsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemConfigsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$SystemConfigsTable, SystemConfig>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $SystemConfigsTable,
                            SystemConfig
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemConfigsTable,
      SystemConfig,
      $$SystemConfigsTableFilterComposer,
      $$SystemConfigsTableOrderingComposer,
      $$SystemConfigsTableAnnotationComposer,
      $$SystemConfigsTableCreateCompanionBuilder,
      $$SystemConfigsTableUpdateCompanionBuilder,
      (
        SystemConfig,
        BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>,
      ),
      SystemConfig,
      PrefetchHooks Function()
    >;
typedef $$HighlightsTableCreateCompanionBuilder =
    HighlightsCompanion Function({Value<int> id, required String content});
typedef $$HighlightsTableUpdateCompanionBuilder =
    HighlightsCompanion Function({Value<int> id, Value<String> content});

class $$HighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $$HighlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightsTable,
          Highlight,
          $$HighlightsTableFilterComposer,
          $$HighlightsTableOrderingComposer,
          $$HighlightsTableAnnotationComposer,
          $$HighlightsTableCreateCompanionBuilder,
          $$HighlightsTableUpdateCompanionBuilder,
          (
            Highlight,
            BaseReferences<_$AppDatabase, $HighlightsTable, Highlight>,
          ),
          Highlight,
          PrefetchHooks Function()
        > {
  $$HighlightsTableTableManager(_$AppDatabase db, $HighlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$HighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
              }) => HighlightsCompanion(id: id, content: content),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
              }) => HighlightsCompanion.insert(id: id, content: content),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$HighlightsTable, Highlight>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $HighlightsTable,
                            Highlight
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HighlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightsTable,
      Highlight,
      $$HighlightsTableFilterComposer,
      $$HighlightsTableOrderingComposer,
      $$HighlightsTableAnnotationComposer,
      $$HighlightsTableCreateCompanionBuilder,
      $$HighlightsTableUpdateCompanionBuilder,
      (Highlight, BaseReferences<_$AppDatabase, $HighlightsTable, Highlight>),
      Highlight,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String sessionId,
      Value<String?> studentId,
      Value<String?> sessionStartTime,
      Value<String?> sessionEndTime,
      Value<String?> examinerId,
      Value<String?> siteId,
      Value<String?> device,
      Value<double?> screenWidth,
      Value<double?> screenHeight,
      Value<String?> appVersion,
      Value<String?> webVersion,
      Value<int?> completed,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> sessionId,
      Value<String?> studentId,
      Value<String?> sessionStartTime,
      Value<String?> sessionEndTime,
      Value<String?> examinerId,
      Value<String?> siteId,
      Value<String?> device,
      Value<double?> screenWidth,
      Value<double?> screenHeight,
      Value<String?> appVersion,
      Value<String?> webVersion,
      Value<int?> completed,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionStartTime => $composableBuilder(
    column: $table.sessionStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionEndTime => $composableBuilder(
    column: $table.sessionEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examinerId => $composableBuilder(
    column: $table.examinerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get screenWidth => $composableBuilder(
    column: $table.screenWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get screenHeight => $composableBuilder(
    column: $table.screenHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get webVersion => $composableBuilder(
    column: $table.webVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionStartTime => $composableBuilder(
    column: $table.sessionStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionEndTime => $composableBuilder(
    column: $table.sessionEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examinerId => $composableBuilder(
    column: $table.examinerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get screenWidth => $composableBuilder(
    column: $table.screenWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get screenHeight => $composableBuilder(
    column: $table.screenHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get webVersion => $composableBuilder(
    column: $table.webVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get sessionStartTime => $composableBuilder(
    column: $table.sessionStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionEndTime => $composableBuilder(
    column: $table.sessionEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get examinerId => $composableBuilder(
    column: $table.examinerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get device =>
      $composableBuilder(column: $table.device, builder: (column) => column);

  GeneratedColumn<double> get screenWidth => $composableBuilder(
    column: $table.screenWidth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get screenHeight => $composableBuilder(
    column: $table.screenHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get webVersion => $composableBuilder(
    column: $table.webVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String?> studentId = const Value.absent(),
                Value<String?> sessionStartTime = const Value.absent(),
                Value<String?> sessionEndTime = const Value.absent(),
                Value<String?> examinerId = const Value.absent(),
                Value<String?> siteId = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<double?> screenWidth = const Value.absent(),
                Value<double?> screenHeight = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<String?> webVersion = const Value.absent(),
                Value<int?> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                sessionId: sessionId,
                studentId: studentId,
                sessionStartTime: sessionStartTime,
                sessionEndTime: sessionEndTime,
                examinerId: examinerId,
                siteId: siteId,
                device: device,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                appVersion: appVersion,
                webVersion: webVersion,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                Value<String?> studentId = const Value.absent(),
                Value<String?> sessionStartTime = const Value.absent(),
                Value<String?> sessionEndTime = const Value.absent(),
                Value<String?> examinerId = const Value.absent(),
                Value<String?> siteId = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<double?> screenWidth = const Value.absent(),
                Value<double?> screenHeight = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<String?> webVersion = const Value.absent(),
                Value<int?> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                sessionId: sessionId,
                studentId: studentId,
                sessionStartTime: sessionStartTime,
                sessionEndTime: sessionEndTime,
                examinerId: examinerId,
                siteId: siteId,
                device: device,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                appVersion: appVersion,
                webVersion: webVersion,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$SessionsTable, Session>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $SessionsTable,
                            Session
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$TrialLogsTableCreateCompanionBuilder =
    TrialLogsCompanion Function({
      Value<String?> sessionId,
      required String trialId,
      Value<String?> trialType,
      Value<String?> trialName,
      Value<int?> trialStartTime,
      Value<int?> trialEndTime,
      Value<String?> conditionId,
      Value<String?> conditionName,
      Value<String?> comment,
      Value<int?> validTrial,
      Value<int?> assistanceGiven,
      Value<int?> interrupted,
      Value<int?> technicalIssue,
      Value<String?> invalidReason,
      Value<int> rowid,
    });
typedef $$TrialLogsTableUpdateCompanionBuilder =
    TrialLogsCompanion Function({
      Value<String?> sessionId,
      Value<String> trialId,
      Value<String?> trialType,
      Value<String?> trialName,
      Value<int?> trialStartTime,
      Value<int?> trialEndTime,
      Value<String?> conditionId,
      Value<String?> conditionName,
      Value<String?> comment,
      Value<int?> validTrial,
      Value<int?> assistanceGiven,
      Value<int?> interrupted,
      Value<int?> technicalIssue,
      Value<String?> invalidReason,
      Value<int> rowid,
    });

class $$TrialLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trialType => $composableBuilder(
    column: $table.trialType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trialName => $composableBuilder(
    column: $table.trialName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trialStartTime => $composableBuilder(
    column: $table.trialStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trialEndTime => $composableBuilder(
    column: $table.trialEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionName => $composableBuilder(
    column: $table.conditionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validTrial => $composableBuilder(
    column: $table.validTrial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assistanceGiven => $composableBuilder(
    column: $table.assistanceGiven,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get technicalIssue => $composableBuilder(
    column: $table.technicalIssue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrialLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trialType => $composableBuilder(
    column: $table.trialType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trialName => $composableBuilder(
    column: $table.trialName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trialStartTime => $composableBuilder(
    column: $table.trialStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trialEndTime => $composableBuilder(
    column: $table.trialEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionName => $composableBuilder(
    column: $table.conditionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validTrial => $composableBuilder(
    column: $table.validTrial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assistanceGiven => $composableBuilder(
    column: $table.assistanceGiven,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get technicalIssue => $composableBuilder(
    column: $table.technicalIssue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrialLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get trialId =>
      $composableBuilder(column: $table.trialId, builder: (column) => column);

  GeneratedColumn<String> get trialType =>
      $composableBuilder(column: $table.trialType, builder: (column) => column);

  GeneratedColumn<String> get trialName =>
      $composableBuilder(column: $table.trialName, builder: (column) => column);

  GeneratedColumn<int> get trialStartTime => $composableBuilder(
    column: $table.trialStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trialEndTime => $composableBuilder(
    column: $table.trialEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionName => $composableBuilder(
    column: $table.conditionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get validTrial => $composableBuilder(
    column: $table.validTrial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assistanceGiven => $composableBuilder(
    column: $table.assistanceGiven,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get technicalIssue => $composableBuilder(
    column: $table.technicalIssue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => column,
  );
}

class $$TrialLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrialLogsTable,
          TrialLog,
          $$TrialLogsTableFilterComposer,
          $$TrialLogsTableOrderingComposer,
          $$TrialLogsTableAnnotationComposer,
          $$TrialLogsTableCreateCompanionBuilder,
          $$TrialLogsTableUpdateCompanionBuilder,
          (TrialLog, BaseReferences<_$AppDatabase, $TrialLogsTable, TrialLog>),
          TrialLog,
          PrefetchHooks Function()
        > {
  $$TrialLogsTableTableManager(_$AppDatabase db, $TrialLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TrialLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TrialLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TrialLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> sessionId = const Value.absent(),
                Value<String> trialId = const Value.absent(),
                Value<String?> trialType = const Value.absent(),
                Value<String?> trialName = const Value.absent(),
                Value<int?> trialStartTime = const Value.absent(),
                Value<int?> trialEndTime = const Value.absent(),
                Value<String?> conditionId = const Value.absent(),
                Value<String?> conditionName = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> validTrial = const Value.absent(),
                Value<int?> assistanceGiven = const Value.absent(),
                Value<int?> interrupted = const Value.absent(),
                Value<int?> technicalIssue = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrialLogsCompanion(
                sessionId: sessionId,
                trialId: trialId,
                trialType: trialType,
                trialName: trialName,
                trialStartTime: trialStartTime,
                trialEndTime: trialEndTime,
                conditionId: conditionId,
                conditionName: conditionName,
                comment: comment,
                validTrial: validTrial,
                assistanceGiven: assistanceGiven,
                interrupted: interrupted,
                technicalIssue: technicalIssue,
                invalidReason: invalidReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> sessionId = const Value.absent(),
                required String trialId,
                Value<String?> trialType = const Value.absent(),
                Value<String?> trialName = const Value.absent(),
                Value<int?> trialStartTime = const Value.absent(),
                Value<int?> trialEndTime = const Value.absent(),
                Value<String?> conditionId = const Value.absent(),
                Value<String?> conditionName = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> validTrial = const Value.absent(),
                Value<int?> assistanceGiven = const Value.absent(),
                Value<int?> interrupted = const Value.absent(),
                Value<int?> technicalIssue = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrialLogsCompanion.insert(
                sessionId: sessionId,
                trialId: trialId,
                trialType: trialType,
                trialName: trialName,
                trialStartTime: trialStartTime,
                trialEndTime: trialEndTime,
                conditionId: conditionId,
                conditionName: conditionName,
                comment: comment,
                validTrial: validTrial,
                assistanceGiven: assistanceGiven,
                interrupted: interrupted,
                technicalIssue: technicalIssue,
                invalidReason: invalidReason,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$TrialLogsTable, TrialLog>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $TrialLogsTable,
                            TrialLog
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrialLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrialLogsTable,
      TrialLog,
      $$TrialLogsTableFilterComposer,
      $$TrialLogsTableOrderingComposer,
      $$TrialLogsTableAnnotationComposer,
      $$TrialLogsTableCreateCompanionBuilder,
      $$TrialLogsTableUpdateCompanionBuilder,
      (TrialLog, BaseReferences<_$AppDatabase, $TrialLogsTable, TrialLog>),
      TrialLog,
      PrefetchHooks Function()
    >;
typedef $$EventLogsTableCreateCompanionBuilder =
    EventLogsCompanion Function({
      Value<String?> trialId,
      required String eventId,
      Value<String?> eventType,
      Value<int?> eventTimestamp,
      Value<String?> payloadJson,
      Value<int> rowid,
    });
typedef $$EventLogsTableUpdateCompanionBuilder =
    EventLogsCompanion Function({
      Value<String?> trialId,
      Value<String> eventId,
      Value<String?> eventType,
      Value<int?> eventTimestamp,
      Value<String?> payloadJson,
      Value<int> rowid,
    });

class $$EventLogsTableFilterComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trialId =>
      $composableBuilder(column: $table.trialId, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$EventLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventLogsTable,
          EventLog,
          $$EventLogsTableFilterComposer,
          $$EventLogsTableOrderingComposer,
          $$EventLogsTableAnnotationComposer,
          $$EventLogsTableCreateCompanionBuilder,
          $$EventLogsTableUpdateCompanionBuilder,
          (EventLog, BaseReferences<_$AppDatabase, $EventLogsTable, EventLog>),
          EventLog,
          PrefetchHooks Function()
        > {
  $$EventLogsTableTableManager(_$AppDatabase db, $EventLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EventLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EventLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> trialId = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String?> eventType = const Value.absent(),
                Value<int?> eventTimestamp = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventLogsCompanion(
                trialId: trialId,
                eventId: eventId,
                eventType: eventType,
                eventTimestamp: eventTimestamp,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> trialId = const Value.absent(),
                required String eventId,
                Value<String?> eventType = const Value.absent(),
                Value<int?> eventTimestamp = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventLogsCompanion.insert(
                trialId: trialId,
                eventId: eventId,
                eventType: eventType,
                eventTimestamp: eventTimestamp,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$EventLogsTable, EventLog>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $EventLogsTable,
                            EventLog
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventLogsTable,
      EventLog,
      $$EventLogsTableFilterComposer,
      $$EventLogsTableOrderingComposer,
      $$EventLogsTableAnnotationComposer,
      $$EventLogsTableCreateCompanionBuilder,
      $$EventLogsTableUpdateCompanionBuilder,
      (EventLog, BaseReferences<_$AppDatabase, $EventLogsTable, EventLog>),
      EventLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$DictionaryEntriesTableTableManager get dictionaryEntries =>
      $$DictionaryEntriesTableTableManager(_db, _db.dictionaryEntries);
  $$ConvertedFilesTableTableManager get convertedFiles =>
      $$ConvertedFilesTableTableManager(_db, _db.convertedFiles);
  $$SystemConfigsTableTableManager get systemConfigs =>
      $$SystemConfigsTableTableManager(_db, _db.systemConfigs);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db, _db.highlights);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$TrialLogsTableTableManager get trialLogs =>
      $$TrialLogsTableTableManager(_db, _db.trialLogs);
  $$EventLogsTableTableManager get eventLogs =>
      $$EventLogsTableTableManager(_db, _db.eventLogs);
}
