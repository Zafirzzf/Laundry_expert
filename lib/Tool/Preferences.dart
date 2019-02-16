
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<SharedPreferences> shared() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> isLogin() async {
    final pre = await shared();
    final isLogin = pre.getBool('isLogin');
    if (isLogin == null) {
      return false;
    } else {
      return true;
    }
  }

}