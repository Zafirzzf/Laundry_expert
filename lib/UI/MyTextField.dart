
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'Styles.dart';
import 'MyColors.dart';

class MyTextField extends StatefulWidget {
  final TextStyle style;
  final String labelText;
  final Widget icon;
  final bool autofocus;
  final Color cursorColor;
  final TextInputType keyboardType;
  final TextEditingController controller;
  MyTextField({
    this.style,
    this.labelText,
    this.icon,
    this.autofocus,
    this.cursorColor,
    this.keyboardType,
    this.controller});
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus ?? false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        icon: widget.icon,
        suffixIcon: widget.controller.text.isNotEmpty ?
            IconButton(iconSize: 20, icon: Icon(Icons.clear), onPressed: () => widget.controller.clear()) :
            null
      ),
      cursorColor: widget.cursorColor,
      style: widget.style,
      onChanged: (text) {
        setState(() {});
      },
    );
  }
}
