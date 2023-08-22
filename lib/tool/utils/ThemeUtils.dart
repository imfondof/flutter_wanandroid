import 'package:flutter/material.dart';

class ThemeUtils {
  /// 默认主题色
  static const Color defaultColor = Colors.redAccent;

  /// 当前的主题色
  static Color currentThemeColor = defaultColor;

  /// 是否是夜间模式
  static bool dark = false;

  ///改变主题模式
  static ThemeData getThemeData() {
    if (dark) {
      return ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF35464E),
        primaryColorDark: const Color(0xFF212A2F),
        hintColor: const Color(0xFF35464E),
        dividerColor: const Color(0x1FFFFFFF),
      );
    } else {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: currentThemeColor,
        primaryColorDark: currentThemeColor,
        hintColor: currentThemeColor,
        dividerColor: const Color(0x1F000000),
      );
    }
  }
}
