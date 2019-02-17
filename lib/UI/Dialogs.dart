
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/Model/OrderDetail.dart';
import 'dart:async';

class _AddNewClothesWidget extends StatefulWidget {

  AddClothesCallback addCallback;
  _AddNewClothesWidget(AddClothesCallback callback) {
    this.addCallback = callback;
  }
  @override
  _AddNewClothesWidgetState createState() => _AddNewClothesWidgetState(addCallback);
}

class _AddNewClothesWidgetState extends State<_AddNewClothesWidget> {

  AddClothesCallback addCallback;
  _AddNewClothesWidgetState(AddClothesCallback addCallback) {
    this.addCallback = addCallback;
  }
  final _priceInput = TextEditingController();

  ClothesType _type;
  String _color;
  int _price;
  String _wrongMsg;

  _clickConfirm() {
    _price = int.parse(_priceInput.text);
    if (_type == null) {
      _wrongMsg = '还没有选择衣服类别';
    } else if (_color == null) {
      _wrongMsg = '还没有选择衣服颜色';
    } else if (_price == null) {
      _wrongMsg = '还没有输入金额';
    } else {
      final newClothes = ClothesInfo(
          type: _type, color: _color, price: _price,
          hasPay: false
      );
      addCallback(newClothes);
      Navigator.pop(context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: ScreenInfo.width - 40,
//          height: 400,
//          height: ScreenInfo.height - ScreenInfo.topPadding(context) - 40,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              )
          ),
          child: ListView(
            children: [Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('添加衣服信息', style: Styles.normalFont(20, Colors.black)),
                    Container(
                      width: 30,
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Icon(Icons.close), onPressed: () {Navigator.pop(context);}),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButton(
                    hint: Text('衣服种类'),
                    value: _type,
                    items: _clothesTypesItem(),
                    onChanged: (item) {
                      _type = item;
                      setState(() {});
                    }),
                DropdownButton(
                  hint: Text('衣服颜色'),
                  value: _color,
                  items: _clothesColorsItem(),
                  onChanged: (item) {
                    _color = item;
                    setState(() {});
                  },
                ),
                TextField(
                  controller: _priceInput,
                  decoration: InputDecoration(
                    labelText: '输入金额'
                  ),
                  style: Styles.normalFont(30, Colors.red),
                ),
                const SizedBox(height: 20),
                Text(_wrongMsg ?? "  ", style: Styles.normalFont(16, Colors.red)),
                const SizedBox(height: 5),
                Container(
                  width: ScreenInfo.width - 80,
                  child: CommonBigButton(title: '确定', onPressed: _clickConfirm),
                )
              ],
            )],
          ),
        ),
      ),
    );
  }
  // 所有衣服种类
  List<DropdownMenuItem<ClothesType>> _clothesTypesItem() {
    return ClothesType.values.map( (type) =>
        DropdownMenuItem(child: Text(ClothesInfo.typeToString(type)), value: type)).toList();
  }
  // 所有备选颜色
  List<DropdownMenuItem<String>> _clothesColorsItem() {
    return ClothesInfo.allSelectColors().map((color) =>
        DropdownMenuItem(child: Text(color), value: color)).toList();
  }
}

typedef AddClothesCallback = void Function(ClothesInfo info);

class AddNewClothesDialog extends Dialog {
  AddClothesCallback addCallback;

  AddNewClothesDialog(AddClothesCallback addCallback) {
    this.addCallback = addCallback;
  }
  show(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext text) {
          return this;
        }
    );
  }
  // 点击空白处
  _clickEmptyArea(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return _AddNewClothesWidget(addCallback);
  }
}

class LoadingDialog extends Dialog {
  static LoadingDialog shared = LoadingDialog();
  static show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext text) {
          return shared;
        }
    );
  }
  
  static hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 80, height: 80,
          padding: EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))
            )
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class TextDialog extends Dialog {
  show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext text) {
          return this;
        }
    );
    Future.delayed(const Duration(seconds: 2), () {
      hide(context);
      dismissed();
    });
  }

  hide(BuildContext context) {
    Navigator.pop(context);
  }

  String text;
  VoidCallback dismissed = () {};
  TextDialog({String text, VoidCallback dismissed }) {
    this.text = text;
    this.dismissed = dismissed;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              )
          ),
          child: Text(text, style: Styles.normalFont(17, Colors.black)),
        ),
      ),
    );
  }
}

class CommonAlert extends Dialog {

  String title;
  String leftTitle;
  String rightTitle;
  VoidCallback rightClick;

  show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext text) {
        return this;
      }
    );
  }
  
  CommonAlert({String title, String leftTitle = '取消', String rightTitle, VoidCallback rightClick}) {
    this.title = title;
    this.leftTitle = leftTitle;
    this.rightTitle = rightTitle;
    this.rightClick = rightClick;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        heightFactor: 1.0,
        child: Container(
          height: 150,
          margin: EdgeInsets.only(left: 30, right: 30),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
            )
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Container(
                height: 20,
                  child: Text(title, style: Styles.normalFont(18, MyColors.black33))
              ),
              const SizedBox(height: 40),
              Divider(height: 1, color: MyColors.grayCCC),
              Row(
                children: <Widget>[
                  Container(
                    height: 48,
                    width: (ScreenInfo.width - 60 - 1) / 2,
                    child: FlatButton(
                      child: Text(leftTitle),
                      textColor: MyColors.subject,
                      onPressed: (){ Navigator.pop(context); },
                    ),
                  ),
                  Container(
                    color: MyColors.grayCCC,
                    width: 0.5, height: 48
                  ),
                  Container(
                    height: 48,
                    width: (ScreenInfo.width - 60 - 1) / 2,
                    child: FlatButton(
                      child: Text(rightTitle),
                      textColor: MyColors.subject,
                      onPressed: (){
                          rightClick();
                          Navigator.pop(context);
                        },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

