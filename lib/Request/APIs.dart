
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:flutter/material.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'dart:convert';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Model/CustomerDetail.dart';

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

  // 获取订单识别号
  static orderIdentiferNumber(StringCallback numberCallback) {
    final path = 'gainIdentifynumber.action';
    RequestManager.post(urlPath: path, parame: {}, dataCallback: (dataMap) {
      final number = dataMap['identifynumber'] as String;
      numberCallback(number);
    });
  }

  // 添加订单信息
  static addNewOrder(
      {String number, String totalMoney, String customerId, List<ClothesInfo> clothesInfo,
        StringCallback orderIdCallback,
        StringCallback errorCallback}
      ) {
    final path = 'addOrderForm.action';
    final clothesListMap = clothesInfo.map((clothes) {
      return {"color": clothes.color, "type": clothes.type, "price": clothes.price.toString()};
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

  // 订单详情
  static orderDetailInfo(
      {String orderid, void Function(OrderInfo order) infoCallback}
      ) {
    final path = 'orderFormDetail.action';
    RequestManager.post(urlPath: path, parame: {"orderid": orderid}, dataCallback: (dataMap) {
        final clothesMaplist = dataMap['clotheslist'];
        List<ClothesInfo> clothesList = [];
        for (var tmpMap in clothesMaplist) {
          final clothes = ClothesInfo(
          customer: Customer(name: dataMap['name'], phoneNum: dataMap['phone']),
          color: tmpMap['color'],
          price: tmpMap['money'],
          type: tmpMap['type']
          );
          clothesList.add(clothes);
        }
        OrderState state;
        switch (dataMap['orderstatus'] as String) {
          case '0':  state = OrderState.noWash; break;
          case '1':  state = OrderState.washed; break;
          case '2':  state = OrderState.leave; break;
        }
        bool hasPay;
        switch (dataMap['paystatus'] as String) {
          case '0': hasPay = true; break;
          case '1': hasPay = false; break;
        }
        final info = OrderInfo(name: dataMap['name'], phone: dataMap['phone'], state: state, hasPay: hasPay,
                  createTime: dataMap['createtime'], clothesList: clothesList);
        infoCallback(info);

    }, errorCallback: (ret) {

    });
  }

  // 顾客的详情
  static customerDetailInfo({String customerId, void Function(CustomerDetail) infoCallback}) {
    final path = 'customerDetail.action';
    RequestManager.post(
      urlPath: path,
      parame: {'customerid': customerId},
      dataCallback: (dataMap) {
        final mapLists = dataMap['orderlist'];
        List<OrderListItem> orders = [];
        for (var tmpMap in mapLists) {
          final statusStr = tmpMap['orderstatus'] as String;
          OrderState orderState;
          switch (statusStr) {
            case '0': orderState = OrderState.noWash; break;
            case '1': orderState = OrderState.washed; break;
            case '2': orderState = OrderState.leave; break;
          }

          final orderItem = OrderListItem(
              orderstatus: orderState,
              hasPay: tmpMap['haspay'],
              time: tmpMap['time'] as String,
              identifynumber: tmpMap['identifynumber'] as String,
              id: tmpMap['id']);
          orders.add(orderItem);
        }
        final detailInifo = CustomerDetail(
            name: dataMap['name'],
            telephone: dataMap['telephone'],
            id: dataMap['id'],
            isvip: dataMap['isvip'],
            remainmoney: dataMap['remainmoney'],
            orderLists: orders);
        infoCallback(detailInifo);
      },
      errorCallback: (ret) {

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
