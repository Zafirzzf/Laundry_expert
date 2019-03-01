import 'package:flutter/material.dart';
import 'package:laundry_expert/HomeScreen.dart';
import 'package:laundry_expert/LoginScreen.dart';
import 'package:laundry_expert/Tool/Preferences.dart';
import 'package:laundry_expert/Model/GlobalInfo.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


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
    initializeDateFormatting("zh", null);
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
    final token = await Preferences.getToken();
    if (token != null) {
      GlobalInfo.shared.token = token;
    }
    final isLogin = GlobalInfo.isLogin();
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

