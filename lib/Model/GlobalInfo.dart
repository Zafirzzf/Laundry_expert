import 'package:flutter/material.dart';

class GlobalInfo {
  static GlobalInfo shared = GlobalInfo();
  String name;
  String token = '';
  static bool isLogin() {
    if (GlobalInfo.shared == null) {
      return false;
    } else {
      return GlobalInfo.shared.token.length > 0;
    }
  }

  // 登录过期的函数
  static VoidCallback loginInvalidCallback;
}