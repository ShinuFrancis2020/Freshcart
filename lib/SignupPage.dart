import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class SignupPage extends StatefulWidget {
  @override
  _SignupPage createState() => _SignupPage();
}
class _SignupPage extends State<SignupPage>  {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var email,password,username,ph,name;
  bool _showPassword = false;
  void initState() {
    super.initState();
    //_getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
                'Signup',
               ),
            elevation:0.0,
            //automaticallyImplyLeading: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              color:Colors.black12,
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
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Image(image: AssetImage('assets/userlogo.jpg'),height:100),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter username';
                            }
                            Pattern pattern =r'^[a-zA-Z]';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Invalid Username';
                            else
                              return null;
                          },
                          onSaved:(v){
                            username=v;
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                        SizedBox(
                          height:5
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter name';
                            }
                            Pattern pattern =r'^[a-zA-Z]';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Invalid name';
                            else
                              return null;
                          },
                          onSaved:(v){
                            name=v;
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        SizedBox(
                          height:5
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }
                            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Invalid Email';
                            else
                              return null;
                          },
                          onSaved:(v){
                            email=v;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(
                            height:5
                        ),
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
                          onSaved:(v){
                            ph=v;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                          ),
                        ),
                        SizedBox(
                            height:5
                        ),
                        TextFormField(

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            Pattern pattern =  r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Invalid password,Password must contain at least one letter, at least one number, and be longer than six charaters';
                            else
                              return null;
                          },
                          onSaved:(v){
                            password=v;
                          },
                          obscureText: !this._showPassword,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showPassword ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._showPassword = !this._showPassword);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height:50,
                          width:50,
                        ),
                        FlatButton(
                          height:50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Sign up'),
                          onPressed: () {
                           // if (_formKey.currentState.validate()) {
                              //_formKey.currentState.save();
                              senddata();
                            //}
                          },
                        ),
                      ],
                    ) )),
          )),
    );

  }
  // _getCurrentLocation() {
  //   final Geolocator geolocator = Geolocator()
  //     ..forceAndroidLocationManager;
  //
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //       lat=_currentPosition.latitude;
  //       log=_currentPosition.longitude;
  //       print("latitude:$lat");
  //       print("longitude:$log");
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  Position _currentPosition;
  var lat,log;
  void senddata() async {
    try{
      var url = 'http://13.234.186.200/register';
      Map data={
        "rid":"5d83345ad52f3524f824f1ff",
        "username":username,
        "password":password,
        "ph":ph,
        "email":email,
        "usertype":"0",
        "lat":lat.toString(),
        "lon":log.toString()};

      print(data.toString());
      var response = await http.post(url,body:data);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        if(json.decode(response.body)['status'])
        {
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
         // Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new LoginSample()));
        }
        else{
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
  }
}