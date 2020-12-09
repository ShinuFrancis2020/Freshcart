import 'dart:convert';
import 'package:freshcart_app/AdddeliveryAddress.dart';
import 'package:freshcart_app/DeliveyAddress.dart';
import 'package:freshcart_app/MyCart.dart';
import 'package:freshcart_app/main.dart';
import 'package:flutter/material.dart';
import 'package:freshcart_app/EditProfile.dart';
import 'package:freshcart_app/HomePage.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
class ViewProfile extends StatefulWidget {
  @override
  _ViewProfile createState() => new _ViewProfile();
}

//State is information of the application that can change over time or when some actions are taken.
class _ViewProfile extends State<ViewProfile>{
  void initState(){
    super.initState();
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
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
             title: new Text('My Profile'),
          //    iconTheme: IconThemeData(
          //        color:Colors.black,
          //
          //    ),
          elevation:0.0,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: IconButton(icon: Icon(Icons.home),color:Colors.white,onPressed:(){
                Navigator.push(
                    context, new MaterialPageRoute(
                    builder: (context) => new HomePage()));

              },),

              ),
              Expanded(child: IconButton(icon: Icon(Icons.shopping_cart),color:Colors.white,onPressed:(){
                Navigator.pushReplacement(
                    context, new MaterialPageRoute(
                    builder: (context) => new MyOrders()));
              },),

              ),
              //Expanded(child: new Text('')),
              // Expanded(child: IconButton(icon: Icon(Icons.notifications),color:Colors.white,onPressed:(){
              //   // Navigator.push(
              //   //     context, new MaterialPageRoute(
              //   //     builder: (context) => new Notifications()));
              // },),
              //
              // ),
              Expanded(child: IconButton(icon: Icon(Icons.person),color:Colors.white,onPressed: (){
                Navigator.push(
                    context, new MaterialPageRoute(
                    builder: (context) => new ViewProfile()));
              },),),
            ],
          ),
        ),

        //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
        body: progress?Center(child:CircularProgressIndicator(),):
        Container(
            padding: new EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: new Column(
                    children: <Widget>[
                      new Card(
                        color:Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30.0)),
                        elevation: 4.0,


                        child: new Container(
                          child:new Column(
                            children: [
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: <Widget>[


                                  //)
                                ],
                              ),
                              // Container(
                              //   alignment:Alignment.topCenter,
                              //   padding: new EdgeInsets.all(30.0),
                              //   //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                              //
                              //
                              //   child:CircleAvatar(
                              //
                              //     radius: 50,
                              //     backgroundColor: Color(0xFFE3F2FD),
                              //       backgroundImage:listprofile['photo']!=null?NetworkImage(
                              //           Prefmanager.baseurl+"/u/"+listprofile["photo"])
                              //     //_image,
                              //     // width: 120,
                              //     // height: 120,
                              //     // fit: BoxFit.contain,
                              //   ) :CircleAvatar()
                              //
                              // ),
                              Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.bottomCenter,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.blue,
                                  backgroundImage:AssetImage('assets/userlogo.jpg'),

                                ),
                              ),


                              Text(listprofile['name'],style:TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                              // SizedBox(
                              //   height: 5,
                              // ),
                               Text(listprofile["phone"],style:TextStyle(color:Colors.white),),
                              Container(
                                width:180,
                                padding: new EdgeInsets.all(10.0),
                                child:RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: Colors.white)),

                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text('Edit Profile',style: TextStyle(fontSize: 10),),
                                  onPressed: () {
                                    Navigator.push(context,new MaterialPageRoute(builder: (context)=>new EditProfile()));

                                  },
                                ),
                              ),
                              // SizedBox(
                              //   height: 1,
                              // ),
                              // Container(
                              //   width:180,
                              //   padding: new EdgeInsets.all(10.0),
                              //   child:RaisedButton(
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(50.0),
                              //         side: BorderSide(color: Colors.white)),
                              //
                              //     textColor: Colors.white,
                              //     color: Colors.blue,
                              //     child: Text('Change Password',style: TextStyle(fontSize: 10),),
                              //     onPressed: () {
                              //       //Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new ChangePassword()));
                              //
                              //     },
                              //   ),
                              // ),
                              //color:Colors.blue,
                              //padding: new EdgeInsets.all(100.0),




                              //new Text('Hello World'),
                              //new Text('How are you?')
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30.0)),
                        elevation: 4.0,
                        child:new Column(
                          children: [
                            ListTile(
                                leading: Icon(Icons.place,color:Colors.black),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                //title: Text(titles[index]),
                                title: Text('Delivery Addresses'),
                                onTap: () {
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new AdddeliveryAddress()));
                                  //     //Navigator.pop(context);
                                }),

                            ListTile(
                                leading: Icon(Icons.help,color:Colors.black),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                //title: Text(titles[index]),
                                title: Text('Help & Supports'),
                                onTap: () {
                                  //     // Update the state of the app
                                  //     // ...
                                  //     // Then close the drawer
                                  //
                                  //     //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                                  //     //Navigator.pop(context);
                                }),
                            ListTile(
                                leading: Icon(Icons.person,color:Colors.black),

                                //title: Text(titles[index]),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                title: Text('Logout'),
                                onTap: () {
                                  //     // Update the state of the app
                                  //     // ...
                                  //     // Then close the drawer
                                  //
                                  Prefmanager.clear();
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginScreen ()));
                                }
                            ),
                          ],
                        ),


                        //             child: new Container(
                        //               padding: new EdgeInsets.all(130.0),
                        //               child: new Column(
                        //                 children: <Widget>[
                        //                   // ListView(
                        //                   //     children: <Widget>[
                        //                   //  ListTile(
                        //                   //   leading: Icon(Icons.person),
                        //                   //   title: Text('My Data'),
                        //                   //   onTap: () {
                        //                   //     // Update the state of the app
                        //                   //     // ...
                        //                   //     // Then close the drawer
                        //                   //
                        //                   //     //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                        //                   //     //Navigator.pop(context);
                        //                   //   },
                        //                   // ),
                        //                   // ]
                        //                   // ) ,
                        //                   // ListTile(
                        //                   //   leading: Icon(Icons.account_balance_wallet),
                        //                   //   title: Text('My Wallets'),
                        //                   //   onTap: () {
                        //                   //     // Update the state of the app
                        //                   //     // ...
                        //                   //     // Then close the drawer
                        //                   //
                        //                   //     //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                        //                   //     //Navigator.pop(context);
                        //                   //   },
                        //                   // ),
                        //                   // ListTile(
                        //                   //   leading: Icon(Icons.person),
                        //                   //   title: Text('Buy Coins'),
                        //                   //   onTap: () {
                        //                   //     // Update the state of the app
                        //                   //     // ...
                        //                   //     // Then close the drawer
                        //                   //
                        //                   //     //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                        //                   //     //Navigator.pop(context);
                        //                   //   },
                        //                   // ),
                        //                   // ListTile(
                        //                   //   leading: Icon(Icons.help),
                        //                   //   title: Text('Helps & Supports'),
                        //                   //   onTap: () {
                        //                   //     // Update the state of the app
                        //                   //     // ...
                        //                   //     // Then close the drawer
                        //                   //
                        //                   //     //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                        //                   //     //Navigator.pop(context);
                        //                   //   },
                        //                   // ),
                        //                   new Text('Hello World'),
                        //                   new Text('How are you?')
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),


                      )
                    ]
                )
            )
        )
    );
  }
}