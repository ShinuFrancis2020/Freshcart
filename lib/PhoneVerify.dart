import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/HomePage.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
class PhoneVerify extends StatefulWidget
{
  final phone;
  PhoneVerify({this.phone});
  @override
  _PhoneVerify  createState() =>_PhoneVerify ();
}
class _PhoneVerify  extends State <PhoneVerify > {
  var verId, smsCode;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    check();
    verifyPhone();

    _getCurrentLocation();

  }
  bool progress=true;
  bool prog=false;
  bool isnew=false;

  // --- cHECK pHONE exixt
  void check() async{
    print("jhgj");
      var url=Prefmanager.baseurl+'/user/check/phone';
      Map data={
        "phone":widget.phone,
        "role":"User"
      };
      var response = await http.post(url,body:data);
      isnew=json.decode(response.body)['status'];
      print(isnew);
      progress=false;
      setState(() {});
  }


  signIn(BuildContext context) async {
    setState(() {
      prog=true;
    });
    print("In SignIN");
    try {

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode :smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print(user.getIdToken());

      var idToken = await user.getIdToken();
      if(idToken!=null){
        var url = Prefmanager.baseurl+'/user/signupcustomer';
      Map data= {
        "token":idToken,
        "email":email.text,
        "phone":widget.phone,
        "name":name.text,
        "lat":lat.toString(),
        "lon":lon.toString(),
        "city":city.text,
        "state":state.text,
        "locationname":location.text,

      };
      print(data.toString());
        print(idToken);
      var response = await http.post(url,body:data);
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          //print(json.decode(response.body)['msg']);
          await Prefmanager.setToken(json.decode(response.body)['signindata']['token']);
          prog=false;
          ViewData();
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new HomePage()));
        }
    }} catch (e) {
      print(e.toString());
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    setState(() {
     // buttonLoading = false;
    });
  }



// InitState
  Future<void> verifyPhone() async {
    // setState(() {
    //   startTimer();
    // });
    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      this.verId = verificationId;
      print(verId);
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91 "+widget.phone,
        timeout: const Duration(seconds: 112),
        verificationCompleted: (AuthCredential phoneAuthCredential) async{},
        verificationFailed:   (FirebaseAuthException e){
          print("${e.message}");
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout:  (String verId) {
          this.verId = verId;
        },);
    } catch (e) {
      print(e.toString());
    }

  }
  Timer _timer;
  int _start = 120;
  String sendPin;

  void startTimer() {
    _start = 110;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start == 0) {
            timer.cancel();
            Fluttertoast.showToast(
                msg: "Sorry OTP Expires!", backgroundColor: Colors.black);
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        //_currentPosition = position;
        lat = position.latitude;
        lon = position.longitude;
        print("latitude:$lat");
        print("longitude:$lon");
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

    _getAddressFromLatLng() async {
      try {
        print("Addresss...");
        final coordinates = new Coordinates(lat,lon);
        print(coordinates);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print(addresses.first.addressLine);
        state.text=first.adminArea;
        city.text=first.locality;
        location.text=first.featureName;
        //print("${first.adminArea} : ${first.}");
        print(state.text);
        print(location.text);
        print(city.text);
         //print("${first.featureName} : ${first.state}");
        // setState(() {
        //   _currentAddress =
        //   "${addresses.first.locality}, ${addresses.first.name}, ${addresses.first.administrativeArea}";
        //   city=addresses.first.name;
        //   state=addresses.first.administrativeArea;
        //   locationname=addresses.first.locality;
        //   print(city);print(state);print(locationname);
        // });
      } catch (e) {
        print(e);
      }
    }
  Position _currentPosition;
  var lat,lon;
  String _currentAddress;
  Widget build(BuildContext context) {
    return  new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation:0.0,
          title: Text("FreshCart"),
          automaticallyImplyLeading: false,
        ),
      body:SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: progress?Center( child: CircularProgressIndicator(),):
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [

                  !isnew?
                  Column(
                    children: [
                      Row(
                          children:[
                            Text("Sign In",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          ]
                      ),
                      SizedBox(
                        height:5,
                      ),
                      Row(
                          children:[Text("Sign in to access your Orders."),
                          ]
                      ),
                      SizedBox(
                        height:50,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[Text("Please enter verification code"),
                          ]
                      ),
                      SizedBox(
                        height:5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[Text("sent on given number"),
                          ]
                      ),
                      SizedBox(
                        height:50,
                      ),
                      Expanded(flex:0,
                        child: OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          //fieldWidth: 80,
                          // style: TextStyle(
                          //     fontSize: 14
                          // ),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.underline,
                          onCompleted: (pin) {
                            smsCode = pin;
                            print("Completed: " + pin);
                          },
                        ),
                      ),
                      SizedBox(
                          height:20
                      ),
                      prog?Center( child: CircularProgressIndicator(),):
                      FlatButton(
                        height: 50,
                        minWidth:MediaQuery.of(context).size.width /1,
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Verify'),
                        onPressed: () {
                          signIn(context);
                        },
                      ),
                    ],
                  )

                  :Column(
                    children: [
                      Row(
                          children:[
                            Text("Sign Up",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          ]
                      ),
                      SizedBox(
                        height:5,
                      ),
                      Row(
                          children:[Text("Sign up to access your Orders."),
                          ]
                      ),
                      SizedBox(
                        height:30,
                      ),

                      TextFormField(
                        validator: (value) {

                          if (value.isEmpty) {
                            return 'Please enter name';
                          }
                          else{
                            return null;
                          }

                        },
                        controller: name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                          height:10
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
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                          height:20
                      ),
                      Row(
                          children:[
                            Text("Verify",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          ]
                      ),
                      SizedBox(
                        height:10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[Text("Please enter verification code"),
                          ]
                      ),
                      SizedBox(
                        height:5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[Text("sent on given number"),
                          ]
                      ),
                      SizedBox(
                        height:20,
                      ),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter verification code';
                      //     }
                      //     else
                      //       return null;
                      //   },
                      //   controller: _controller,
                      //   decoration: InputDecoration(
                      //     labelText: 'Enter Verification Code',
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      Expanded(flex:0,
                        child: OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          //fieldWidth: 80,
                          // style: TextStyle(
                          //     fontSize: 14
                          // ),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.underline,
                          onCompleted: (pin) {
                            smsCode = pin;
                            print("Completed: " + pin);
                          },
                        ),
                      ),
                      SizedBox(
                          height:30
                      ),
                      prog?Center( child: CircularProgressIndicator(),):
                      FlatButton(
                        height: 50,
                        minWidth:MediaQuery.of(context).size.width /1,
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Verify'),
                        onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  signIn(context);
                }
                        },
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ),
        ),
      ),
      ),
    );
  }
  var mycity;
  void ViewData() async {
    var url = Prefmanager.baseurl +'/location/getcity?city='+city.text;
    var token = await Prefmanager.getToken();
    Map data={
      "x-auth-token":token,
    };
    print("ggg"+city.text);
     print(token);
    //print(data.toString());
    //var body =json.encode(data);
    var response = await http.get(url, headers:{"Content-Type":"application/json", "x-auth-token":token});
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      mycity=json.decode(response.body)['data']['_id'];
      MyData();
    }
    else {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
    }

  }
  void MyData() async {
    var url = Prefmanager.baseurl +'/user/Edit';
    var token = await Prefmanager.getToken();
    Map data={
      "x-auth-token":token,
      "currentcity":mycity
    };
    //print("ggg"+current);
    // print(token);
    //print(data.toString());
    var body =json.encode(data);
    var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      Navigator.push(context,new MaterialPageRoute(builder: (context)=>new HomePage()));

    }
    else {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
    }

  }
  }