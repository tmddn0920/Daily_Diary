// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DiariesTable extends Diaries with TableInfo<$DiariesTable, Diary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _emotionMeta =
      const VerificationMeta('emotion');
  @override
  late final GeneratedColumn<int> emotion = GeneratedColumn<int>(
      'emotion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textAlignMeta =
      const VerificationMeta('textAlign');
  @override
  late final GeneratedColumn<int> textAlign = GeneratedColumn<int>(
      'text_align', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _isBoldMeta = const VerificationMeta('isBold');
  @override
  late final GeneratedColumn<bool> isBold = GeneratedColumn<bool>(
      'is_bold', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bold" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, emotion, content, textAlign, isBold];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  VerificationContext validateIntegrity(Insertable<Diary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('emotion')) {
      context.handle(_emotionMeta,
          emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta));
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('text_align')) {
      context.handle(_textAlignMeta,
          textAlign.isAcceptableOrUnknown(data['text_align']!, _textAlignMeta));
    }
    if (data.containsKey('is_bold')) {
      context.handle(_isBoldMeta,
          isBold.isAcceptableOrUnknown(data['is_bold']!, _isBoldMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Diary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      emotion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}emotion'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      textAlign: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}text_align'])!,
      isBold: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bold'])!,
    );
  }

  @override
  $DiariesTable createAlias(String alias) {
    return $DiariesTable(attachedDatabase, alias);
  }
}

class Diary extends DataClass implements Insertable<Diary> {
  final int id;
  final DateTime date;
  final int emotion;
  final String content;
  final int textAlign;
  final bool isBold;
  const Diary(
      {required this.id,
      required this.date,
      required this.emotion,
      required this.content,
      required this.textAlign,
      required this.isBold});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['emotion'] = Variable<int>(emotion);
    map['content'] = Variable<String>(content);
    map['text_align'] = Variable<int>(textAlign);
    map['is_bold'] = Variable<bool>(isBold);
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      date: Value(date),
      emotion: Value(emotion),
      content: Value(content),
      textAlign: Value(textAlign),
      isBold: Value(isBold),
    );
  }

  factory Diary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diary(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      emotion: serializer.fromJson<int>(json['emotion']),
      content: serializer.fromJson<String>(json['content']),
      textAlign: serializer.fromJson<int>(json['textAlign']),
      isBold: serializer.fromJson<bool>(json['isBold']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'emotion': serializer.toJson<int>(emotion),
      'content': serializer.toJson<String>(content),
      'textAlign': serializer.toJson<int>(textAlign),
      'isBold': serializer.toJson<bool>(isBold),
    };
  }

  Diary copyWith(
          {int? id,
          DateTime? date,
          int? emotion,
          String? content,
          int? textAlign,
          bool? isBold}) =>
      Diary(
        id: id ?? this.id,
        date: date ?? this.date,
        emotion: emotion ?? this.emotion,
        content: content ?? this.content,
        textAlign: textAlign ?? this.textAlign,
        isBold: isBold ?? this.isBold,
      );
  Diary copyWithCompanion(DiariesCompanion data) {
    return Diary(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      content: data.content.present ? data.content.value : this.content,
      textAlign: data.textAlign.present ? data.textAlign.value : this.textAlign,
      isBold: data.isBold.present ? data.isBold.value : this.isBold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diary(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('emotion: $emotion, ')
          ..write('content: $content, ')
          ..write('textAlign: $textAlign, ')
          ..write('isBold: $isBold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, emotion, content, textAlign, isBold);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diary &&
          other.id == this.id &&
          other.date == this.date &&
          other.emotion == this.emotion &&
          other.content == this.content &&
          other.textAlign == this.textAlign &&
          other.isBold == this.isBold);
}

class DiariesCompanion extends UpdateCompanion<Diary> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> emotion;
  final Value<String> content;
  final Value<int> textAlign;
  final Value<bool> isBold;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.emotion = const Value.absent(),
    this.content = const Value.absent(),
    this.textAlign = const Value.absent(),
    this.isBold = const Value.absent(),
  });
  DiariesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int emotion,
    required String content,
    this.textAlign = const Value.absent(),
    this.isBold = const Value.absent(),
  })  : date = Value(date),
        emotion = Value(emotion),
        content = Value(content);
  static Insertable<Diary> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? emotion,
    Expression<String>? content,
    Expression<int>? textAlign,
    Expression<bool>? isBold,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (emotion != null) 'emotion': emotion,
      if (content != null) 'content': content,
      if (textAlign != null) 'text_align': textAlign,
      if (isBold != null) 'is_bold': isBold,
    });
  }

  DiariesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? emotion,
      Value<String>? content,
      Value<int>? textAlign,
      Value<bool>? isBold}) {
    return DiariesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      emotion: emotion ?? this.emotion,
      content: content ?? this.content,
      textAlign: textAlign ?? this.textAlign,
      isBold: isBold ?? this.isBold,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<int>(emotion.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (textAlign.present) {
      map['text_align'] = Variable<int>(textAlign.value);
    }
    if (isBold.present) {
      map['is_bold'] = Variable<bool>(isBold.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('emotion: $emotion, ')
          ..write('content: $content, ')
          ..write('textAlign: $textAlign, ')
          ..write('isBold: $isBold')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DiariesTable diaries = $DiariesTable(this);
  late final DiaryDao diaryDao = DiaryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [diaries];
}

typedef $$DiariesTableCreateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  required DateTime date,
  required int emotion,
  required String content,
  Value<int> textAlign,
  Value<bool> isBold,
});
typedef $$DiariesTableUpdateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> emotion,
  Value<String> content,
  Value<int> textAlign,
  Value<bool> isBold,
});

class $$DiariesTableFilterComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get emotion => $composableBuilder(
      column: $table.emotion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get textAlign => $composableBuilder(
      column: $table.textAlign, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBold => $composableBuilder(
      column: $table.isBold, builder: (column) => ColumnFilters(column));
}

class $$DiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get emotion => $composableBuilder(
      column: $table.emotion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get textAlign => $composableBuilder(
      column: $table.textAlign, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBold => $composableBuilder(
      column: $table.isBold, builder: (column) => ColumnOrderings(column));
}

class $$DiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get textAlign =>
      $composableBuilder(column: $table.textAlign, builder: (column) => column);

  GeneratedColumn<bool> get isBold =>
      $composableBuilder(column: $table.isBold, builder: (column) => column);
}

class $$DiariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiariesTable,
    Diary,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (Diary, BaseReferences<_$AppDatabase, $DiariesTable, Diary>),
    Diary,
    PrefetchHooks Function()> {
  $$DiariesTableTableManager(_$AppDatabase db, $DiariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> emotion = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> textAlign = const Value.absent(),
            Value<bool> isBold = const Value.absent(),
          }) =>
              DiariesCompanion(
            id: id,
            date: date,
            emotion: emotion,
            content: content,
            textAlign: textAlign,
            isBold: isBold,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int emotion,
            required String content,
            Value<int> textAlign = const Value.absent(),
            Value<bool> isBold = const Value.absent(),
          }) =>
              DiariesCompanion.insert(
            id: id,
            date: date,
            emotion: emotion,
            content: content,
            textAlign: textAlign,
            isBold: isBold,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DiariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiariesTable,
    Diary,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (Diary, BaseReferences<_$AppDatabase, $DiariesTable, Diary>),
    Diary,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db, _db.diaries);
}
