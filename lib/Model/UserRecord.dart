
class UserRecord {
  String time;
  bool isChongzhi;
  String orderId;
  String money;
  UserRecord(this.time, this.isChongzhi, this.orderId, this.money);

  bool isPositiveNum() => money.contains('+');
}