import 'package:laundry_expert/Model/Customer.dart';

class ClothesInfo {
    Customer customer;
    String type;
    String color;
    String price;
    bool hasPay = false;
    String id = "0";

    ClothesInfo(
        { Customer customer,
          String type,
          String color,
          String price,
          bool hasPay = false,
          String id
        }) {
      this.customer = customer;
      this.type = type;
      this.color = color;
      this.price = price;
      this.hasPay = hasPay;
      this.id = id;
    }
    static List<String> allClothesTypes() {
      return ['普通西服', '普通裤子', '夹克', '休闲服', '羊绒衫', 'T恤', '衬衣',
              '韩式裙子', '羊绒呢短衣', '羊绒呢半大衣', '短风衣', '长风衣', '小棉袄',
              '貂皮上衣', '兔剪绒上衣', '真丝长裙', '真丝上衣', '羽绒马甲', '短羽绒棉袄',
              '半大羽绒棉袄', '羽绒大棉袄', '皮衣', '毛衣', '羊绒大衣', '其它'];
    }
    static List<String> allSelectColors() {
      return ['白色', '米白色', '黑色', '黄色', '蓝色', '绿色', '粉色', '红色',
              '卡其色', '紫色', '驼色', '花色', '其它'];
    }

}





