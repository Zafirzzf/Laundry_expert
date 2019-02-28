
import 'dart:ui';
import 'package:flutter/material.dart';

class ScreenInfo {
  static final double scale = window.devicePixelRatio;

  // 屏幕宽
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // 屏幕高
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 状态栏高度, 20 / 44
  static double topPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double bottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
}