import 'package:flutter/material.dart';
import '../const/color.dart';

class WriteScreen extends StatefulWidget {
  final DateTime selectedDate;
  const WriteScreen({required this.selectedDate, super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _controller = TextEditingController();
  TextAlign _textAlign = TextAlign.left;
  bool _isBold = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: mainColor,
      ),
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Image.asset(
                  'asset/img/emotion/happy.png',
                  width: screenWidth * 0.16,
                  height: screenWidth * 0.16,
                ),
              ),
            ),
            Center(
              child: Text(
                "${widget.selectedDate.month}월 ${widget.selectedDate.day}일",
                style: TextStyle(
                  fontFamily: 'BMHanNaAir',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _controller,
                  textAlign: _textAlign,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'BMHanNaAir',
                    fontSize: 16.0,
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: "오늘 어떤 하루를 보내셨나요?",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.format_align_left),
                  onPressed: () => setState(() => _textAlign = TextAlign.left),
                  color:
                      _textAlign == TextAlign.left ? Colors.black : iconColor,
                ),
                IconButton(
                  icon: Icon(Icons.format_align_center),
                  onPressed: () =>
                      setState(() => _textAlign = TextAlign.center),
                  color:
                      _textAlign == TextAlign.center ? Colors.black : iconColor,
                ),
                IconButton(
                  icon: Icon(Icons.format_align_right),
                  onPressed: () => setState(() => _textAlign = TextAlign.right),
                  color:
                      _textAlign == TextAlign.right ? Colors.black : iconColor,
                ),
                IconButton(
                  icon: Icon(Icons.format_bold),
                  onPressed: () => setState(() => _isBold = !_isBold),
                  color: _isBold ? Colors.black : iconColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
