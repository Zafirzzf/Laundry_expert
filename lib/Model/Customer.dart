

class Customer {
  String name;
  String phoneNum;
  String id = '';
  Customer({String name, String phoneNum, String id}) {
    this.name = name;
    this.phoneNum = phoneNum;
    this.id = id;
  }

  static List<Customer> testDatas() {
    return [Customer(name: '周正飞', phoneNum: '18311192304'),
    Customer(name: '张飞', phoneNum: '18311192304'),
    Customer(name: '李三', phoneNum: '18311192304'),
    Customer(name: '王五', phoneNum: '18311192304')];
  }
  @override
  String toString() {
    return name + phoneNum;
  }
}