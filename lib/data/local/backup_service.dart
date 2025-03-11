import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// 네이티브 iOS에서 iCloud 디렉토리 가져오기
Future<String?> getICloudDirectory() async {
  if (!Platform.isIOS) return null;

  const platform = MethodChannel('com.seungrain.dailyDiary/icloud');

  try {
    return await platform.invokeMethod<String>('getICloudPath');
  } catch (_) {
    return null;
  }
}

Future<bool> isICloudAvailable() async {
  final iCloudPath = await getICloudDirectory();
  return iCloudPath != null;
}

/// 데이터베이스 경로 가져오기
Future<String> getDatabasePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return join(directory.path, 'diary.db');
}

/// iCloud에 데이터 백업하기
Future<String> backupDatabaseToICloud() async {
  try {
    final dbPath = await getDatabasePath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) return "데이터베이스 파일이 존재하지 않습니다.";

    final iCloudPath = await getICloudDirectory();
    if (iCloudPath == null) return "iCloud가 활성화되지 않았습니다.";

    await dbFile.copy(join(iCloudPath, 'diary_backup.db'));
    return "iCloud에 데이터 백업을 완료했습니다.";
  } catch (e) {
    return "데이터 백업에 실패했습니다.";
  }
}

/// iCloud에서 데이터 복원하기
Future<String> restoreDatabaseFromICloud() async {
  try {
    final iCloudPath = await getICloudDirectory();
    if (iCloudPath == null) return "iCloud가 활성화되지 않았습니다.";

    final backupFile = File(join(iCloudPath, 'diary_backup.db'));
    if (!await backupFile.exists()) return "iCloud에 백업된 데이터가 없습니다.";

    await backupFile.copy(await getDatabasePath());
    return "iCloud에서 데이터 복원을 완료했습니다.";
  } catch (e) {
    return "데이터 복원에 실패했습니다.";
  }
}

