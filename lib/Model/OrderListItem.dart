import 'package:laundry_expert/Model/OrderInfo.dart';

class OrderListItem {
  OrderState orderstatus;
  bool hasPay;
  String time;
  String identifynumber;
  String id;
  String totalMoney;
  String resultMoney;
  String customerName;
  bool isSelect = false; // 编辑状态下的标记

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
  OrderListItem({this.orderstatus, this.hasPay, this.time, this.identifynumber, this.id,
                  this.totalMoney, this.resultMoney, this.customerName});
}