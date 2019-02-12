import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/UI/MyTextField.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/UI/Dialogs.dart';

class NewOrderScreen extends StatefulWidget {

  Customer customer;
  NewOrderScreen(Customer customer) {
    this.customer = customer;
  }
  NewOrderState createState() => NewOrderState(customer);
}

class NewOrderState extends State<NewOrderScreen> {

  Customer _customer;
  String _idNumber = '308';
  List<ClothesInfo> _clothes = [];

  NewOrderState(Customer customer) {
    this._customer = customer;
  }

  // 点击空白处
  _clickEmptyArea() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // 点击添加衣服信息
  _clickAddClothes() {
    AddNewClothesDialog((newClothes) {
      newClothes.customer = _customer;
      newClothes.id = _idNumber;
      _clothes.add(newClothes);
      setState(() {});
    }).show(context);
  }

  // 点击某一条衣服信息
  _clickClothesItem(int index) {

  }
  // 点击录入完毕
  _clickComplete() {

  }

  @override
  void initState() {
    super.initState();
//    _clothes = ClothesInfo.testDatas(_customer);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('新的订单'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 10, left: 5, right: 5, bottom: 100,
                child: Column(
                  children: <Widget>[
                    // 姓名
                    Row(
                      children: <Widget>[
                        Text('姓名: ', style: Styles.normalFont(16, Colors.black)),
                        const SizedBox(width: 16),
                        Text(_customer.name, style: Styles.mediumFont(22, Colors.blue)),
                        const SizedBox(width: 30),
                        Text('识别号: ', style: Styles.normalFont(16, Colors.black)),
                        const SizedBox(width: 16),
                        Text(_idNumber, style: Styles.mediumFont(22, Colors.blue)),
                      ],
                    ),
                    // 副标题
                    const SizedBox(height: 20),
                    Center(
                      child: Text('送来的衣服列表', style: Styles.normalFont(16, Colors.black)),
                    ),
                    const SizedBox(height: 20),
                    // 衣服列表
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
//                        border: Border.all(width: 1, color: Colors.blue),
                        boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 0.8)],
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      height: _listViewHeight(),
                      child: _clothesList(),
                    ),
                    // 添加按钮
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _addCircleButton(),
                          const SizedBox(width: 20),
                          Text('添加衣服', style: Styles.normalFont(13, Colors.black))
                        ],
                      ),
                      onTap: _clickAddClothes,
                    )
                  ],
                ),
              ),
              Positioned(
                left: 15, right: 0, bottom: 75,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text('总共'),
                      Text(' ${_clothes.length} ', style: Styles.mediumFont(25, Colors.blue)),
                      Text('件'),
                      const SizedBox(width: 40),
                      Text('需支付'),
                      Text(' ${_clothes.fold(0, (value, element) => value + element.price)} ',
                          style: Styles.mediumFont(25, Colors.blue)),
                      Text('元'),
                    ],
                  )
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 20,
                child: Container(
                  height: 45,
                  child: CommonBigButton(title: '录入完毕', onPressed: _clickComplete),
                )
              )
            ],
          ),
        ),
        onTap: _clickEmptyArea,
      )
    );
  }
  // 列表的高度
  double _listViewHeight() {
    final dataCount = _clothes.length;
    double height = dataCount.toDouble() * 50;
    final maxHeight = ScreenInfo.height - ScreenInfo.topPadding(context) - 44 - 100 - 85 - 120;
    if (height > maxHeight) {
      height = maxHeight;
    }
    return height;
  }
  // 衣服列表
  Widget _clothesList() {
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: _clothes.length,
    );
  }

  // 每一条衣服
  Widget _itemOfClothes(int index) {
    final clothes = _clothes[index];
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Text('${clothes.typeString()}  ${clothes.color}   ${clothes.price} 元',
                style: Styles.normalFont(18, Colors.black)),
              )
            ],
          ),
          (index == _clothes.length - 1) ? Container() : Padding(padding: EdgeInsets.only(left: 15, right: 15), child: Divider())
        ],
      ),
      onTap: () { _clickClothesItem(index); },
    );
  }

  // 添加按钮
  Widget _addCircleButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue,
              width: 2
          ),
          borderRadius: BorderRadius.circular(20),
          gradient: RadialGradient(
              colors: [Colors.blue, Colors.cyan],
              radius: 0.4
          )
      ),
      child: Icon(Icons.add)
    );
  }
}