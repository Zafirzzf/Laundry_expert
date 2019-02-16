
class ShopInfo {
  static ShopInfo shared = ShopInfo();
  String name;
  String token = '';
  static bool isLogin() {
    if (ShopInfo.shared == null) {
      return false;
    } else {
      return ShopInfo.shared.token.length > 0;
    }
  }
}