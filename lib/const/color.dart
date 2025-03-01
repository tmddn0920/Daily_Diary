import 'package:flutter/material.dart';

const mainColorLight = Color(0xFFFFFFF0); // 밝은 배경
const iconColorLight = Color(0xFFC0C0C0); // 기본 아이콘 색상
const textColorLight = Colors.black; // 기본 텍스트 색상

const mainColorDark = Color(0xFF2C3539); // 어두운 배경
const iconColorDark = Color(0xFF888888); // 다크 모드 아이콘 색상
const textColorDark = Color(0xFFEAEAEA); // 다크 모드 텍스트 색상

Color getMainColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? mainColorDark
      : mainColorLight;
}

Color getIconColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? iconColorDark
      : iconColorLight;
}

Color getTextColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? textColorDark
      : textColorLight;
}
