import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/Customer.dart';
import 'package:laundry_expert/Model/CustomerDetail.dart';

class CustomerDetailScreen extends StatefulWidget {
  @override
  final String customerId;
  const CustomerDetailScreen({this.customerId});

  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {

  CustomerDetail _info;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_info == null ? " " : _info.name),
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

      ],
    );
  }
}
