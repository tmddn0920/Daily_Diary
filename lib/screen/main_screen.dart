import 'package:daily_diary/const/color.dart';
import 'package:daily_diary/screen/write_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/calendar.dart';
import 'package:daily_diary/data/local/database.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  Map<DateTime, int> emotions = {};
  Map<int, int> emotionStats = {};

  @override
  void initState() {
    super.initState();
    _loadEmotionsForMonth(currentMonth);
  }

  // ✅ 특정 월의 감정 데이터를 불러오는 함수
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

      // ✅ 감정 통계 초기화 후 재계산
      emotionStats = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
      for (var entry in diaryEntries) {
        emotionStats[entry.emotion] = (emotionStats[entry.emotion] ?? 0) + 1;
      }
    });
  }

  // ✅ 날짜 선택 시 일기 화면으로 이동 & 저장 후 데이터 갱신
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteScreen(selectedDate: selectedDate),
      ),
    ).then((result) {
      if (result == true) {
        _loadEmotionsForMonth(currentMonth); // ✅ 저장 후 현재 월 데이터 갱신
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(),
            _buildEmotionStatus(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      foregroundColor: iconColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings, color: iconColor),
        ),
      ],
    );
  }

  // ✅ 캘린더 (월이 바뀔 때마다 데이터 갱신 추가)
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

  // ✅ 감정 통계 박스 (이전 달, 다음 달 이동 시 자동 변경)
  Widget _buildEmotionStatus() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: iconColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) {
              return _buildEmotionItem(
                  'asset/img/emotion/${_getEmotionFileName(index)}.png',
                  '${emotionStats[index] ?? 0}',
                  screenWidth);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionItem(String imagePath, String label, double screenWidth) {
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
            fontFamily: 'Fredoka',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _getEmotionFileName(int index) {
    switch (index) {
      case 0:
        return "happy";
      case 1:
        return "normal";
      case 2:
        return "worry";
      case 3:
        return "sad";
      case 4:
        return "mad";
      default:
        return "happy";
    }
  }
}
