
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Model/OrderListItemOfUser.dart';
class CustomerDetail {
  String name;
  String telephone;
  String id;
  bool isvip;
  int discount;
  String remainmoney;
  List<OrderListItemOfUser> orderLists;

  CustomerDetail({this.name, this.discount, this.telephone, this.id, this.isvip, this.orderLists, this.remainmoney});
}
