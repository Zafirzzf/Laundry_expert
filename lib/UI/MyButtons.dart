
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'Styles.dart';
import 'MyColors.dart';

class CommonBigButton extends StatelessWidget {
  String title;
  VoidCallback onPressed;
  bool enabled = true;
  Color backColor;
  CommonBigButton({ String title, VoidCallback onPressed, Color backColor = Colors.blue, bool enabled = true }) {
    this.title = title;
    this.backColor = backColor;
    this.onPressed = onPressed;
    this.enabled = enabled;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: backColor,
        disabledColor: MyColors.grayEAEA,
        disabledTextColor: MyColors.gray999,
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(title, style: Styles.normalFont(16, enabled ? Colors.white : MyColors.grayBBB))
    );
  }
}

class MySegement extends StatefulWidget {
  final List<String> itemsTitles;
  final IntCallback indexClick;
  MySegement({this.itemsTitles, this.indexClick});
  @override
  _MySegementState createState() => _MySegementState();
}

class _MySegementState extends State<MySegement> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buttonItems(),
    );
  }
  
  List<Widget> _buttonItems() {
    List<Widget> tmpItmes = [];
    for (var i = 0; i < widget.itemsTitles.length; i++) {
      final title = widget.itemsTitles[i];
      final item = _segementItem(title, _currentIndex == i, () {
        widget.indexClick(i);
        _currentIndex = i;
        setState(() {});
      });
      tmpItmes.add(item);
      tmpItmes.add(SizedBox(width: 1));
    }
    return tmpItmes;
  }

  Widget _segementItem(String title, bool isSelect, VoidCallback pressed) {
    return Container(
      width: 80, height: 30,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue,
              width: 1
          ),
          borderRadius: BorderRadius.circular(2),
          gradient: RadialGradient(
              colors: isSelect ? [Colors.blue, Colors.blueAccent] : [Colors.white, Colors.white24],
              radius: 0.4
          )
      ),
      child: FlatButton(
          onPressed: pressed,
          child: Text(title, style: Styles.normalFont(16, isSelect ? Colors.white : Colors.black87),)
      ),
    );
  }
}


