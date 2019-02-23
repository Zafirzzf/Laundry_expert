import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/ClothesInfo.dart';

/// 订单详情
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

  _selectWashState(OrderState state) {
    LoadingDialog.show(context);
    APIs.changeOrderState(orderId: widget.orderId, state: state, successCallback: (isSuccess) {
      LoadingDialog.hide(context);
      if (isSuccess) {
        setState(() {
          _orderInfo.state = state;
        });
      }
    },
      errorCallback: (error) {
        LoadingDialog.hide(context);
        TextDialog(text: error.alertMsg()).show(context);
      }
    );
  }

  _selectPayStatus(bool isPay) {
    LoadingDialog.show(context);
    APIs.changeOrderPayStatus(orderId: widget.orderId, hasPay: isPay, successCallback: () {
      LoadingDialog.hide(context);
       setState(() {
         _orderInfo.hasPay = isPay;
       });
    }, errorCallback: (error) {
      LoadingDialog.hide(context);
      TextDialog(text: error.alertMsg()).show(context);
    });
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
      margin: EdgeInsets.all(15),
      elevation: 5,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 15, left: 15, right: 15,
            child:  Row(
              children: <Widget>[
                Text('编号 ' + _orderInfo.identifynumber, style: Styles.normalFont(20, Colors.blue)),
                const SizedBox(width: 20),
                Text(_orderInfo.name, style: Styles.normalFont(20, Colors.blue)),
                const SizedBox(width: 30),
                Text(_orderInfo.phone, style: Styles.normalFont(17, Colors.blue)),
              ],
            ),
          ),
          Positioned(
            top: 50, left: 20, right: 20, bottom: 150,
            child: _clothesList(),
          ),
          Positioned(
            left: 15, right: 15, bottom: 110,
            child: _washStateSel(),
          ),
          Positioned(
            left: 15, right: 15, bottom: 70,
            child: _payStateSel(),
          ),
          Positioned(
            left: 15, right: 15, bottom: 20,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(_orderInfo.clothesList.length.toString() + ' 件', style: Styles.normalFont(17, Colors.black87)),
                    const SizedBox(width: 30),
                    Text('共  ', style: Styles.normalFont(17, Colors.black87)),
                    Text(_orderInfo.totalMoney(), style: Styles.normalFont(25, _orderInfo.hasPay ? Colors.green : Colors.red)),
                    Text('  元', style: Styles.normalFont(17, Colors.black87)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(_orderInfo.createTime, style: Styles.normalFont(14, Colors.black87)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _washStateSel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('未洗'),
        Checkbox(value: _orderInfo.state == OrderState.noWash, onChanged: (sel)
        {if (sel) {_selectWashState(OrderState.noWash);};}),
        Text('已洗完'),
        Checkbox(value: _orderInfo.state == OrderState.washed, onChanged: (sel)
        {if (sel) {_selectWashState(OrderState.washed);};}),
        Text('已取走'),
        Checkbox(value: _orderInfo.state == OrderState.leave, onChanged: (sel)
        {if (sel) {_selectWashState(OrderState.leave);};}),
      ],
    );
  }

  Widget _payStateSel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('未付'),
            Checkbox(value: !_orderInfo.hasPay, onChanged: (sel)
            {if (sel) {_selectPayStatus(false);};}),
            Text('已付'),
            Checkbox(value: _orderInfo.hasPay, onChanged: (sel)
            {if (sel) {_selectPayStatus(true);};}),
          ],
        )
      ],
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
    final clothes = _clothes()[index] as ClothesInfo;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(clothes.color + "   ${clothes.type}", style: Styles.normalFont(16, Colors.white)),
            Text('¥${clothes.price}', style: Styles.normalFont(16, Colors.white))
          ],
        ),
      ),
      onTap: () { _clickClothesItem(index); },
    );
  }

}
