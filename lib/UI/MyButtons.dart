
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

class CommonRedButton extends StatelessWidget {
  String title;
  VoidCallback onPressed;
  bool enabled = true;
  CommonRedButton({ String title, VoidCallback onPressed, bool enabled = true }) {
    this.title = title;
    this.onPressed = onPressed;
    this.enabled = enabled;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: MyColors.subject,
        disabledColor: MyColors.grayEAEA,
        disabledTextColor: MyColors.gray999,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(2))
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(title, style: Styles.normalFont(16, enabled ? Colors.white : MyColors.grayBBB))
    );
  }
}
