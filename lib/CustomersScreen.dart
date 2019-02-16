import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/Customer.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {

  List<Customer> _customers = [];

  _clickOneCustomer(int index) {

  }

  @override
  void initState() {
    super.initState();
    APIs.customersList((list) {
      _customers = list;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('所有顾客列表'),
      ),
      body: _customersList(),
    );
  }

  Widget _customersList() {

    return ListView.builder(
      itemBuilder:(BuildContext context, int index) {
        return _itemOfCustomerList(index);
      },
      itemCount: _customers.length,
    );
  }

  Widget _itemOfCustomerList(int index) {
    final customer = _customers[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 55,
            child: ListTile(title: Text(customer.name), subtitle: Text(customer.phoneNum)),
          ),
          onTap: () { _clickOneCustomer(index); },
        ),
        const SizedBox(height: 2),
        Container(
          height: 1,
          child: Divider(height: 0.5),
        )
      ],
    );
  }
}
