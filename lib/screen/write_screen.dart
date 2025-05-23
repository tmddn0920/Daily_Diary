import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:daily_diary/const/color.dart';
import 'package:daily_diary/data/local/database.dart';
import 'package:provider/provider.dart';
import '../util/emoticon_utils.dart';

/// 일기를 작성하는 스크린
class WriteScreen extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback? onSaveComplete;
  final VoidCallback? onDeleteComplete;

  const WriteScreen({
    required this.selectedDate,
    this.onSaveComplete,
    this.onDeleteComplete,
    super.key,
  });

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _controller = TextEditingController();
  TextAlign _textAlign = TextAlign.left;
  bool _isBold = false;
  int selectedEmotion = 0;
  bool _isEditing = false;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _loadExistingDiary();
  }

  /// 만약 일기가 존재한다면, 로딩하는 함수
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
        _isEditing = true;
      });
    }
  }

  /// 일기를 저장하는 함수 (새로운 일기 생성 or 기존 일기 수정)
  Future<void> _saveDiary() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final dao = db.diaryDao;
    final existingDiary = await dao.getDiaryByDate(widget.selectedDate);
    if (_controller.text.isEmpty) {
      return;
    }

    if (existingDiary == null) {
      await dao.insertDiary(
        DiariesCompanion(
          date: drift.Value(widget.selectedDate),
          emotion: drift.Value(selectedEmotion),
          content: drift.Value(_controller.text),
          textAlign: drift.Value(_textAlign.index),
          isBold: drift.Value(_isBold),
        ),
      );
    } else {
      await dao.updateDiary(existingDiary.copyWith(
        content: _controller.text,
        emotion: selectedEmotion,
        textAlign: _textAlign.index,
        isBold: _isBold,
      ));
    }
    widget.onSaveComplete?.call();
  }

  /// 일기를 삭제하는 함수
  Future<void> _deleteDiary() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final dao = db.diaryDao;

    final existingDiary = await dao.getDiaryByDate(widget.selectedDate);
    if (existingDiary != null) {
      await dao.deleteDiary(existingDiary.id);
    }
    setState(() {
      _isDeleted = true;
    });
    widget.onDeleteComplete?.call();
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  /// 일기를 지우기 전에, 선택지를 출력하는 함수
  Future<void> _confirmDelete() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: getMainColor(context),
          title: Text(
            "일기를 삭제하시나요?",
            style: TextStyle(
              fontSize: 16.0,
              color: getTextColor(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(
                  color: getIconColor(context),
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteDiary();
              },
              child: Text(
                "삭제",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 스크린을 만드는 함수
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final GlobalKey _iconKey = GlobalKey();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (_isDeleted) return;
        await _saveDiary();
      },
      child: _buildScreen(screenWidth, _iconKey),
    );
  }

  /// 레이아웃을 빌드하는 함수
  Widget _buildScreen(double screenWidth, GlobalKey iconKey) {
    return GestureDetector(
      onHorizontalDragEnd: (details) async {
        if (details.primaryVelocity! > 0 && Navigator.canPop(context)) {
          await _saveDiary();
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: getMainColor(context),
          actions: [
            if (_isEditing)
              IconButton(
                icon: Icon(Icons.delete, color: getIconColor(context)),
                onPressed: _confirmDelete,
              ),
          ],
        ),
        backgroundColor: getMainColor(context),
        body: SafeArea(
          child: Column(
            children: [
              /// 상단 컨텐츠 (스크롤 가능)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// 감정 선택
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GestureDetector(
                          key: iconKey,
                          onTap: () => _showEmotionPicker(context, iconKey),
                          child: Image.asset(
                            'asset/img/emotion/${getEmotionFileName(selectedEmotion)}.png',
                            width: screenWidth * 0.16,
                            height: screenWidth * 0.16,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${widget.selectedDate.month}월 ${widget.selectedDate.day}일",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'HakgyoansimDunggeunmiso',
                            color: getTextColor(context),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _controller,
                          textAlign: _textAlign,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          scrollPadding: EdgeInsets.zero,
                          style: TextStyle(
                            color: getTextColor(context),
                            fontFamily: _isBold
                                ? 'HakgyoansimDunggeunmiso'
                                : 'HakgyoansimDunggeunmiso_Regular',
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            hintText: "오늘 어떤 하루를 보내셨나요?",
                            hintStyle: TextStyle(color: getIconColor(context)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: getMainColor(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬 유지
                  children: [
                    _buildTextAlignButton(
                        Icons.format_align_left, TextAlign.left),
                    _buildTextAlignButton(
                        Icons.format_align_center, TextAlign.center),
                    _buildTextAlignButton(
                        Icons.format_align_right, TextAlign.right),
                    IconButton(
                      icon: Icon(Icons.format_bold),
                      onPressed: () => setState(() => _isBold = !_isBold),
                      color: _isBold
                          ? getTextColor(context)
                          : getIconColor(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 글자 정렬 버튼을 만드는 함수
  Widget _buildTextAlignButton(IconData icon, TextAlign align) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => setState(() => _textAlign = align),
      color:
          _textAlign == align ? getTextColor(context) : getIconColor(context),
    );
  }

  /// 이모티콘 선택 창을 출력하는 함수
  void _showEmotionPicker(BuildContext context, GlobalKey iconKey) {
    final RenderBox renderBox =
        iconKey.currentContext!.findRenderObject() as RenderBox;
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
                    border: Border.all(color: getIconColor(context), width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedEmotion = index;
                            });
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'asset/img/emotion/${getEmotionFileName(index)}.png',
                            width: 50,
                            height: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
