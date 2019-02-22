
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
typedef IntCallback = void Function(int index);

abstract class Styles {
  static TextStyle normalFont(double size, Color color) {
    return TextStyle(
      decoration: TextDecoration.none,
      fontSize: size,
      fontStyle: FontStyle.normal,
      fontFamily: 'NotoSans',
      fontWeight: FontWeight.normal,
      color: color
    );
  }

  static TextStyle mediumFont(double size, Color color) {
    return TextStyle(
        decoration: TextDecoration.none,
        fontSize: size,
        fontStyle: FontStyle.normal,
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.w500,
        color: color
    );
  }

  static TextStyle boldFont(double size, Color color) {
    return TextStyle(
        decoration: TextDecoration.none,
        fontSize: size,
        fontStyle: FontStyle.normal,
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.bold,
        color: color
    );
  }
}