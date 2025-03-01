import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'diary_table.dart';
import 'dao_diary.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Diaries], daos: [DiaryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  DiaryDao get diaryDao => DiaryDao(this);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'diary.db'));
    return NativeDatabase(file);
  });
}
