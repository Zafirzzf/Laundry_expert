
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:laundry_expert/UI/Styles.dart';
import 'package:laundry_expert/UI/MyColors.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:laundry_expert/Tool/ScreenInfo.dart';
import 'package:laundry_expert/Model/ClothesInfo.dart';
import 'package:laundry_expert/Model/OrderInfo.dart';
import 'dart:async';

class _AddNewClothesWidget extends StatefulWidget {

  AddClothesCallback addCallback;
  ClothesInfo clothsInfo;
  _AddNewClothesWidget(this.clothsInfo, this.addCallback);
  @override
  _AddNewClothesWidgetState createState() => _AddNewClothesWidgetState();
}

class _AddNewClothesWidgetState extends State<_AddNewClothesWidget> {

  final _priceInput = TextEditingController();

  String _type;
  String _color;
  String _price;
  String _wrongMsg;

  _clickConfirm() {
    int price;
    try {
      price = int.parse(_priceInput.text);
      _price = price.toString();
    } catch (e) {
      setState(() {
        _wrongMsg = '金额格式输入有误';
      });
      return;
    }
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
      widget.addCallback(newClothes);
      Navigator.pop(context);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.clothsInfo != null) {
      _type = widget.clothsInfo.type;
      _color = widget.clothsInfo.color;
      _priceInput.text = widget.clothsInfo.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
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
                  keyboardType: TextInputType.number,
                  controller: _priceInput,
                  decoration: InputDecoration(
                    labelText: '输入金额'
                  ),
                  style: Styles.normalFont(30, Colors.red),
                ),
                const SizedBox(height: 20),
                Text(_wrongMsg ?? "  ", style: Styles.normalFont(16, Colors.red)),
                const SizedBox(height: 5),
                CommonBigButton(title: '确定', onPressed: _clickConfirm),
              ],
            )],
          ),
        ),
      ),
    );
  }
  // 所有衣服种类
  List<DropdownMenuItem<String>> _clothesTypesItem() {
    return ClothesInfo.allClothesTypes().map( (type) =>
        DropdownMenuItem(child: Text(type), value: type)).toList();
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
  ClothesInfo clothesInfo;
  AddNewClothesDialog(this.clothesInfo, this.addCallback);
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
    return _AddNewClothesWidget(clothesInfo, addCallback);
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
    Future.delayed(const Duration(seconds: 1), () {
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

class ChongzhiAlert extends Dialog {
  IntCallback moneyCallback;
  String _wrongHelpText;
  ChongzhiAlert(this.moneyCallback);
  final _inputController = TextEditingController();

  show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext text) {
          return this;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
          margin: EdgeInsets.all(20),
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0, right: 10, width: 30, height: 30,
                child: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ),
              Positioned(
                top: 30, left: 0, right: 30,
                child: TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.warning),
                    labelText: '充值金额',
                    helperText: _wrongHelpText
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 5, height: 40,
                child: CommonBigButton(title: '确定', onPressed: () {
                  try {
                    final money = int.parse(_inputController.text);
                    moneyCallback(money);
                    Navigator.pop(context);
                  } catch (e) {
                    BottomSheetDialog(text: '金额输入格式有误', context: context).show();
                  }
                }),
              )
            ],
          )
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
          margin: EdgeInsets.only(left: 30, right: 30),
          padding: EdgeInsets.fromLTRB(30, 20, 20, 0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 40),
              Container(
                  child: Text(title, style: Styles.normalFont(18, MyColors.black33))
              ),
              const SizedBox(height: 40),
              Divider(height: 1, color: MyColors.grayCCC),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 48,
                    child: FlatButton(
                      child: Text(leftTitle),
                      textColor: Colors.blue,
                      onPressed: (){ Navigator.pop(context); },
                    ),
                  ),
                  Container(
                    color: MyColors.grayCCC,
                    width: 0.5, height: 48
                  ),
                  Container(
                    height: 48,
                    child: FlatButton(
                      child: Text(rightTitle),
                      textColor: Colors.blue,
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

class EditDiscountDialog extends Dialog {
  show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext text) {
          return this;
        }
    );
  }
  final _inputController = TextEditingController();
  final IntCallback discountCallback;
  EditDiscountDialog(this.discountCallback);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
            margin: EdgeInsets.all(20),
            height: 170,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0, right: 10, width: 30, height: 30,
                  child: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ),
                Positioned(
                  top: 30, left: 0, right: 30,
                  child: TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        icon: Icon(Icons.warning),
                        labelText: '修改折扣额',
                    ),
                  ),
                ),
                Positioned(
                  left: 0, right: 0, bottom: 5, height: 40,
                  child: CommonBigButton(title: '确定', onPressed: () {
                    try {
                      final discount = int.parse(_inputController.text);
                      discountCallback(discount);
                      Navigator.pop(context);
                    } catch (e) {
                      BottomSheetDialog(text: '输入格式有误', context: context).show();
                    }
                  }),
                )
              ],
            )
        )
      ),
    );
  }
}

class BottomSheetDialog {
  String text;
  BuildContext context;
  BottomSheetDialog({this.text, this.context});

  show() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 24
            ),
          ),
        ),
      );
    });
  }
}
