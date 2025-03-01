import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:daily_diary/const/color.dart';
import 'package:daily_diary/data/local/database.dart';
import 'package:provider/provider.dart';

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
  int selectedEmotion = 0;

  @override
  void initState() {
    super.initState();
    _loadExistingDiary();
  }

  Future<void> _loadExistingDiary() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final dao = db.diaryDao;

    final existingDiary = await dao.getDiaryByDate(widget.selectedDate);
    if (existingDiary != null) {
      setState(() {
        _controller.text = existingDiary.content;
        selectedEmotion = existingDiary.emotion;
        _textAlign = TextAlign.values[existingDiary.textAlign];
        _isBold = existingDiary.isBold;
      });
    }
  }

  Future<void> _saveDiary() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final dao = db.diaryDao;

    final existingDiary = await dao.getDiaryByDate(widget.selectedDate);

    if (existingDiary == null) {
      await dao.insertDiary(DiariesCompanion(
        date: drift.Value(widget.selectedDate),
        emotion: drift.Value(selectedEmotion),
        content: drift.Value(_controller.text),
        textAlign: drift.Value(_textAlign.index),
        isBold: drift.Value(_isBold),
      ));
    } else {
      await dao.updateDiary(existingDiary.copyWith(
        content: _controller.text,
        emotion: selectedEmotion,
        textAlign: _textAlign.index,
        isBold: _isBold,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final GlobalKey _iconKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: iconColor),
            onPressed: _saveDiary,
          ),
        ],
      ),
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: GestureDetector(
                  key: _iconKey,
                  onTap: () => _showEmotionPicker(context, _iconKey),
                  child: Image.asset(
                    'asset/img/emotion/${_getEmotionFileName(selectedEmotion)}.png',
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                  ),
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
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTextAlignButton(Icons.format_align_left, TextAlign.left),
                _buildTextAlignButton(Icons.format_align_center, TextAlign.center),
                _buildTextAlignButton(Icons.format_align_right, TextAlign.right),
                IconButton(
                  icon: Icon(Icons.format_bold),
                  onPressed: () => setState(() => _isBold = !_isBold),
                  color: _isBold ? Colors.black : iconColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEmotionPicker(BuildContext context, GlobalKey iconKey) {
    final RenderBox renderBox = iconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double iconCenterX = position.dx + (renderBox.size.width / 2);
    final double boxWidth = 320;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + 10,
              left: iconCenterX - (boxWidth / 2),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: iconColor, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmotion = index;
                          });
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'asset/img/emotion/${_getEmotionFileName(index)}.png',
                          width: 50,
                          height: 50,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  Widget _buildTextAlignButton(IconData icon, TextAlign align) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => setState(() => _textAlign = align),
      color: _textAlign == align ? Colors.black : iconColor,
    );
  }
}
