import 'package:drift/drift.dart';
import 'database.dart';
import 'diary_table.dart';

part 'dao_diary.g.dart';

@DriftAccessor(tables: [Diaries])
class DiaryDao extends DatabaseAccessor<AppDatabase> with _$DiaryDaoMixin {
  DiaryDao(AppDatabase db) : super(db);

  Future<List<Diary>> getAllDiaries() => select(diaries).get();

  Future<List<Diary>> getDiariesForMonth(
      DateTime startOfMonth, DateTime endOfMonth) {
    return (select(diaries)
          ..where((tbl) => tbl.date.isBetweenValues(startOfMonth, endOfMonth)))
        .get();
  }

  Future<Diary?> getDiaryByDate(DateTime date) {
    return (select(diaries)..where((tbl) => tbl.date.equals(date)))
        .getSingleOrNull();
  }

  Future<int> insertDiary(DiariesCompanion diary) =>
      into(diaries).insert(diary);

  Future<bool> updateDiary(Diary diary) => update(diaries).replace(diary);

  Future<int> deleteDiary(int id) =>
      (delete(diaries)..where((tbl) => tbl.id.equals(id))).go();
}
