
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static Future<SharedPreferences> shared() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String> getToken() async {
    final prf =  await shared();
    return prf.getString('token') ?? '';
  }

  static setToken(String token) async {
    _saveNewValue('token', token);
  }

  static _saveNewValue(String key, dynamic value) async {
    final prf = await shared();
    final type = value.runtimeType;
    if (type == bool) {
      prf.setBool(key, value);
    } else if (type == String) {
      prf.setString(key, value);
    }
  }
}