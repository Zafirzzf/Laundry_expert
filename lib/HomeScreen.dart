
import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/InputCustomerScreen.dart';
import 'package:laundry_expert/CustomersScreen.dart';
import 'package:laundry_expert/Request/APIs.dart';

class HomeScreen extends StatefulWidget {

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _clickAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
      return InputCustomerScreen();
      },
      settings: RouteSettings(name: 'inputCustomer')
    ));
  }

  _clickTakeClothes() {

  }

  _clickFindCustomer() {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return CustomersScreen();
    }));
  }

  _clickClothesStore() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("老周福莱特洗衣店"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: ScreenInfo.width - 40,
              height: 90,
              child: CommonBigButton(
                title: '取衣服',
                onPressed: _clickTakeClothes,
                backColor: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: ScreenInfo.width - 60,
              height: 65,
              child: CommonBigButton(
              title: '查顾客',
              onPressed: _clickFindCustomer,
              backColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: ScreenInfo.width - 60,
              height: 65,
              child: CommonBigButton(
                title: '衣库',
                onPressed: _clickClothesStore,
                backColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(30),
                gradient: RadialGradient(
                  colors: [Colors.blue, Colors.cyan],
                  radius: 0.6
                )
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: _clickAdd,
              ),
            )
          ],
        ),
      )
    );
  }
}
