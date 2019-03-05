
import 'package:laundry_expert/Request/APIs.dart';

class Customer {
  String name;
  String phoneNum;
  String id;
  Customer({String name, String phoneNum, String id}) {
    this.name = name;
    this.phoneNum = phoneNum;
    this.id = id;
  }
  static List<Customer> _datas;
  static bool loadedData() {
    if (_datas == null) { return false; }
    return _datas.isNotEmpty;
  }
  static List<Customer> allDatas(void Function(List<Customer> lists) listCallback) {
    if (_datas == null) {
      APIs.customersList((list) {
        _datas = list;
        listCallback(list);
      });
    } else {
      listCallback(_datas);
    }
  }

  static appenNewCustomer(Customer customer) {
    _datas.add(customer);
  }

  @override
  String toString() {
    return name + phoneNum;
  }
}