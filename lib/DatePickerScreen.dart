
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:laundry_expert/Request/APIs.dart';
import 'package:laundry_expert/UI/Dialogs.dart';
import 'package:laundry_expert/UI/MyButtons.dart';
import 'package:intl/intl.dart';

class DatePickerScreen extends StatefulWidget {
  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  _clickSearch() {

  }

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('按条件查找订单')),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return ListView(
      children: <Widget>[
        _DateTimePicker(
          labelText: '起始时间',
          selectedDate: _fromDate,
          selectDate: (date) {
            setState(() {
              _fromDate = date;
            });
          },
        ),
        const SizedBox(height: 30),
        _DateTimePicker(
          labelText: '截止时间',
          selectedDate: _fromDate,
          selectDate: (date) {
            setState(() {
              _toDate = date;
            });
          },
        ),
        CommonBigButton(title: '查询', onPressed: _clickSearch)
      ],
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        locale: Localizations.localeOf(context),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd('zh').format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}
class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}