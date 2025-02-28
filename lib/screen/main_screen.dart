import 'package:daily_diary/const/color.dart';
import 'package:flutter/material.dart';
import '../component/calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            _buildCalendar(),
            _buildFloatingButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight * 0.05,
      left: 0,
      right: 0,
      child: Calendar(
        selectedDate: selectedDate,
        onDaySelected: onDaySelected,
      ),
    );
  }

  Widget _buildFloatingButton() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: screenHeight * 0.05,
      right: screenWidth * 0.05,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: iconColor,
        child: Icon(
          Icons.edit,
          size: 28.0,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        elevation: 0,
      ),
    );
  }
}
