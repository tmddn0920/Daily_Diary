import 'package:daily_diary/const/color.dart';
import 'package:flutter/material.dart';
import '../component/calendar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Calendar(
                focusedDay: DateTime.now(),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              right: screenWidth * 0.05,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
