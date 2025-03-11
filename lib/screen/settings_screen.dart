import 'package:daily_diary/const/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_diary/provider/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
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
            fontFamily: 'HakgyoansimDunggeunmiso'
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("다크 모드"),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Colors.black,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.black,
              inactiveTrackColor: getMainColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
