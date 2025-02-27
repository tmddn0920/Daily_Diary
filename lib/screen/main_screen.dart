import 'package:flutter/material.dart';
import '../component/calendar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Calendar(
            focusedDay: DateTime.now(),
          ),
        ],
      ),
    );
  }
}
