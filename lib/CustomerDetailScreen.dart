import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/CustomerDetail.dart';
import 'package:laundry_expert/OrderDetailScreen.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';

class CustomerDetailScreen extends StatefulWidget {
  @override
  final String customerId;
  const CustomerDetailScreen({this.customerId});

  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {

  CustomerDetail _info;
  String _barTitle() {
    return _info == null ? "" : _info.name + (_info.isvip ? '会员' : "");
  }

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  _fetchDetailData() {
    APIs.customerDetailInfo(customerId: widget.customerId, infoCallback: (info) {
      _info = info;
      setState(() {});
    });
  }

  _clickOneOrderItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return OrderDetailScreen(_info.orderLists[index].id);
    }));
  }

  _clickChongzhi() {
    ChongzhiAlert((inputText) {
      final money = int.parse(inputText);

    }).show(context);
  }

  _selectOrderstateOrList(int index) {
    final orderState = OrderState.values[index];
    print(orderState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_barTitle()),
      ),
      body: _bodyState(),
    );
  }

  Widget _bodyState() {
    return _info == null? Container() : mainBody();
  }

  Widget mainBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 15, left: 0, right: 0, height: 40,
          child: MySegement(itemsTitles: ['待取', '未洗', '取走'], indexClick: _selectOrderstateOrList),
        ),
        Positioned(
          top: 60, left: 20, right: 20, bottom: 80,
          child: _clothesList(),
        ),
        Positioned(
          left: 0, right: 0, bottom: 20,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
//                        border: Border.all(width: 1, color: Colors.blue),
                boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 0.8)],
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Row(
              children: <Widget>[
                Text('余额 ', style: Styles.normalFont(15, Colors.black)),
                Text(_info.remainmoney, style: Styles.normalFont(20, Colors.blue)),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text('充值'),
                        onPressed: _clickChongzhi),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // 订单列表
  Widget _clothesList() {
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: _info.orderLists.length,
    );
  }

  // 每一条订单
  Widget _itemOfClothes(int index) {
    final order = _info.orderLists[index];
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('编号 ${order.identifynumber}', style: Styles.mediumFont(16, Colors.white)),
                Text(order.stateString(), style: Styles.normalFont(16, Colors.white))
              ],
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.centerRight,
              child: Text(order.time, style: Styles.normalFont(17, Colors.white)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('¥' + order.money,
                    style: order.hasPay ?
                    Styles.overlineNormal(20, Colors.white) : Styles.normalFont(20, Colors.white)),
                const SizedBox(width: 30),
                Text(order.hasPay ? '已付' : '未付', style: Styles.normalFont(16, Colors.white))
              ],
            )
          ],
        ),
      ),
      onTap: () { _clickOneOrderItem(index); },
    );
  }
}
