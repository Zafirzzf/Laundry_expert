
import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Tool/Preferences.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/GlobalInfo.dart';

class LoginScreen extends StatefulWidget {
  @override
  VoidCallback loginSuccess;
  LoginScreen(VoidCallback loginSuccess) {
    this.loginSuccess = loginSuccess;
  }
  _LoginScreenState createState() => _LoginScreenState(loginSuccess);
}

class _LoginScreenState extends State<LoginScreen> {

  final _usernameInput = TextEditingController();
  final _pwdInput = TextEditingController();
  bool _vaildInput = false;
  VoidCallback loginSuccess;
  _LoginScreenState(VoidCallback loginSuccess) {
    this.loginSuccess = loginSuccess;
  }
  _clickLogin() {
//      LoadingDialog.shared.show(context);
      APIs.login(
        phone: _usernameInput.text,
        pwd: _pwdInput.text,
        tokenCallback: (token) {
          Preferences.setToken(token);
          GlobalInfo.shared.token = token;
          TextDialog(text: '登录成功', dismissed: () {
            loginSuccess();
          }).show(context);
        },
        errorCallback: (errorRet) {
          BottomSheetDialog(text: errorRet.alertMsg(), context: context).show();
        }
      );
  }
  @override
  void initState() {
    super.initState();
    _usernameInput.addListener(() {
      setState(() {
        _vaildInput = _usernameInput.text.length > 0 && _pwdInput.text.length > 0;
      });
    });
    _pwdInput.addListener(() {
      setState(() {
        _vaildInput = _usernameInput.text.length > 0 && _pwdInput.text.length > 0;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                Text('洗衣专家系统', style: Styles.mediumFont(30, Colors.blue)),
                const SizedBox(height: 50),
                TextField(
                  controller: _usernameInput,
                  decoration: InputDecoration(
                    labelText: '专家账户名'
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _pwdInput,
                  decoration: InputDecoration(
                      labelText: '专家账户密码'
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  height: 45,
                  child: CommonBigButton(title: '登录', onPressed: _clickLogin, enabled: _vaildInput)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
