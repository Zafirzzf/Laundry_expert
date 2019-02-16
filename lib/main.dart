import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundry_expert/HomeScreen.dart';
import 'package:laundry_expert/LoginScreen.dart';
import 'package:flutter/services.dart';
import 'package:laundry_expert/Tool/Preferences.dart';

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
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
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
    if (isLogin) {
      rootWidget = HomeScreen();
    } else {
      rootWidget = LoginScreen();
    }
    setState(() {});
  }
}

