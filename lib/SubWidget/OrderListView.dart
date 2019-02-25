import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Model/OrderListItem.dart';
import 'package:laundry_expert/OrderDetailScreen.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/Request/RequestManager.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';


class OrderListView extends StatefulWidget {
  List<OrderListItem> items;
  VoidCallback detailCallback; // 进入详情页返回后的回调
  bool canEdit = false;
  OrderListView({List<OrderListItem> items, VoidCallback detailcallback, bool canEdit = false}) {
    this.items = items;
    this.detailCallback = detailcallback;
    this.canEdit = canEdit;
  }
  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {

  List<OrderListItem> items() => widget.items;
  bool _isEditing = false;
  List<OrderListItem> _editSelectItems() => items().where((item) { return item.isSelect;}).toList();
  bool hasSelectItem() => _editSelectItems().isNotEmpty;

  
  _clickEditButton() {
    if (_isEditing) {
      // 发送修改的请求

    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (items() == null) {
      return Container();
    } else {
      if (items().isEmpty) {
        return Center(child: Text('暂无此类型订单数据'));
      } else {
        return  _normalBody();
      }
    }
  }

  Widget _normalBody() {
    if (widget.canEdit) {
      return Stack(
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
      );
    } else {
      return _orderListView();
    }
  }

  Widget _bottomSelectView() {
    return Container(
      width: ScreenInfo.width - 40,
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
      itemBuilder:(BuildContext context, int index) {
        return _itemOfClothes(index);
      },
      itemCount: items().length,
    );
  }

  _clickOneOrderItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return OrderDetailScreen(items()[index].id);
    })).then((backValue) {
      widget.detailCallback();
    });
  }

  // 每一条订单
  Widget _itemOfClothes(int index) {
    if (_isEditing) {
      return Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Positioned(
            child: _orderItemInfoContainer(index, true),
          ),
          Checkbox(value: items()[index].isSelect, onChanged: (value) {
            setState(() {
              items()[index].isSelect = value;
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
    final order = items()[index];
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
                Text( '${order.customerName}  ${order.clothesColor} ${order.clothesType}', style: Styles.normalFont(16, Colors.white)),
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
