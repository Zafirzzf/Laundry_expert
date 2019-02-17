import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/UI/MyTextField.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/Model/OrderDetail.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen(this.orderId);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  @override
  void initState() {
    super.initState();

  }

  _fetchOrderData() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('aaa')
              ],
            )
          ],
        ),
      ),
    );
  }
}
