import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/DeliveyAddress.dart';
import 'package:freshcart_app/EditDeliveryaddress.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class AdddeliveryAddress extends StatefulWidget
{
  @override
  _AdddeliveryAddress createState() =>_AdddeliveryAddress();
}
class _AdddeliveryAddress  extends State <AdddeliveryAddress> {
  @override
  void initState() {
    super.initState();
    profile();
  }
  var listprofile,delid;
  List deliverylength=[];
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
      deliverylength=listprofile['deliveryaddress'];
      print(deliverylength);
      for(int i=0;i<listprofile['deliveryaddress'].length;i++) {
        delid = listprofile['deliveryaddress'][i]['_id'];
        print(delid);
      }
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  void _showDialog(var id) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete this deliveryaddress",style: TextStyle(fontSize: 16),),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                deleteDeliveryadd(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool pro=true;
  void  deleteDeliveryadd(var id) async {
    var url = Prefmanager.baseurl+'/deliveryaddress/remove';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      "id":id,
    };
    //print(data.toString());
    var body = json.encode(data);
    var response = await http.post(
        url, headers: {"Content-Type": "application/json","x-auth-token": token,},body:body);
    print(response.body);
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0
      );
      profile();
    }
    else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
      //progress=false;
      pro = false;
      setState(() {
        //deleterate();
      });

    }
  }
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation:0.0,
          title: Text("Delivery Address"),
        ),
        body: progress? SafeArea(child: SingleChildScrollView(child: Center(child: CircularProgressIndicator(),))):
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                SizedBox(
                  height:20
                ),
                FlatButton(
                  height: 50,
                  minWidth:MediaQuery.of(context).size.width /1,
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text('Add New Address'),
                  onPressed: () {
                    Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new DeliveryAddress()));
                  },
                ),
                SizedBox(
                    height:20
                ),
                  deliverylength.isEmpty?
                     Center(child: Text("Delivery address is not added",style:TextStyle(fontWeight: FontWeight.bold)))
                 : Expanded(
                   child: Container(
                     height:MediaQuery.of(context).size.height,
                      //height: 500,
                     child: ListView.builder(
    itemCount: deliverylength.length,
    itemBuilder: (BuildContext context,int index) {
      return Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

        // Column(
        //     children: deliveryAddress(context)
        // ),
        Row(
          children: [
            Text(listprofile['name'],style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
          ],
        ),
        SizedBox(
            height: 10
        ),
        Row(
          children: [

            Expanded(flex:1,child: Text(listprofile['deliveryaddress'][index]['fulladdress'],)),
          ],
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlatButton(
              textColor: Colors.green,
              child: Text(
                'Delete',textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _showDialog(listprofile['deliveryaddress'][index]['_id']);
              },
            ),
            Spacer(),
            SizedBox(
              width:80
            ),
            FlatButton(
              textColor: Colors.green,
              child: Text(
                'Modify',textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        EditDeliveryaddress(listprofile['deliveryaddress'][index]['_id'],listprofile['deliveryaddress'][index]['fulladdress'],listprofile['deliveryaddress'][index]['location'][1],listprofile['deliveryaddress'][index]['location'][0])),
                    //MaterialPageRoute(builder: (context) => DrawerDemo()),
                ); //signup screen
              },
            ),
          ],
        ),

        ],
        ),
        ),
      );

    }),
                   ),
                 ),
                SizedBox(
                    height:20
                ),

              ]
          ),
        )
    );
  }
  deliveryAddress(BuildContext context){
    List<Widget> item=[];
    for(int i=0;i<listprofile['deliveryaddress'].length;i++)
      item.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(padding:EdgeInsets.only(left:20)),
            Expanded(flex:1,child: Text(listprofile['deliveryaddress'][i]['fulladdress'],style: TextStyle(fontSize: 14),)),
            SizedBox(
              height: 30,
            ),
          ],
        ),

      );
    return item;
  }
}

