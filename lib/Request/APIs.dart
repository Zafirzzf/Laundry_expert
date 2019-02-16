
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:flutter/material.dart';

class APIs {

  // 登录
  static login({String phone, String pwd,
    StringCallback tokenCallback, StringCallback errorCallback}) {

    final path = "login.action";
    RequestManager.post(
      urlPath: path,
      parame: {"telephone": phone, "password": pwd},
      dataCallback: (dataMap) {
        final token = dataMap['token'] as String;
        print(token);
        tokenCallback(token);
      },
      errorCallback: (ret) {
        print(ret);
        errorCallback(ret);
      }
    );
  }
}
