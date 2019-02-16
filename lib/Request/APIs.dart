
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:flutter/material.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'dart:convert';

class APIs {

  // 登录
  static login({String phone, String pwd,
    StringCallback tokenCallback, StringCallback errorCallback}) {

    final path = 'login.action';
    RequestManager.post(
      urlPath: path,
      parame: { "telephone": phone, "password": pwd },
      dataCallback: (dataMap) {
        final token = dataMap['token'] as String;
        tokenCallback(token);
      },
      errorCallback: (ret) {
        errorCallback(ret);
      }
    );
  }

  // 添加顾客信息
  static addCustomer({String name, String phone, StringCallback idCallback, StringCallback errorCallback}) {
    final path = 'addCustomer.action';
    RequestManager.post(
      urlPath: path,
      parame: { "name": name, "telephone": phone },
      dataCallback: (dataMap) {
        final customerId = dataMap['id'] as String;
        idCallback(customerId);
      },
      errorCallback: (ret) {
        errorCallback(ret);
      }
    );
  }

  // 所有顾客列表
  static customersList(void Function(List<Customer>) listCallback) {
    final path = 'customerList.action';
    RequestManager.post(
      urlPath: path,
      parame: {},
      dataCallback: (dataMap) {
        final mapLists = dataMap['list'] ;
        List<Customer> results = [];
        for (var tmpMap in mapLists) {
          final customer = Customer(
              name: tmpMap['name'] as String,
              phoneNum: tmpMap['telephone'] as String,
              id: tmpMap['id'] as String
          );
          results.add(customer);
        }
        listCallback(results);
      },
      errorCallback: (ret) {

     }
   );
  }
}
