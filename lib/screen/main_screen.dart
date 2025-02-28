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
            _buildEmotionStatus(),
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
            color: iconColor,
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

  Widget _buildEmotionStatus() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: screenHeight * 0.15,
      left: 16.0,
      right: 16.0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: iconColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEmotionItem('asset/img/emotion/happy.png', '0', screenWidth),
            _buildEmotionItem('asset/img/emotion/normal.png', '0', screenWidth),
            _buildEmotionItem('asset/img/emotion/worry.png', '0', screenWidth),
            _buildEmotionItem('asset/img/emotion/sad.png', '0', screenWidth),
            _buildEmotionItem('asset/img/emotion/mad.png', '0', screenWidth),
          ],
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
        SizedBox(height: 12),
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
}
