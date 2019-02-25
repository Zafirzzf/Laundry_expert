import 'package:laundry_expert/Model/OrderInfo.dart';

class OrderListItemOfUser {
  OrderState orderstatus;
  bool hasPay;
  String time;
  String identifynumber;
  String id;
  String money;
  OrderListItemOfUser({this.orderstatus, this.hasPay, this.identifynumber, this.time, this.id, this.money});

  String stateString() {
    switch (orderstatus) {
      case OrderState.noWash:
        return '未洗';
      case OrderState.washed:
        return '待取';
      case OrderState.leave:
        return '已取走';
    }
  }
}