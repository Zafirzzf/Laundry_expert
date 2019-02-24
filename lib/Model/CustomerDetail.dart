
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Model/OrderListItem.dart';
class CustomerDetail {
  String name;
  String telephone;
  String id;
  bool isvip;
  String remainmoney;
  List<OrderListItem> orderLists;
  CustomerDetail({this.name, this.telephone, this.id, this.isvip, this.orderLists, this.remainmoney});
}
