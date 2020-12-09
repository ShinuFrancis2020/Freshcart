import 'dart:convert';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class NetWorkCalls{
  static Future<http.Response> getRequest(url) async{
    http.Response response = await http.get(Prefmanager.baseurl + url);
    return response;
  }

  static Future<http.Response> postRequest(url,{Map sendData}) async{

    String token  = await Prefmanager.getToken();
    Map data  = {
      'to' : token
    };
    if(sendData.isNotEmpty){
      data.addAll(sendData);
    }
    var body = json.encode(data);
    var response = await http.post(Prefmanager.baseurl + url,headers: {"Content-Type":"application/json"},
        body: body);

    return response;

  }
}