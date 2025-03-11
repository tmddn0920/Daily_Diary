import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:daily_diary/const/color.dart';
import 'package:daily_diary/provider/theme_provider.dart';
import '../data/local/backup_service.dart';
import '../data/local/database.dart';

class SettingsScreen extends StatelessWidget {
  final AppDatabase db;

  SettingsScreen({required this.db});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> requestICloudPermission(BuildContext context) async {
    bool isAvailable = await isICloudAvailable();
    if (!isAvailable) {
      showICloudWarningDialog(context);
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAskedBefore = prefs.getBool('icloud_permission_requested') ?? false;

    if (!hasAskedBefore) {
      prefs.setBool('icloud_permission_requested', true);
      await createTestFileInICloud();
    }
  }

  Future<void> createTestFileInICloud() async {
    final iCloudPath = await getICloudDirectory();
    if (iCloudPath == null) return;

    final File testFile = File('$iCloudPath/icloud_test.txt');
    await testFile.writeAsString('iCloud Test File');
  }

  void openICloudSettings(BuildContext context) async {
    final Uri url = Uri.parse("App-Prefs:root=APPLE_ACCOUNT");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showMessage(context, "iCloud 설정을 열 수 없습니다.");
    }
  }

  void showICloudWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("iCloud 비활성화됨"),
        content: Text("iCloud가 비활성화되었습니다. 데이터를 백업하려면 iCloud를 활성화하세요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("닫기"),
          ),
          TextButton(
            onPressed: () {
              openICloudSettings(context);
              Navigator.of(context).pop();
            },
            child: Text("iCloud 설정 열기"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: getMainColor(context),
      appBar: AppBar(
        backgroundColor: getMainColor(context),
        title: Text(
          "설정",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'HakgyoansimDunggeunmiso',
            color: getTextColor(context),
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "다크 모드",
              style: TextStyle(color: getTextColor(context)),
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeColor: Colors.black,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.black,
              inactiveTrackColor: getMainColor(context),
            ),
          ),
          Divider(color: getIconColor(context)),
          ListTile(
            leading: Icon(Icons.cloud_upload, color: getTextColor(context)),
            title: Text(
              "iCloud에 데이터 백업",
              style: TextStyle(color: getTextColor(context)),
            ),
            onTap: () async {
              if (!await isICloudAvailable()) {
                showICloudWarningDialog(context);
                return;
              }
              showMessage(context, await backupDatabaseToICloud());
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_download, color: getTextColor(context)),
            title: Text(
              "iCloud에서 데이터 복원",
              style: TextStyle(color: getTextColor(context)),
            ),
            onTap: () async {
              if (!await isICloudAvailable()) {
                showICloudWarningDialog(context);
                return;
              }
              showMessage(context, await restoreDatabaseFromICloud());
            },
          ),
        ],
      ),
    );
  }
}
