
import 'dart:ui';
import 'package:flutter/material.dart';

class ScreenInfo {
  static final double scale = window.devicePixelRatio;
  static final double width = window.physicalSize.width / scale;
  static final double height = window.physicalSize.height / scale;

  // 状态栏高度, 20 / 44
  static double topPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double bottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
}