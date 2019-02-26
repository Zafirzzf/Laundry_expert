import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/OrderListItem.dart';
import 'package:laundry_expert/SubWidget/OrderListView.dart';

// 所有订单列表
class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {

  final _searchController = TextEditingController();
  bool _isSearching = false;
  int _page = 0;
  String _identifyNumber;

  _clickSearchClick() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  void initState() {

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: _isSearching ? _searchAppbar() : _normalAppbar(),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0, left: 0, right: 0, bottom: 10,
              child: TabBarView(
                children: <Widget>[
                  OrderListView(state: OrderState.washed, keywrod: _searchController.text, detailcallback: null),
                  OrderListView(state: OrderState.noWash, keywrod: _searchController.text, detailcallback: null),
                  OrderListView(state: OrderState.leave, keywrod: _searchController.text, detailcallback: null)
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
          hintText: '按编号搜索订单',
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

