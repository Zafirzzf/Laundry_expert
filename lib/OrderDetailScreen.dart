import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen(this.orderId);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  OrderInfo _orderInfo;
  _clothes() => _orderInfo.clothesList;

  @override
  void initState() {
    super.initState();

    _fetchOrderData();
  }

  _fetchOrderData() {
    APIs.orderDetailInfo(orderid: widget.orderId, infoCallback: (info) {
      _orderInfo = info;
      setState(() {});
    });
  }

  _clickClothesItem(int index) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: bodyState()
    );
  }

  Widget bodyState() {
    return _orderInfo == null ? Container() : mainBody();
  }

  Widget mainBody() {
    return Card(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20, left: 20, right: 20,
            child:  Row(
              children: <Widget>[
                Text(_orderInfo.name, style: Styles.normalFont(20, Colors.blue)),
                const SizedBox(width: 30),
                Text(_orderInfo.phone, style: Styles.normalFont(17, Colors.blue)),
              ],
            ),
          ),
          Positioned(
            top: 50, left: 20, right: 20, bottom: 100,
            child: Card(child: _clothesList()),
          )
        ],
      ),
    );
  }

  // 衣服列表
  Widget _clothesList() {
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: _clothes().length,
    );
  }

  // 每一条衣服
  Widget _itemOfClothes(int index) {
    final clothes = _clothes()[index];
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Text('${clothes.type}  ${clothes.color}   ${clothes.price} 元',
                    style: Styles.normalFont(16, Colors.black)),
              )
            ],
          ),
          (index == _clothes().length - 1) ? Container() : Padding(padding: EdgeInsets.only(left: 15, right: 15), child: Divider())
        ],
      ),
      onTap: () { _clickClothesItem(index); },
    );
  }

}
