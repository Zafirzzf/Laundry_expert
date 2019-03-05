import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Model/OrderListItem.dart';
import 'package:laundry_expert/OrderDetailScreen.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/UI/RefreshWidget.dart';

class OrderListView extends StatefulWidget {
  VoidCallback detailCallback; // 进入详情页返回后的回调
  OrderState orderState;
  String keyword = '';
  OrderListView({OrderState state, String keywrod, VoidCallback detailcallback}) {
    this.detailCallback = detailcallback;
    this.orderState = state;
    this.keyword = keywrod;
  }
  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with AutomaticKeepAliveClientMixin {

  List<OrderListItem> _items = []; // 源数据
  List<OrderListItem> _displayItems() => _items.where((item) => item.identifynumber.contains(widget.keyword)).toList();
  bool _isEditing = false;
  bool _noMoreData = false;
  int _page = 0;
  bool isLoading = false; // 是否正在请求数据中
  bool canEdit = false;

  final _scrollController = ScrollController();
  List<OrderListItem> _editSelectItems() => _items.where((item) { return item.isSelect;}).toList();
  bool hasSelectItem() => _editSelectItems().isNotEmpty;

  @override
  bool get wantKeepAlive => false;
  
  _clickEditButton() {
    if (_isEditing) {
      // 发送修改的请求
      CommonAlert(title: '确定要将这些衣服设为洗完并发送短信吗?', rightTitle: '确定', rightClick: () {
        APIs.changeOrderNowashToWashed(
          orderids: _editSelectItems().map((item) => item.id).toList(),
          successCallback: () {
            setState(() {
              _isEditing = !_isEditing;
            });
            BottomSheetDialog(text: '修改成功并已发送短信', context: context).show();
            _reloadData();
          },
          errorCallback: (error) {
            BottomSheetDialog(text: error.alertMsg()).show();
          }
        );
      }).show(context);          
  
    } else {
      setState(() {
        _isEditing = !_isEditing;
      });
    }
  }


  _clickOneOrderItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return OrderDetailScreen(_displayItems()[index].id);
    })).then((backValue) {
        _reloadData();
      _fetchListData();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.orderState == OrderState.noWash) {
      canEdit = true;
    }
    _scrollController.addListener(() {
      if (_noMoreData) { return ;}
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30) {
        _loadMoreData();
      }
    });
    _fetchListData();
  }

  _loadMoreData() {
    if (!isLoading) {
      _page++;
      _fetchListData();
    }
  }

  _reloadData() {
    _page = 0;
    _fetchListData();
  }

  _fetchListData() {
    setState(() {
      isLoading = true;
    });
    switch (widget.orderState) {
      case OrderState.noWash:
        APIs.allOrderList(OrderState.noWash, widget.keyword, _page, (list) {
          _receiveNewData(list);
        }); break;
      case OrderState.washed:
        APIs.allOrderList(OrderState.washed, widget.keyword, _page, (list) {
          _receiveNewData(list);
        }); break;
      case OrderState.leave:
        APIs.allOrderList(OrderState.leave, widget.keyword, _page, (list) {
          _receiveNewData(list);
        }); break;
    }
  }

  _receiveNewData(List<OrderListItem> list) {
    setState(() {
      if (_page > 0) {
        if (list.isEmpty) {
          _noMoreData = true;
        } else {
          _items.addAll(list);
        }
      } else {
        _items = list;
      }
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_items == null) {
      return Container();
    } else {
      if (_items.isEmpty) {
        return Center(
            child: isLoading ? CircularProgressIndicator(strokeWidth: 2.0) : Text('暂无此类型订单数据')
        );
      } else {
        return  _normalBody();
      }
    }
  }

  Widget _normalBody() {
    if (canEdit) {
      return SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0, left: 0, right: 0, bottom: 40,
              child: _orderListView(),
            ),
            Positioned(
              left: 0, right: 0, bottom: 0, height: 40,
              child: _bottomSelectView()
            )
          ],
        ),
      );
    } else {
      return _orderListView();
    }
  }

  Widget _bottomSelectView() {
    return Container(
//      width: ScreenInfo.width - 40,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: _isEditing ? _editBottomView() : _noEditBottomView()
    );
  }

  Widget _noEditBottomView() {
    return Center(
      child: CommonBigButton(
        title: '批量设为已洗完',
        enabled: true,
        onPressed: _clickEditButton,
      )
    );
  }

  Widget _editBottomView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text('共选择${_editSelectItems().length}件'),
        const SizedBox(width: 30),
        CommonBigButton(
          title: '确定设为已洗完',
          enabled: hasSelectItem(),
          onPressed: _clickEditButton,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Text('取消'),
              onTap: () {
                setState(() {
                  _items.forEach((item) => item.isSelect = false);
                  _isEditing = false;
                });
              },
            ),
          ),
        )
      ],
    );
  }
  // 订单列表
  Widget _orderListView() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: _displayItems().length + 1,
    );
  }

  // 每一条订单
  Widget _itemOfClothes(int index) {
    if (index == _displayItems().length) {
      return _getMoreWidget();
    }
    if (_isEditing) {
      return Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Positioned(
            child: _orderItemInfoContainer(index, true),
          ),
          Checkbox(value: _displayItems()[index].isSelect, onChanged: (value) {
            setState(() {
              _displayItems()[index].isSelect = value;
            });
          })
        ],
      );
    } else {
      return _orderItemInfoContainer(index, false);
    }
  }

  // 订单信息容器
  Widget _orderItemInfoContainer(int index, bool isEdit) {
    final order = _displayItems()[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        margin: EdgeInsets.fromLTRB(20, 10, 20 + (isEdit ? 40.0 : 0.0), 10),
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
            Row(
              children: <Widget>[
                Text( '${order.customerName} ', style: Styles.normalFont(16, Colors.white)),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(order.time, style: Styles.normalFont(17, Colors.white)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('¥' + order.resultMoney,
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

  Widget _getMoreWidget() {
    return LoadMoreBottomWidget(_noMoreData, isLoading);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
