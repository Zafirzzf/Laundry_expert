
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:laundry_expert/Model/ShopInfo.dart';

typedef MapCallback = void Function(Map<String, dynamic> map);
typedef StringCallback = void Function(String str);

class RequestManager {
  static final Client client = Client();
  static final host = "http://192.168.1.6:8080/LeFlyHome/laundry/";
  static post({
      String urlPath, Map<String, String> parame,
      MapCallback dataCallback,
      StringCallback errorCallback
      }) async {
     parame['token'] = ShopInfo.shared.token;
     print('请求参数: $parame');
     await client.post(host + urlPath, body: parame).then((response) {
       if (response.statusCode != 200) {
          // 服务请求出错
         print('服务器请求出错: ${response.statusCode}');
       } else {
         Map<String, dynamic> result = json.decode(response.body);
         print("请求回调: ${urlPath} ${result}");
         final ret = result['ret'];
         if (ret == "0") {
           dataCallback(result['data']);
         } else {
           errorCallback(result['ret']);
         }
       }
     });
  }
}