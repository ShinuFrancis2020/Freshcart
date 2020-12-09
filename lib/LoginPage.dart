import 'dart:convert';
import 'dart:io';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phone = TextEditingController();
  var username;
  var password;
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title:Text("Login"),
            elevation: 0.0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.black12,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          body: SafeArea(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regex = new RegExp(pattern);
                            if (value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            else if (!regex.hasMatch(value))
                              return 'Invalid Mobilenumber';
                            else
                              return null;
                          },
                          controller: phone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                        ),
                        FlatButton(
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Log in'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              senddata();
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Dont have an account?'),
                            FlatButton(
                              textColor: Colors.black,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) =>
                                //       Signup_Sample()),
                                //   //MaterialPageRoute(builder: (context) => DrawerDemo()),
                                // ); //signup screen
                              },
                            ),

                          ],

                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                //forgot password screen
                              },
                              textColor: Colors.green,
                              child: Text(' Forgot Password'),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      ],
                    ))),
          )),
    );
  }
  void senddata() async {
    try {
      var url = 'http://13.234.186.200/login';
      Map data = {
        "username": username,
        "password": password,
      };
      print(data.toString());
      var response = await http.post(url, body: data);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg: json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          await Prefmanager.setToken(json.decode(response.body)['token']);

          // Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new MyHomePage()));
          //profile();
        }
        else {
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg: json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch (e) {
      print(e.toString());
    }
    catch (e) {
      print(e.toString());
    }
  }

  // void profile() async {
  //   var url = 'http://13.234.186.200/user/me';
  //   var token = await Prefmanager.getToken();
  //   Map data = {
  //     "to": token,
  //   };
  //   var response = await http.post(url, body: data);
  //   print(json.decode(response.body));
  //   int userType= await Prefmanager.getUserType();
  //   if (json.decode(response.body)['status']) {
  //     if (userType == 0)
  //       Navigator.pushReplacement(
  //           context, new MaterialPageRoute(
  //           builder: (context) => new Homepage()));
  //     else
  //       Navigator.pushReplacement(
  //           context, new MaterialPageRoute(
  //           builder: (context) => new BussinessHome()));
  //   }
  //   else {
  //     print("Not completed");
  //     if(json.decode(response.body)["new"]){
  //       if(userType== 0  && json.decode(response.body)["level"] == 0){
  //         print("Customer level 0");
  //         Navigator.pushReplacement(context, new MaterialPageRoute(
  //             builder: (context) => new Completeprofileuser()));
  //       }
  //       else if(userType == 0  && json.decode(response.body)["level"] == 1){
  //         print("custiomer level 1");
  //         Navigator.pushReplacement(
  //             context, new MaterialPageRoute(builder: (context) => new Customerdp()));
  //       }
  //       else if(userType == 1  && json.decode(response.body)["level"] == 0){
  //         print("Business level 1");
  //         Navigator.pushReplacement(
  //             context, new MaterialPageRoute(builder: (context) => new Completeprofilebusiness()));
  //       }
  //       else if(userType == 1  && json.decode(response.body)["level"] == 1){
  //         print("Business level 1");
  //         Navigator.pushReplacement(
  //             context, new MaterialPageRoute(builder: (context) => new Bussinessdp()));
  //       }
  //       else{
  //         print("unmounted");
  //         Navigator.pushReplacement(
  //             context, new MaterialPageRoute(builder: (context) => new LicenseUpload()));
  //       }
  //     }
  //     else{
  //       print("not needs");
  //     }
  //   }
  // }
}






