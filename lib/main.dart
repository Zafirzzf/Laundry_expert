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
    // 如果登录过期,回首页
    GlobalInfo.loginInvalidCallback = () {
      print('登录过期');
      BottomSheetDialog(text: '登录过期,请重新登录', context: context).show();
      Preferences.setToken(null);
      GlobalInfo.shared.token = null;
      setRootWidget();
    };
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
//      localizationsDelegates: [
//        // ... app-specific localization delegate[s] here
//        GlobalMaterialLocalizations.delegate,
//        GlobalWidgetsLocalizations.delegate,
//      ],
//      supportedLocales: [
//        const Locale('en', 'US'), // English
//        const Locale('he', 'IL'), // Hebrew
//        // ... other locales the app supports
//      ],
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

