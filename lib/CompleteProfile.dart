import 'dart:convert';
//import 'dart:io;
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class Completeprofileuser extends StatefulWidget {
  @override
  _Completeprofileuser createState() => _Completeprofileuser();
}
class _Completeprofileuser extends State<Completeprofileuser> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var  name,address,city,pincode;
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title:Text("Complete Profile"),
            elevation:0.0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              color:Colors.black12,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
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
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter city';
                          }
                          Pattern pattern = r'^[a-zA-Z]';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Invalid City';
                          else
                            return null;
                        },
                        onSaved:(v){
                          city=v;
                        },
                        decoration: InputDecoration(
                          labelText: 'City',
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          //Pattern pattern = r'^[a-zA-Z]';
                          //RegExp regex = new RegExp(pattern);
                          if (value.isEmpty) {
                            return 'Please enter pincode';
                            //return ph;
                          }
                          // else if (!regex.hasMatch(value))
                          //   return 'Invalid Pincode';
                          // else
                          //   return null;
                        },
                        onSaved:(v){
                          pincode=v;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'PIN Code',
                        ),
                      ),
                      SizedBox(
                        height:50,
                        width:50,
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            //senddata();
                          }
                        },
                      ),
                    ],
                  ) ))),
    );
  }
  // void senddata() async {
  //   try{
  //     var url = 'http://13.234.186.200/user/customer';
  //     var token=await Prefmanager.getToken();
  //     // Map data={
  //     //   "firstname":firstname,
  //     //   "lastname":lastname,
  //     //   "nationality":nationality,
  //     //   "to":token,
  //     // };
  //     print(data.toString());
  //     var response = await http.post(url,body:data);
  //     print("yyu"+response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       print(json.decode(response.body));
  //       if(json.decode(response.body)['status'])
  //       {
  //         Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new Customerdp()));
  //       }
  //       else{
  //         print(json.decode(response.body)['message']);
  //         Fluttertoast.showToast(
  //           msg:json.decode(response.body)['message'],
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       }
  //     }
  //     else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   }
  //   on SocketException catch(e){
  //     print(e.toString());
  //   }
  //   catch(e){
  //     print(e.toString());
  //   }
  // }
}
