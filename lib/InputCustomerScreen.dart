import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'package:laundry_expert/NewOrderScreen.dart';
import 'package:laundry_expert/CustomerDetailScreen.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/UI/MyTextField.dart';

/// 选择/输入顾客信息
class InputCustomerScreen extends StatefulWidget {
  final bool isAddOrder; // 是否是添加订单入口
  const InputCustomerScreen({ @required this.isAddOrder});
  _InputCustomerState createState() => _InputCustomerState();
}

class _InputCustomerState extends State<InputCustomerScreen> {

  List<Customer> _existCustomers = [];
  List<Customer> _displayCustomers = [];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _inputVaild = false;

  // 点击空白处
  _clickEmptyArea() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  // 添加顾客信息到后台
  _postCustomerInfo(void Function(Customer customer) newCustomerCallback) {
    final name = _nameController.text;
    final phone = _phoneController.text;
    LoadingDialog.show(context);
    APIs.addCustomer(
      name: name, phone: phone,
      idCallback: (id) {
        LoadingDialog.hide(context);
          final newInfo = Customer(name: name, phoneNum: phone, id: id);
          newCustomerCallback(newInfo);
      },
      errorCallback: (ret) {
        LoadingDialog.hide(context);
      }
    );
  }
  // 点击下一步
  _clickNext() {
    final existCustomer = _existCustomers.
    where((customer) => customer.name == _nameController.text && customer.phoneNum == _phoneController.text).toList();
    Customer selCustomer;
    if (widget.isAddOrder) {
      // 跳转添加订单
      if (existCustomer.length == 0) {
        // 列表中没有此用户, 进行添加
        _postCustomerInfo((newCustomer) {
          _existCustomers.add(newCustomer);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return NewOrderScreen(customer: newCustomer);
          }));
        });
      } else {
        selCustomer = existCustomer.first;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return NewOrderScreen(customer: selCustomer);
        }));
      }
      _nameController.clear();
      _phoneController.clear();
    } else {
      // 跳转顾客详情
      if (existCustomer.length != 1) { TextDialog(text: '请选择一个已存在的顾客信息'); } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CustomerDetailScreen(customerId: existCustomer.first.id);
        }));
      }
    }
  }

  // 点击某一条顾客
  _tapCustomListItem(int index) {
    final customr = _displayCustomers[index];
    _phoneController.text = customr.phoneNum;
    _nameController.text = customr.name;
  }

  // 昵称输入框发生变化
  _nameTextFieldChange(String content) {
    _filterListByInput();
  }

  // 手机号输入框发生变化
  _phoneTextFieldChange(String content) {
    _filterListByInput();
  }

  // 所有数据按输入内容进行筛选
  _filterListByInput() {
    _inputVaild = _phoneController.text.length > 0 && _nameController.text.length > 0;
    _displayCustomers = _existCustomers.where((customer) => customer.name.contains(_nameController.text) && customer.phoneNum.contains(_phoneController.text)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Customer.allDatas((customers) {
      _existCustomers = customers;
      _filterListByInput();
    });

    _displayCustomers = _existCustomers;
    _nameController.addListener(() {
      _nameTextFieldChange(_nameController.text);
    });
    _phoneController.addListener(() {
      _phoneTextFieldChange(_phoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddOrder ? '录入顾客信息' : '选择查询的顾客'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Container(
                width: (ScreenInfo.width(context) - 20) * 3 / 5,
                height: ScreenInfo.height(context) - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _nameInputTF(),
                    const SizedBox(height: 20),
                    _phoneInputTF(),
                    const SizedBox(height: 40),
                    Container(
                      width: (ScreenInfo.width(context) - 20) / 2 - 0,
                      height: 45,
                      child: CommonBigButton(title: '下一步', onPressed: _clickNext, enabled: _inputVaild),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Container(
                width: (ScreenInfo.width(context) - 20) * 2 / 5,
                child:  Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Text('已存在的顾客列表'),
                    ),
                    Positioned(
                      top: 20, left: 0, right: 0, bottom: 20,
                      child: _customersExistList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: _clickEmptyArea,
      )
    );
  }

  Widget _customersExistList() {

    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfCustomerList(index);
      },
      itemCount: _displayCustomers.length,
    );
  }

  Widget _itemOfCustomerList(int index) {
    final customer = _displayCustomers[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 55,
            child: ListTile(title: Text(customer.name), subtitle: Text(customer.phoneNum)),
          ),
          onTap: () { _tapCustomListItem(index); },
        ),
        const SizedBox(height: 2),
        Container(
          height: 1,
          child: Divider(height: 0.5),
        )
      ],
    );
  }

  Widget _nameInputTF() {
    return MyTextField(
      controller: _nameController,
      labelText: '姓名',
      keyboardType: TextInputType.number,
      icon: Icon(Icons.phone_android),
    );
  }

  Widget _phoneInputTF() {
    return MyTextField(
      controller: _phoneController,
      labelText: '手机号',
      keyboardType: TextInputType.number,
      icon: Icon(Icons.phone_android),
    );
  }
}





