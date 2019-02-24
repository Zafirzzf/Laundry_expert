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
import 'package:laundry_expert/Model/OrderListItem.dart';
import 'package:laundry_expert/OrderDetailScreen.dart';

// 所有订单列表
class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {

  final _searchController = TextEditingController();
  bool _isSearching = false;
  int _page;
  String _identifyNumber;
  List<OrderListItem> _nowashDatas = [];
  List<OrderListItem> _washedDatas = [];
  List<OrderListItem> _leaveDatas = [];

  _clickSearchClick() {
    setState(() {
      _isSearching = true;
    });
  }
  
  _fetchListData() {
    APIs.allOrderList(OrderState.washed, _identifyNumber, _page, (list) {
      setState(() {
        _washedDatas = list;
      });
    });
    APIs.allOrderList(OrderState.noWash, _identifyNumber, _page, (list) {
      setState(() {
        _nowashDatas = list;
      });
    });
    APIs.allOrderList(OrderState.leave, _identifyNumber, _page, (list) {
      setState(() {
        _leaveDatas = list;
      });
    });
  }

  @override
  void initState() {
    _fetchListData();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _isSearching ? _searchAppbar() : _normalAppbar(),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0, left: 0, right: 0, bottom: 10,
              child: TabBarView(
                children: <Widget>[
                  OrderListView(_washedDatas, () => _fetchListData()),
                  OrderListView(_nowashDatas, () => _fetchListData()),
                  OrderListView(_nowashDatas, () => _fetchListData()),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _searchAppbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isSearching = false;
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: '按条件搜索订单',
          hintStyle: TextStyle(color: Colors.white)
        ),
      ),
    );
  }

  Widget _normalAppbar() {
    return AppBar(
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: _clickSearchClick)
      ],
      title: Text('所有订单'),
      bottom: TabBar(tabs: _tabBarTitles()),
    );
  }

  List<Widget> _tabBarTitles() {
    return ['待取', '未洗', '取走'].map((title) => Tab(text: title)).toList();
  }
}

class OrderListView extends StatelessWidget {
  List<OrderListItem> items;
  VoidCallback detailCallback;
  OrderListView(this.items, this.detailCallback);
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (items == null) {
      return Container();
    } else {
      if (items.isEmpty) {
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
      itemCount: items.length,
    );
  }
  _clickOneOrderItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return OrderDetailScreen(items[index].id);
    })).then((backValue) {
      detailCallback();
    });
  }

  // 每一条订单
  Widget _itemOfClothes(int index) {
    final order = items[index];
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
