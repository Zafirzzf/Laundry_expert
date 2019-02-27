import 'package:flutter/material.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/UI/MyButtons.dart';

class AddVipScreen extends StatefulWidget {
  @override
  _AddVipScreenState createState() => _AddVipScreenState();
}

class _AddVipScreenState extends State<AddVipScreen> {
  final _nameInputController = TextEditingController();
  final _phoneInputController = TextEditingController();
  final _moneyInputController = TextEditingController();

  bool _confirmEnabled() {
    return _nameInputController.text.isNotEmpty && _phoneInputController.text.isNotEmpty &&
          _moneyInputController.text.isNotEmpty;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加会员'),
      ),
      body: _bodyWidget(),
    );
  }

  _clickConfirm() {
    if (_confirmEnabled()) {
      APIs.importVipCustomerInfo(
          phone: _phoneInputController.text,
          name: _nameInputController.text,
          money: _moneyInputController.text,
          successCallback: () {
            BottomSheetDialog(text: '添加成功', context: context).show();
            _phoneInputController.clear();
            _nameInputController.clear();
            _moneyInputController.clear();
          },
          errorCallback: (error) {
            BottomSheetDialog(text: error.alertMsg(), context: context).show();

          }
      );
    } else {
       BottomSheetDialog(text: '信息未填写完整',context: context).show();
    }
  }

  Widget _bodyWidget() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Center(
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _nameInputController,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: '会员姓名'
              ),
            ) ,
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              controller: _phoneInputController,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_android),
                labelText: '会员手机号'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              controller: _moneyInputController,
              decoration: InputDecoration(
                icon: Icon(Icons.attach_money),
                labelText: '会员余额'
              ),
            ),
            const SizedBox(height: 30),
            CommonBigButton(title: '确定', onPressed: _clickConfirm)
          ],
        ),
      ),
    );
  }
}
