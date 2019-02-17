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
  String createTime;
  List<ClothesInfo> clothesList;
  OrderInfo({String name, String phone, String orderNum,
    bool hasPay, OrderState state, String createTime,
    List<ClothesInfo> clothesList}) {
    this.name = name;
    this.phone = phone;
    this.orderNum = orderNum;
    this.hasPay = hasPay;
    this.state = state;
    this.createTime = createTime;
    this.clothesList = clothesList;
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