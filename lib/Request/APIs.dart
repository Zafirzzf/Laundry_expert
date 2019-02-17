
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:flutter/material.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'dart:convert';
import 'package:laundry_expert/Model/ClothesInfo.dart';

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
      errorCallback: errorCallback
    );
  }

  // 添加订单信息
  static addNewOrder(
      {String number, String totalMoney, String customerId, List<ClothesInfo> clothesInfo,
        StringCallback orderIdCallback,
        StringCallback errorCallback}
      ) {
    final path = 'addOrderForm.action';
    final clothesListMap = clothesInfo.map((clothes) {
      return {"color": clothes.color, "type": clothes.typeString(), "price": clothes.price.toString()};
    }).toList();
    final listMapStr = jsonEncode(clothesListMap);
    RequestManager.post(
      urlPath: path,
      parame: {'identifynumber': number, 'totalmoney': totalMoney, 'customerid' : customerId, "clothesMapList": listMapStr},
      dataCallback: (dataMap) {
        final orderId = dataMap['orderid'] as String;
        orderIdCallback(orderId);
      },
      errorCallback: errorCallback
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
