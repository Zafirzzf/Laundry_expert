
import 'package:laundry_expert/Model/OrderInfo.dart';

class CustomerDetail {
  String name;
  String telephone;
  String id;
  bool isvip;
  String remainmoney;
  List<OrderListItem> orderLists;
  CustomerDetail({this.name, this.telephone, this.id, this.isvip, this.orderLists, this.remainmoney});
}

class OrderListItem {
  OrderState orderstatus;
  bool hasPay;
  String time;
  String identifynumber;
  String id;
  OrderListItem({this.orderstatus, this.hasPay, this.identifynumber, this.time, this.id});
}