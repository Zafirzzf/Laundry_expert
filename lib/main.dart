import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundry_expert/HomeScreen.dart';
import 'package:laundry_expert/LoginScreen.dart';
import 'package:flutter/services.dart';
import 'package:laundry_expert/Tool/Preferences.dart';
import 'package:laundry_expert/Model/ShopInfo.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget rootWidget = Container();

  @override
  void initState() {
    super.initState();
    setRootWidget();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: rootWidget,
    );
  }

  setRootWidget() async {
    final isLogin = await Preferences.isLogin();
    final token = await Preferences.getToken();
    ShopInfo.shared.token = token;
    if (isLogin) {
      rootWidget = HomeScreen();
    } else {
      rootWidget = LoginScreen(() {
        // 登录成功回调
        rootWidget = HomeScreen();
        setState(() {});
      });
    }
    setState(() {});
  }
}

