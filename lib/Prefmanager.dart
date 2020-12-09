
import 'package:shared_preferences/shared_preferences.dart';
class Prefmanager {
  static final baseurl="http://192.168.50.75:3300";
  static setToken (var token)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  static Future<String>  getToken ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clear()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  static setUserid (String id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', id);
  }
  static Future<String>  getUserid ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

}