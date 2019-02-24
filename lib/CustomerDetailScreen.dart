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
import 'package:laundry_expert/UserRecordScreen.dart';


/// 顾客信息详情
class CustomerDetailScreen extends StatefulWidget {
  @override
  final String customerId;
  const CustomerDetailScreen({this.customerId});

  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {

  CustomerDetail _noWashInfo;
  CustomerDetail _washedInfo;
  CustomerDetail _leaveInfo;
  String _barTitle() {
    return _noWashInfo == null ? "" : _noWashInfo.name + (_noWashInfo.isvip ? '(会员)' : "");
  }

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  // 此接口目的是获取余额与是否是会员
  _fetchDetailData() {
    APIs.customerDetailInfo(customerId: widget.customerId, state: OrderState.noWash, infoCallback: (info) {
      _noWashInfo = info;
      setState(() {});
    });
    APIs.customerDetailInfo(customerId: widget.customerId, state: OrderState.washed, infoCallback: (info) {
      _washedInfo = info;
      setState(() {});
    });
    APIs.customerDetailInfo(customerId: widget.customerId, state: OrderState.leave, infoCallback: (info) {
      _leaveInfo = info;
      setState(() {});
    });
  }

  _clickHistoryRecord() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return UserRecrodScreen(widget.customerId);
    }));
  }

  _clickChongzhi() {
    ChongzhiAlert((inputText) {
      final money = int.parse(inputText);
      APIs.chongZhiCustomerMoney(
          customerId: widget.customerId, money: money.toString(), successCallback: () {
          TextDialog(text: '充值成功').show(context);
          setState(() {
            _noWashInfo.remainmoney = (int.parse(_noWashInfo.remainmoney) + money).toString();
          });
        }, errorCallback: (error) {
        }
      );
    }).show(context);
  }

  _selectOrderstateOrList(int index) {
    final orderState = OrderState.values[index];
    print(orderState);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(icon: Icon(Icons.library_books), onPressed: _clickHistoryRecord)
            ],
            title: Text(_barTitle()),
            bottom: TabBar(tabs: _tabBarTitles()),
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0, left: 0, right: 0, bottom: 50,
                child: TabBarView(
                  children: <Widget>[
                    CustomersOrderListView(_washedInfo, () => _fetchDetailData()),
                    CustomersOrderListView(_noWashInfo, () => _fetchDetailData()),
                    CustomersOrderListView(_leaveInfo, () => _fetchDetailData()),
                  ],
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 0, height: 50,
                child: _bottomMoneyView(),
              )
            ],
          ),
        )
    );
  }



  List<Widget> _tabBarTitles() {
    return ['待取', '未洗', '取走'].map((title) => Tab(text: title)).toList();
  }

  Widget _bottomMoneyView() {
    return _washedInfo == null ? Container() : Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black26),
        boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 0.8)],
      ),
      child: Row(
        children: <Widget>[
          Text('余额 ', style: Styles.normalFont(15, Colors.black)),
          Text(_noWashInfo.remainmoney, style: Styles.normalFont(20, Colors.blue)),
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
    );
  }
}

class CustomersOrderListView extends StatelessWidget {
  CustomerDetail info;
  VoidCallback detailCallback;
  CustomersOrderListView(this.info, this.detailCallback);
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (info == null) {
      return Container();
    } else {
      if (info.orderLists.isEmpty) {
        return Center(child: Text('暂无此类型订单数据'));
      } else {
        return _orderListView();
      }
    }
  }

  // 订单列表
  Widget _orderListView() {
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: info.orderLists.length,
    );
  }
  _clickOneOrderItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return OrderDetailScreen(info.orderLists[index].id);
    })).then((backValue) {
      detailCallback();
    });
  }

  // 每一条订单
  Widget _itemOfClothes(int index) {
    final order = info.orderLists[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
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
