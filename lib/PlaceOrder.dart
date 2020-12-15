import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/ConfirmOrder.dart';
import 'package:freshcart_app/DeliveryaddressOrder.dart';
import 'package:freshcart_app/DeliveyAddress.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class PlaceOrder extends StatefulWidget
{
  final pid,unit;
  PlaceOrder(this.pid,this.unit);
  @override
  _PlaceOrder  createState() =>_PlaceOrder ();
}
class _PlaceOrder extends State <PlaceOrder> {
  @override
  void initState() {
    super.initState();
    profile();
  }
  var a;
 List<bool> checkValue=[];
  var listprofile;
  bool progress=true;
  List deliverylength=[];
  var state,city,fulladdress,lat,lon;
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
      for(int i=0;i<deliverylength.length;i++) {
        checkValue.add(false);
        print(deliverylength);

      }
      print(json.decode(response.body));
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController quantity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation:0.0,
        title: Text("Place Order"),

      ),
      body:SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: progress?Center(child: CircularProgressIndicator(),):
            listprofile['deliveryaddress'].isEmpty?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:[
                  SizedBox(
                    height:20,
                  ),
                  FlatButton(
                    height: 50,
                    minWidth:MediaQuery.of(context).size.width /1,
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text('Add Delivery Address'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        Navigator.push(context,new MaterialPageRoute(builder: (context)=>new DeliveryaddressOrder(widget.pid,widget.unit)));
                      }
                    },
                  ),
                  SizedBox(
                    height:20
                  ),
                  Center(child: Text("Delivery address is not added",style:TextStyle(fontWeight: FontWeight.bold)))
                ]
              ),
            )
                  :Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height:20
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            else{
                              return null;
                            }

                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          controller: quantity,
                          decoration: InputDecoration(
                            labelText: 'Quantity:'+widget.unit,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                            height:20
                        ),
                        Row(
                          children: [
                            Text("Delivery  Addresses",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                          ],
                        ),
                    SizedBox(
                        height:10
                    ),
                    Container(
                     //height:MediaQuery.of(context).size.height,
                      height: 300,
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
                                        new Checkbox(
                                            value: a==listprofile['deliveryaddress'][index]['_id']?true:false,
                                          //value:checkValue[index],
                                            activeColor: Colors.green,
                                            onChanged:(bool newValue){
                                              fulladdress=listprofile['deliveryaddress'][index]['fulladdress'];
                                              state=listprofile['deliveryaddress'][index]['state'];
                                              city=listprofile['deliveryaddress'][index]['city'];
                                              lon=listprofile['deliveryaddress'][index]['location'][0];
                                              lat=listprofile['deliveryaddress'][index]['location'][1];
                                              setState(() {
                                                //checkValue[index] = newValue;
                                                a=listprofile['deliveryaddress'][index]['_id'];
                                                senddata1();
                                              });
                                            },
                                            ),
                                        Text("Select delivery address"),
                                      ],
                                    ),

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
                                  ],
                                ),
                              ),
                            );

                          }),
                    ),
                        SizedBox(
                            height:20
                        ),
                        FlatButton(
                          height: 50,
                          minWidth:MediaQuery.of(context).size.width /1,
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Place Order'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if(a!=null)
                                senddata();
                              else
                              Fluttertoast.showToast(
                                msg:"Please select delivery address",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,

                              );
                            }
                          },
                        ),
                    ]),
                  ),
          ),
        ),
      ),
    );
  }
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/Purchase/Request';
      var token=await Prefmanager.getToken();
      Map data={
        'x-auth-token': token,
        'product':widget.pid,
        'quantity':quantity.text,
        'state':state,
        'city':city,
        'fulladdress':fulladdress,
        'lat': lat,
        'lon': lon,
      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","x-auth-token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new ConfirmOrder()));
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
  void senddata1() async {
    try{
      var url = Prefmanager.baseurl+'/Purchase/checkrequest';
      var token=await Prefmanager.getToken();
      Map data={
        'x-auth-token': token,
        'product':widget.pid,
        'city':city,
      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","x-auth-token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
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

