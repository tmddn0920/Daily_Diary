import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final Map<DateTime, int> emotions;
  final Function(DateTime)? onPageChanged;

  const Calendar({
    required this.onDaySelected,
    required this.selectedDate,
    required this.emotions,
    this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final saturdayColor = Colors.blueAccent;
    final sundayColor = Colors.redAccent;

    return TableCalendar(
      focusedDay: selectedDate,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      locale: 'ko_KR',
      daysOfWeekHeight: 30.0,
      headerStyle: _buildHeaderStyle(isDarkMode),
      calendarStyle: _buildCalendarStyle(isDarkMode, textColor),
      calendarBuilders: _buildCalendarBuilders(isDarkMode, saturdayColor, sundayColor),
      daysOfWeekStyle: _buildDaysOfWeekStyle(isDarkMode),
      onDaySelected: onDaySelected,
      onPageChanged: (focusedDay) {
        if (onPageChanged != null) {
          onPageChanged!(focusedDay);
        }
      },
    );
  }

  HeaderStyle _buildHeaderStyle(bool isDarkMode) {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        return DateFormat.yMMMM(locale).format(date); // 2024년 3월 형식
      },
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w900,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      leftChevronIcon: Icon(Icons.chevron_left, color: isDarkMode ? Colors.white : Colors.black),
      rightChevronIcon: Icon(Icons.chevron_right, color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  CalendarStyle _buildCalendarStyle(bool isDarkMode, Color textColor) {
    return CalendarStyle(
      outsideDaysVisible: false,
      defaultTextStyle: TextStyle(fontSize: 16.0, fontFamily: 'Fredoka', color: textColor),
      defaultDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      todayDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      todayTextStyle: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Fredoka',
        color: _getTodayTextColor(isDarkMode),
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle(bool isDarkMode) {
    return DaysOfWeekStyle(
      weekdayStyle: TextStyle(
        fontFamily: 'BMHanNaAir',
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      weekendStyle: TextStyle(
        fontFamily: 'BMHanNaAir',
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  CalendarBuilders _buildCalendarBuilders(bool isDarkMode, Color saturdayColor, Color sundayColor) {
    return CalendarBuilders(
      markerBuilder: (context, day, events) {
        final DateTime normalizedDay = DateTime.utc(day.year, day.month, day.day);
        if (emotions.containsKey(normalizedDay)) {
          return Center(
            child: Image.asset(
              'asset/img/emotion/${_getEmotionFileName(emotions[normalizedDay]!)}.png',
              width: 40,
              height: 40,
            ),
          );
        }
        return null;
      },
      defaultBuilder: (context, day, focusedDay) {
        return Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Fredoka',
              color: _getDayTextColor(day, isDarkMode, saturdayColor, sundayColor),
            ),
          ),
        );
      },
    );
  }

  Color _getTodayTextColor(bool isDarkMode) {
    final today = DateTime.now();
    if (today.weekday == DateTime.saturday) return Colors.blueAccent;
    if (today.weekday == DateTime.sunday) return Colors.redAccent;
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color _getDayTextColor(DateTime day, bool isDarkMode, Color saturdayColor, Color sundayColor) {
    if (day.weekday == DateTime.saturday) return saturdayColor;
    if (day.weekday == DateTime.sunday) return sundayColor;
    return isDarkMode ? Colors.white : Colors.black;
  }

  String _getEmotionFileName(int emotion) {
    switch (emotion) {
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
