import 'package:daily_diary/const/color.dart';
import 'package:daily_diary/screen/settings_screen.dart';
import 'package:daily_diary/screen/write_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../component/calendar.dart';
import 'package:daily_diary/data/local/database.dart';
import '../util/emoticon_utils.dart';

/// 다이어리 앱의 메인 스크린
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime selectedDate = DateTime.now(); // 현재 날짜
  DateTime currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  Map<DateTime, int> emotions = {};
  Map<int, int> emotionStats = {};
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  /// 광고를 로딩하는 함수
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5620036160638188/4102747173',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Failed to load ad: $error');
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadEmotionsForMonth(currentMonth);
  }

  /// 해당 달의 감정 데이터를 데이터베이스로부터 로딩하는 함수
  Future<void> _loadEmotionsForMonth(DateTime date) async {
    final db = Provider.of<AppDatabase>(context, listen: false);

    final diaryEntries = await db.diaryDao.getDiariesForMonth(
      DateTime(date.year, date.month, 1),
      DateTime(date.year, date.month + 1, 0),
    );

    setState(() {
      emotions = {
        for (var entry in diaryEntries)
          DateTime.utc(entry.date.year, entry.date.month, entry.date.day):
              entry.emotion
      };

      /// 감정 통계 초기화
      emotionStats = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
      for (var entry in diaryEntries) {
        emotionStats[entry.emotion] = (emotionStats[entry.emotion] ?? 0) + 1;
      }
    });
  }

  /// 날짜가 선택되면, WriteScreen으로 이동
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteScreen(
          selectedDate: selectedDate,
          onSaveComplete: () {
            _loadEmotionsForMonth(currentMonth);
            setState(() {});
          },
          onDeleteComplete: () {
            _loadEmotionsForMonth(currentMonth);
            setState(() {});
          },
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadEmotionsForMonth(currentMonth);
      }
    });
  }

  /// Calendar 및 광고 배너 Build 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getMainColor(context),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildCalendar(),
                _buildEmotionStatus(context),
                if (_isAdLoaded)
                  Container(
                    height: _bannerAd!.size.height.toDouble(),
                    width: _bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  double velocity = details.primaryVelocity ?? 0;
                  if (velocity.abs() < 50) return;
                  final int nextMonth = velocity < 0 ? 1 : -1;
                  final DateTime newMonth = DateTime(
                      currentMonth.year, currentMonth.month + nextMonth, 1);
                  if (newMonth == currentMonth) return;
                  _changeMonth(nextMonth);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 달력 밖에서 스와이프 시, 달을 변경하는 함수
  void _changeMonth(int offset) {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month + offset, 1);
      selectedDate = currentMonth;
    });
    _loadEmotionsForMonth(currentMonth);
  }

  /// AppBar을 빌드하는 함수
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    bool isCurrentMonth = currentMonth.year == DateTime.now().year &&
        currentMonth.month == DateTime.now().month;

    return AppBar(
      backgroundColor: getMainColor(context),
      foregroundColor: getIconColor(context),
      actions: [
        if (!isCurrentMonth)
          IconButton(
            onPressed: () {
              setState(() {
                currentMonth =
                    DateTime(DateTime.now().year, DateTime.now().month, 1);
                selectedDate = DateTime.now();
              });
              _loadEmotionsForMonth(currentMonth);
            },
            icon: Icon(Icons.refresh, color: getIconColor(context)),
            tooltip: "오늘 날짜로 이동",
          ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
          icon: Icon(Icons.settings, color: getIconColor(context)),
        ),
      ],
    );
  }

  /// 캘린더 위젯을 빌드하는 함수
  Widget _buildCalendar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Calendar(
          selectedDate: selectedDate,
          onDaySelected: onDaySelected,
          emotions: emotions,
          onPageChanged: (focusedDay) {
            final newMonth = DateTime(focusedDay.year, focusedDay.month, 1);
            if (newMonth != currentMonth) {
              setState(
                () {
                  currentMonth = newMonth;
                  selectedDate = focusedDay;
                },
              );
              _loadEmotionsForMonth(newMonth);
            }
          },
        ),
      ),
    );
  }

  /// 날짜별 감정 이모티콘을 캘린더 위에 빌드하는 함수
  Widget _buildEmotionStatus(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: getMainColor(context),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: getIconColor(context), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) {
              return _buildEmotionItem(
                  'asset/img/emotion/${getEmotionFileName(index)}.png',
                  '${emotionStats[index] ?? 0}',
                  screenWidth,
                  context);
            },
          ),
        ),
      ),
    );
  }

  /// 감정 이모티콘을 디스플레이 하는 함수
  Widget _buildEmotionItem(String imagePath, String label, double screenWidth,
      BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: screenWidth * 0.12,
          height: screenWidth * 0.12,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: getTextColor(context),
          ),
        ),
      ],
    );
  }
}
