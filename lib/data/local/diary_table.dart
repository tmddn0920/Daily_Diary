import 'package:drift/drift.dart';

class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get emotion => integer()();
  TextColumn get content => text()();
  IntColumn get textAlign => integer().withDefault(Constant(0))();
  BoolColumn get isBold => boolean().withDefault(Constant(false))();
}

