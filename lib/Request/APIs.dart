
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:flutter/material.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'dart:convert';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Model/CustomerDetail.dart';
import 'package:laundry_expert/Model/UserRecord.dart';
import 'package:laundry_expert/Model/OrderListItemOfUser.dart';
import 'package:laundry_expert/Model/OrderListItem.dart';

class APIs {
  // 登录
  static login({String phone, String pwd,
    StringCallback tokenCallback, ErrorCallback errorCallback}) {

    final path = 'login.action';
    RequestManager.post(
      urlPath: path,
      parame: { "telephone": phone, "password": pwd },
      dataCallback: (dataMap) {
        final token = dataMap['token'] as String;
        tokenCallback(token);
      },
      errorCallback: errorCallback
    );
  }

  // 添加顾客信息
  static addCustomer({String name, String phone, StringCallback idCallback, ErrorCallback errorCallback}) {
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
        ErrorCallback errorCallback}
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
        final info = OrderInfo(name: dataMap['name'], phone: dataMap['phone'], state: state, hasPay: dataMap['haspay'],
                  createTime: dataMap['createtime'], identifynumber: dataMap['identifynumber'],
                  resultMoney: dataMap['resultmoney'], isVip: dataMap['isvip'],
                  clothesList: clothesList);
        infoCallback(info);

    }, errorCallback: (ret) {

    });
  }

  // 顾客的详情
  static customerDetailInfo({String customerId, OrderState state, void Function(CustomerDetail) infoCallback}) {
    final path = 'customerDetail.action';
    String stateStr = state.index.toString();
    RequestManager.post(
      urlPath: path,
      parame: {'customerid': customerId, 'orderstatus': stateStr},
      dataCallback: (dataMap) {
        final mapLists = dataMap['orderlist'];
        List<OrderListItemOfUser> orders = [];
        for (var tmpMap in mapLists) {
          final statusStr = tmpMap['orderstatus'] as String;
          OrderState orderState;
          switch (statusStr) {
            case '0': orderState = OrderState.noWash; break;
            case '1': orderState = OrderState.washed; break;
            case '2': orderState = OrderState.leave; break;
          }

          final orderItem = OrderListItemOfUser(
              orderstatus: orderState,
              hasPay: tmpMap['haspay'],
              time: tmpMap['time'] as String,
              identifynumber: tmpMap['identifynumber'] as String,
              id: tmpMap['id'],
              money: tmpMap['totalmoney']);
          orders.add(orderItem);
        }
        final detailInifo = CustomerDetail(
            name: dataMap['name'],
            telephone: dataMap['telephone'],
            discount: dataMap['discount'],
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

  // 所有订单列表
  static allOrderList(OrderState state, String identifyNumber, int page, void Function(List<OrderListItem> list) listCallback) {
    final path = 'orderPage.action';
    var parame = Map<String, String>();
    parame['identifynumber'] = identifyNumber ?? '';
    parame['customerid'] = '';
    parame['paystatus'] = '';
    parame['orderstatus'] = state.index.toString();
    parame['pagenumber'] = page.toString();
    parame['length'] = '5';
    RequestManager.post(
      urlPath: path,
      parame: parame,
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
            id: tmpMap['id'],
            money: tmpMap['totalmoney'],
            customerName: tmpMap['customername']
          );
          orders.add(orderItem);
        }
        listCallback(orders);
      }
    );
  }

  // 改变订单状态
  static changeOrderState({String orderId, OrderState state, BoolCallback successCallback, ErrorCallback errorCallback}) {
    final path = 'changeOrderStatus.action';
    String stateStr;
    switch (state) {
      case OrderState.noWash: stateStr = '0'; break;
      case OrderState.washed: stateStr = '1'; break;
      case OrderState.leave: stateStr = '2'; break;
    }
    RequestManager.post(
      urlPath: path,
      parame: {'orderid': orderId, 'orderstatus': stateStr},
      dataCallback: (dataMap) {
        successCallback(true);
      },
      errorCallback: errorCallback
    );
  }

  // 改变订单支付状态
  static changeOrderPayStatus({String orderId, bool hasPay, VoidCallback successCallback, ErrorCallback errorCallback}) {
    final path = 'changeOrderPayStatus.action';
    RequestManager.post(
      urlPath: path,
      parame: {'orderid': orderId, 'paystatus': hasPay ? 'true' : 'false'},
      dataCallback: (dataMap) {
        successCallback();
      },
      errorCallback: errorCallback
    );
  }

  // 顾客消费记录
  static customerRecordList({String customerId, void Function(List<UserRecord> list) listcallBack}) {
    final path = 'fundRecordList.action';
    RequestManager.post(
      urlPath: path,
      parame: {'customerid': customerId},
      dataCallback: (dataMap) {
        final mapLists = dataMap['fundrecordlist'] ;
        List<UserRecord> results = [];
        for (var tmpMap in mapLists) {
          final record = UserRecord(tmpMap['time'], tmpMap['status'], tmpMap['orderid'], tmpMap['changemoney']);
          results.add(record);
        }
        listcallBack(results);
      }
    );
  }

  // 顾客充值
  static chongZhiCustomerMoney({String customerId, String money, VoidCallback successCallback, ErrorCallback errorCallback}) {
    final path = 'chongzhi.action';
    RequestManager.post(
      urlPath: path,
      parame: {'customerid': customerId, 'money': money},
      dataCallback: (dataMap) {
        successCallback();
      },
      errorCallback: errorCallback
    );
  }

  // 修改会员折扣额
  static changeVipDiscountNum({String customerId, String discount, VoidCallback successCallback}) {
    final path = 'changediscountnum.action';
    RequestManager.post(
      urlPath: path,
      parame: {'customerid': customerId, 'discountnum' : discount},
      dataCallback: (dataMap) {
        successCallback();
      },
      errorCallback: (e) {}
    );
  }

  // 导入会员信息
  static importVipCustomerInfo({String phone, String name, String money, String discount, VoidCallback successCallback, ErrorCallback errorCallback}) {
    final path = 'importcustomer.action';
    RequestManager.post(
      urlPath: path,
      parame: {'telephone': phone, 'customername': name, 'money': money, 'discountnum': discount},
      dataCallback: (dataMap) {
        successCallback();
      },
      errorCallback: errorCallback
    );
  }

  // 批量修改未洗衣服为洗完
  static changeOrderNowashToWashed({List<String> orderids, VoidCallback successCallback, ErrorCallback errorCallback}) {
    final path = 'batchupdateorderForm.action';
    RequestManager.post(
      urlPath: path,
      parame: {'orderids': orderids.join(','), 'orderstatus': '1'},
      dataCallback: (dataMap) {
        successCallback();
      },
      errorCallback: errorCallback
    );
  }

  // 客服电话
  static getServicePhone(StringCallback phoneCallback) {
    final path = 'getservicephone.action';
    RequestManager.post(
      urlPath: path,
      parame: {},
      dataCallback: (dataMap) {
        final phone = dataMap['servicephone'];
        phoneCallback(phone);
      }
    );
  }
}
