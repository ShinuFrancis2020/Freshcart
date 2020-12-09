import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshcart_app/HomePage.dart';
import 'package:freshcart_app/PhoneVerify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/ViewProduct.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color:Colors.green,
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.bold),
          ),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        primarySwatch: Colors.green,
        cursorColor: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
          () => direct(),
    );
    //direct();
  }

  var token;

  void direct() async {
    var token = await Prefmanager.getToken();
    if (token != null)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              HomePage()
          ));
    else
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              LoginScreen()
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //child:FlutterLogo(size:MediaQuery.of(context).size.height)
      child:Image(image:AssetImage('assets/freshcartlogo.png'),width:50,height:50),

    );
  }
}
  class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Future<bool> _willPopCallback() async {
    exit(0);
    return true; // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    return  new WillPopScope(
      onWillPop: _willPopCallback,
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
              child: //progress?Center( child: CircularProgressIndicator(),):
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children:[
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
                    height:30,
                  ),
                    TextFormField(
                      validator: (value) {

                        if (value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        else{
                          return null;
                        }

                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                        height:20
                    ),
                    FlatButton(
                      height: 50,
                      minWidth:MediaQuery.of(context).size.width /1,
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Signin'),
                      onPressed: () {
                     if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                        Navigator.push(
                            context, new MaterialPageRoute(
                            builder: (context) => new PhoneVerify(phone: phoneController.text,)));
                      }
                      },
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
}

