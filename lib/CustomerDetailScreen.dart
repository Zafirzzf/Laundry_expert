import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/Customer.dart';

class CustomerDetailScreen extends StatefulWidget {
  @override
  final String customerId;
  const CustomerDetailScreen({this.customerId});

  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {

  _clickOneCustomer(int index) {

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('所有顾客列表'),
      ),
      body: Container(),
    );
  }
}
