import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/CustomerDetail.dart';
import 'package:laundry_expert/OrderDetailScreen.dart';
import 'package:laundry_expert/Model/UserRecord.dart';

class UserRecrodScreen extends StatefulWidget {
  String customerId;
  UserRecrodScreen(this.customerId);
  @override
  _UserRecrodScreenState createState() => _UserRecrodScreenState();
}

class _UserRecrodScreenState extends State<UserRecrodScreen> {

  List<UserRecord> _records = [UserRecord('2019-2-2', false, '1221', '-33.3'),
  UserRecord('2019-2-2', true, null, '+33.3')];


  _clickRecordItem(int index) {
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录'),
      ),
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 5, left: 15, right: 15, bottom: 15,
                child: _recordListView(),
              )
            ],
          )
      ),
    );
  }

  Widget _recordListView() {
    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: _itemOfRecord(index),
          onTap: () => _clickRecordItem(index),
        );
      },
      itemCount: _records.length,
    );
  }

  Widget _itemOfRecord(int index) {
    final record = _records[index];
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(height: 6),
                Text(record.isChongzhi ? '充值' : '洗衣服', style: Styles.normalFont(15, Colors.black87),),
                const SizedBox(height: 5),
                Text(record.time, style: Styles.normalFont(14, Colors.black54),)
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                    record.money, style: Styles.normalFont(15, record.isPositiveNum() ? Colors.greenAccent : Colors.redAccent)
                ),
                const SizedBox(width: 5),
                record.orderId == null ? Container() : Icon(Icons.navigate_next, size: 18,)
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(height: 0.5, color: Colors.black26,)
      ],
    );
  }
}
