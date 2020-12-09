import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshcart_app/HomePage.dart';
import 'package:freshcart_app/MyCart.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;
class ConfirmOrder extends StatefulWidget
{
  @override
  _ConfirmOrder createState() =>_ConfirmOrder();
}
class _ConfirmOrder extends State <ConfirmOrder> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation:0.0,
          title: Text("Confirm Order"),
   automaticallyImplyLeading: false,
        ),
        body:SafeArea(
          child: SingleChildScrollView(
              child: //progress?Center( child: CircularProgressIndicator(),):
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                Image(image: AssetImage('assets/orderconfirm.png'),height:300,width: double.infinity,fit:BoxFit.fill),
                  SizedBox(
                    height:20,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children:[Text("Your Order has been",style:TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                        ]
                    ),
                    SizedBox(
                      height:5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[Text("placed successfully !! ",style:TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                        ]
                    ),
                    SizedBox(
                      height:10,
                    ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children:[
                    //       Text("You can check your order process in my"),
                    //     ]
                    // ),
                    // SizedBox(
                    //   height:5,
                    // ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children:[Text("orders section."),
                    //     ]
                    // ),
                    // FlatButton(
                    //   textColor: Colors.green,
                    //   child: Text(
                    //     'My Orders',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) =>
                    //           MyOrders()),
                    //     ); //signup screen
                    //   },
                    // ),
                    SizedBox(
                      height:50
                    ),
                    FlatButton(
                      height: 50,
                      minWidth:MediaQuery.of(context).size.width /0,
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Continue Shopping'),
                      onPressed: () {
                        Navigator.push(
                            context, new MaterialPageRoute(
                            builder: (context) => new HomePage()));
                      },
                    ),
                  ],
                ),
              ),

          ),
        ),
      ),
    );
  }
}
