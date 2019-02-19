
import 'package:laundry_expert/Model/OrderInfo.dart';

class CustomerDetail {
  String name;
  String telephone;
  String id;
  String status;
  List<OrderListItem> orderLists;
  CustomerDetail({this.name, this.telephone, this.id, this.status, this.orderLists}) {
    this.name = name;
    this.telephone = telephone;
    this.id = id;
    this.status = status;
    this.orderLists = orderLists;
  }
}

class OrderListItem {
  OrderState orderstatus;
  bool hasPay;
  String identifynumber;
  OrderListItem({this.orderstatus, this.hasPay, this.identifynumber});
}