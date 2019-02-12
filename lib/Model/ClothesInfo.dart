import 'package:laundry_expert/Model/Customer.dart';

enum ClothesType {
  suit, // 西服
  woolenCoat // 呢子大衣
}

enum ClothesState {
  noWash,
  washed,
  leave
}
class ClothesInfo {
    Customer customer;
    ClothesType type;
    String color;
    ClothesState state = ClothesState.noWash;
    int price = 0;
    bool hasPay = false;
    String id = "0";

    ClothesInfo(
        { Customer customer,
          ClothesType type,
          String color,
          ClothesState state = ClothesState.noWash,
          int price,
          bool hasPay = false,
          String id
        }) {
      this.customer = customer;
      this.type = type;
      this.color = color;
      this.state = state;
      this.price = price;
      this.hasPay = hasPay;
      this.id = id;
    }

    static List<ClothesInfo> testDatas(Customer customer) {
      return [ClothesInfo(customer: customer, type: ClothesType.suit, color: '黑色', id: "103"),
      ClothesInfo(customer: customer, type: ClothesType.suit, color: '黑色', id: "109"),
      ClothesInfo(customer: customer, type: ClothesType.suit, color: '黑色', id: "103"),
      ClothesInfo(customer: customer, type: ClothesType.suit, color: '黑色', id: "102")];
    }

    String typeString() {
      return ClothesInfo.typeToString(type);
    }

    String stateString() {
      switch (state) {
        case ClothesState.noWash:
          return '未洗';
        case ClothesState.washed:
          return '已洗完';
        case ClothesState.leave:
          return '已取走';
      }
    }

    static String typeToString(ClothesType type) {
      switch (type) {
        case ClothesType.suit:
          return '西服';
        case ClothesType.woolenCoat:
          return '呢子大衣';
      }
    }

    static List<String> allTypeStrings() {
      return ClothesType.values.map( (type) => typeToString(type) ).toList();
    }

    static List<String> allSelectColors() {
      return ['黑色', '白色', '红色', '蓝色', '褐色', '花色', '迷彩', '其它'];
    }

}





