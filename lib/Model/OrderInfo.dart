import 'package:laundry_expert/Model/ClothesInfo.dart';
enum OrderState {
  noWash,
  washed,
  leave

}

class OrderInfo {
  String name;
  String phone;
  String orderNum;
  bool hasPay;
  OrderState state;
  String identifynumber;
  String createTime;
  String resultMoney;
  bool isVip;
  String discount;
  List<ClothesInfo> clothesList;
  OrderInfo({this.name, this.phone, this.orderNum,
  this.hasPay, this.discount, this.state, this.identifynumber, this.createTime, this.clothesList, this.isVip, this.resultMoney});

  String totalMoney() {
    final money = clothesList.fold(0, (value, element) => value + int.parse(element.price));
    return (money as int).toString();
  }
  String stateString() {
    switch (state) {
      case OrderState.noWash:
        return '未洗';
      case OrderState.washed:
        return '已洗完';
      case OrderState.leave:
        return '已取走';
    }
  }

}