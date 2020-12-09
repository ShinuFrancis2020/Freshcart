import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/ViewProfile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Homepage.dart';
import 'package:geolocator/geolocator.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}
class _EditProfile extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
   // _getCurrentLocation();
    profile();
  }
  var listprofile;
  bool progress=true;
  void profile() async{
    var url=Prefmanager.baseurl+'/user/profile';
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };

    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if(json.decode(response.body)['status'])
    {
      listprofile=json.decode(response.body)['data'];
      print(listprofile);
      nameController.text=listprofile['name'];
      emailController.text=listprofile['email'];
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation:0.0,
          // leading: new IconButton(
          //     icon: new Icon(Icons.arrow_back),
          //     onPressed: () {
          //       //Navigator.of(context).pop();
          //       Navigator.push(
          //           context, new MaterialPageRoute(
          //           builder: (context) => new ViewProfile()));
          //     }
          // ),
          title: Text(
            'Edit Profile',
          ),
        ),
        body: progress?Center(child:CircularProgressIndicator(),):
        Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment:Alignment.topCenter,
                      padding: new EdgeInsets.all(30.0),
                      //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:Stack(
                        children: [
                           CircleAvatar(

                            radius: 60.0,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/userlogo.jpg')

                          ),
                        ],
                      ) ,
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

                      controller: nameController,
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height:10,
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
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height:30,
                    ),
                    Container(
                        height: 50,
                        width:80,
                        padding:EdgeInsets.symmetric(vertical:2,horizontal: 2),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Update'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              senddata();
                              //addSinglePhoto();
                            }
                          },
                        )),
                  ],
                ) )));
  }
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/user/Edit';
      var token=await Prefmanager.getToken();
      Map data={
        "name":nameController.text,
        "email":emailController.text,
        'x-auth-token': token,
      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","x-auth-token":token},body:body);

      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new ViewProfile()));
        }

        else{
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(

            msg:json.decode(response.body)['msg'],
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
