
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class RequestManager {
  static final Client client = Client();
  
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> parame) async {
    final res = await client.post(url, body: parame);
    if (res.statusCode != 200) {

    } else {
      Map<String, dynamic> result = json.decode(res.body);
      return result;
    }
  }
}