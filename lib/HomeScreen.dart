
import 'package:flutter/material.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/InputCustomerScreen.dart';
import 'package:laundry_expert/AddVipScreen.dart';
import 'package:laundry_expert/OrderListScreen.dart';
import 'package:laundry_expert/DatePickerScreen.dart';
import 'package:laundry_expert/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/Model/GlobalInfo.dart';
import 'package:laundry_expert/LoginScreen.dart';
import 'package:laundry_expert/Tool/Preferences.dart';
import 'package:laundry_expert/UI/Dialogs.dart';

class HomeScreen extends StatefulWidget {

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _clickAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
      return InputCustomerScreen(isAddOrder: true);
      },
      settings: RouteSettings(name: 'inputCustomer')
    ));
  }

  _clickFindCustomer() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return InputCustomerScreen(isAddOrder: false);
    }));
  }

  _clickFindOrders() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return OrderListScreen();
    }));
  }

  _clickAddVipCustomerInfo() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddVipScreen();
    }));
  }

  _clickSearchOrdersByDate() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DatePickerScreen();
    }));
  }

  @override
  void initState() {
    super.initState();
    // 如果登录过期,回首页
    GlobalInfo.loginInvalidCallback = () {

      Navigator.pop(context);
      Preferences.setToken('');
      GlobalInfo.shared.token = '';

      TextDialog(text: '其它设备登录了此账号,请重新登录', dismissed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(() {
          Navigator.pop(context);
        })));

      }).show(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("老周福莱特洗衣店"),
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            Container(
              width: ScreenInfo.width(context) - 60,
              height: 65,
              child: CommonBigButton(
              title: '查顾客',
              onPressed: _clickFindCustomer,
              backColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: ScreenInfo.width(context) - 60,
              height: 65,
              child: CommonBigButton(
                title: '查订单',
                onPressed: _clickFindOrders,
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(child: Center(child: Text('洗衣专家'))),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('导入会员信息'),
            onTap: _clickAddVipCustomerInfo,
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('按日期查找订单'),
            onTap: _clickSearchOrdersByDate,
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('重新登录'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginScreen((){
                  Navigator.pop(context);
                });
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_bluetooth_speaker),
            title: Text('联系客服'),
            onTap: () {
              APIs.getServicePhone((phone) {
                launch('tel:${phone}');
              });
            },
          )
        ],
      ),
    );
  }
}
