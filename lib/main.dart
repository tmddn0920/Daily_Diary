import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:daily_diary/data/local/database.dart';
import 'package:daily_diary/screen/main_screen.dart';
import 'package:daily_diary/provider/theme_provider.dart';

void main() {
  /// 엔진 및 위젯 트리 초기화
  WidgetsFlutterBinding.ensureInitialized();
  /// Google Ads 초기화
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        /// 데이터베이스 제공
        Provider(create: (_) => AppDatabase()),
        /// 테마 설정을 위한 Provider 등록
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'HakgyoansimDunggeunmiso',
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        fontFamily: 'HakgyoansimDunggeunmiso',
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', 'KR'),
      ],
      home: MainScreen(),
    );
  }
}
