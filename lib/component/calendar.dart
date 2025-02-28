import 'package:daily_diary/const/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  const Calendar({
    required this.onDaySelected,
    required this.selectedDate,
    super.key,
  });

  static const TextStyle _baseTextStyle = TextStyle(
    fontSize: 16.0,
    fontFamily: 'Fredoka',
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: selectedDate,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      locale: 'ko_KR',
      daysOfWeekHeight: 30.0,
      headerStyle: _buildHeaderStyle(),
      calendarStyle: _buildCalendarStyle(),
      calendarBuilders: _buildCalendarBuilders(),
      daysOfWeekStyle: _buildDaysOfWeekStyle(),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
    );
  }

  // 헤더 스타일
  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        return DateFormat.MMMM(locale).format(date);
      },
      titleTextStyle: _baseTextStyle.copyWith(
        fontSize: 20.0,
        fontFamily: 'BMHanNaAir',
        fontWeight: FontWeight.w900,
      ),
    );
  }

  // 캘린더 스타일
  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      outsideDaysVisible: false,
      defaultTextStyle: _baseTextStyle,
      defaultDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      todayDecoration: BoxDecoration(
        border: Border.all(color: iconColor, width: 2),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      todayTextStyle: _baseTextStyle.copyWith(
        color: DateTime.now().weekday == DateTime.saturday
            ? Colors.blueAccent
            : DateTime.now().weekday == DateTime.sunday
                ? Colors.redAccent
                : Colors.black,
      ),
      selectedDecoration: BoxDecoration(
        color: iconColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      selectedTextStyle: _baseTextStyle.copyWith(
        color: Colors.black,
      ),
    );
  }

  // 날짜별 스타일 빌더
  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      defaultBuilder: (context, day, focusedDay) {
        if (day.weekday == DateTime.saturday) {
          return _buildDayText(day.day, Colors.blueAccent);
        } else if (day.weekday == DateTime.sunday) {
          return _buildDayText(day.day, Colors.redAccent);
        }
        return null;
      },
    );
  }

  // 요일 스타일
  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: _baseTextStyle.copyWith(
          fontFamily: 'BMHanNaAir', fontWeight: FontWeight.bold),
      weekendStyle: _baseTextStyle.copyWith(
          fontFamily: 'BMHanNaAir', fontWeight: FontWeight.bold),
    );
  }

  // 요일 & 날짜 텍스트 위젯
  Widget _buildDayText(int day, Color color) {
    return Center(
      child: Text(
        day.toString(),
        style: _baseTextStyle.copyWith(color: color),
      ),
    );
  }
}
