
import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _usernameInput = TextEditingController();
  final _pwdInput = TextEditingController();

  _clickLogin() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                width: ScreenInfo.width - 60,
                height: 45,
                child: CommonBigButton(title: '登录', onPressed: _clickLogin)
              )
            ],
          ),
        ),
      ),
    );
  }
}
