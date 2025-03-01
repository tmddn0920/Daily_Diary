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
      onPageChanged: (focusedDay) {
        if (onPageChanged != null) {
          onPageChanged!(focusedDay);
        }
      },
    );
  }

  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      markerBuilder: (context, day, events) {
        final DateTime normalizedDay =
            DateTime.utc(day.year, day.month, day.day);
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
            style: _baseTextStyle.copyWith(
              color: (day.weekday == DateTime.saturday)
                  ? Colors.blueAccent
                  : (day.weekday == DateTime.sunday)
                      ? Colors.redAccent
                      : Colors.black,
            ),
          ),
        );
      },
    );
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

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        return DateFormat.MMMM(locale).format(date);
      },
      titleTextStyle: _baseTextStyle.copyWith(
        fontSize: 20.0,
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w900,
      ),
    );
  }

  CalendarStyle _buildCalendarStyle() {
    final today = DateTime.now();
    final bool isSaturday = today.weekday == DateTime.saturday;
    final bool isSunday = today.weekday == DateTime.sunday;

    return CalendarStyle(
      outsideDaysVisible: false,
      defaultTextStyle: _baseTextStyle,
      defaultDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      todayDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      todayTextStyle: _baseTextStyle.copyWith(
        color: isSaturday
            ? Colors.blueAccent
            : isSunday
                ? Colors.redAccent
                : Colors.black,
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: _baseTextStyle.copyWith(
        fontFamily: 'BMHanNaAir',
        fontWeight: FontWeight.bold,
      ),
      weekendStyle: _baseTextStyle.copyWith(
        fontFamily: 'BMHanNaAir',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
