
import 'package:flutter/material.dart';


class RefreshListView extends StatefulWidget {
  Widget Function(int index, Object data) itemConfig;

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

class _RefreshListViewState extends State<RefreshListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class LoadMoreBottomWidget extends StatelessWidget {

  bool isNoMoreData;
  bool isLoading;
  LoadMoreBottomWidget(this.isNoMoreData, this.isLoading);

  @override
  Widget build(BuildContext context) {
    return isNoMoreData ? Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('没有更多数据了'),
    )) : Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(width: 30),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }
}