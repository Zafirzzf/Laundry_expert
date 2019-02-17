import 'package:laundry_expert/Model/ClothesInfo.dart';
enum OrderState {
  noWash,
  washed,
  leave
}

class OrderDetail {
  String name;
  String phone;
  String orderNum;
  bool hasPay;
  OrderState state;

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