import 'dart:convert';
import 'package:freshcart_app/ApprovedOrder.dart';
import 'package:freshcart_app/DeliveredOrder.dart';
import 'package:freshcart_app/MyCart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class PendingOrder extends StatefulWidget
{
  @override
  _PendingOrder createState() =>_PendingOrder();
}
class _PendingOrder extends State <PendingOrder> {
  @override
  void initState() {
    super.initState();
    myOrders();
  }
  List orders=[];
  bool progress=true;
  int page=1,count=5;
  var len,status;
  var d=new DateFormat('dd-MM-yy');
  void myOrders() async{
    var url=Prefmanager.baseurl+'/Purchase/myorders?count='+count.toString()+'&page='+page.toString()+'&status='+'Pending';
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
    if(json.decode(response.body)['status']) {
      //orders=json.decode(response.body)['data'];
      //print(orders);

      len = json.decode(response.body)['count'];
      orders.clear();
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        orders.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else {
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    }
    progress=false;
    loading=false;
    setState(() {});
  }
  void _showDialog(var id) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Remove this order ",style: TextStyle(fontSize: 16),),
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
                deleteOrder(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool pro=true;
  void  deleteOrder(var id) async {
    var url = Prefmanager.baseurl+'/Purchase/delete?id='+id;
    var token = await Prefmanager.getToken();
    // Map data = {
    //   "x-auth-token": token,
    //   "id":id,
    // };
    // //print(data.toString());
    // var body = json.encode(data);
    var response = await http.get(
        url, headers: {"Content-Type": "application/json","x-auth-token": token,});
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
      setState(() {

        page=1;
      });
      await myOrders();
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
  bool loading=false;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(

        elevation:0.0,
        title: Text("My Orders"),
      ),
      body:SafeArea(
        child: progress?Center( child: CircularProgressIndicator(),):
            Column(
            children: [
              Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child:ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        child: Container(
                            alignment:Alignment.center,
                            width:MediaQuery.of(context).size.width/4,
                            child:Text("All",style:TextStyle(fontWeight:FontWeight.bold))
                        ),
                        onTap: () {
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (
                              context) => new MyOrders()));

                        },
                      ),
                      GestureDetector(
                        child: Container(
                            alignment:Alignment.center,
                            width:MediaQuery.of(context).size.width/4,
                            child:Text("Pending",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold))
                        ),
                        onTap: () {
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (
                              context) => new PendingOrder()));

                        },
                      ),
                      GestureDetector(
                          child: Container(
                              alignment:Alignment.center,
                              width:MediaQuery.of(context).size.width/4,
                              child:Text("Orders",style:TextStyle(fontWeight:FontWeight.bold))
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (
                                context) => new ApprovedOrder()));
                          }
                      ),
                      GestureDetector(
                        child: Container(
                            alignment:Alignment.center,
                            width:MediaQuery.of(context).size.width/4,
                            child:Text("Order History",style:TextStyle(fontWeight:FontWeight.bold))
                        ),
                        onTap: () {
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (
                              context) => new DeliveredOrder()));

                        },
                      )
                    ],
                  )
              ),
              orders.isEmpty?
              Center(child: Text("No order request found",style:TextStyle(fontWeight: FontWeight.bold)))
              :Expanded(child:NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    if(len>orders.length){
                      print(len);
                      print(orders.length);
                      myOrders();
                      setState(() {
                        loading = true;
                      });
                    }
                    else{}

                  }
                  else{}
                  //  setState(() =>loading = false);
                  return true;
                },
                child: Container(
                  height:MediaQuery.of(context).size.height,
                  //height:300,
                  child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context,int index){
                        return
                          Card(
                            elevation: 8.0,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),

                                    Expanded(
                                      child: new Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius:BorderRadius.circular(15.0),
                                              child:FadeInImage(
                                                // image:NetworkImage(
                                                //     Prefmanager.baseurl+"/document/get/"+profile[index]["icon"]) ,
                                                image: AssetImage('assets/fishimg1.jpg'),
                                                placeholder: AssetImage("assets/cloud.jpg"),
                                                fit: BoxFit.fill,
                                                width:70,
                                                height:70,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child:Column(
                                                children:[
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children:[
                                                      Text(orders[index]['product']['productname'],style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,)),
                                                      // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Quantity : "+orders[index]['quantity'].toString(),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:10
                                                  ),
                                                  //  Row(
                                                  //    children:[
                                                  //    Text(orders[index]['quantity'].toString(),style: TextStyle(fontSize:12,fontWeight: FontWeight.bold),),
                                                  // ]
                                                  //  ),
                                                  Row(
                                                    children: [
                                                      Text("Ordered on "+d.format(DateTime.parse(orders[index]['createddate'].toString())),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                                      // Spacer(),
                                                      SizedBox(
                                                        //width:70
                                                          width:MediaQuery.of(context).size.width/5
                                                      ),

                                                        FlatButton(
                                                          height: 30,
                                                          // minWidth:MediaQuery.of(context).size.width /0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              side: BorderSide(color: Colors.green)),
                                                          textColor: Colors.grey,
                                                          color: Colors.white,
                                                          child: Text('Remove'),
                                                          onPressed: () {
                                                            _showDialog(orders[index]['_id']);
                                                          },
                                                        ),
                                                    ],
                                                  ),


                                                  SizedBox(
                                                    height:5,
                                                  ),

                                                ]
                                            ),

                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    color:Colors.grey[50],
                                    padding:EdgeInsets.all(8.0),
                                    width:MediaQuery.of(context).size.width,
                                    //width:double.infinity,
                                    child:Row(
                                      children: [
                                        // Column(
                                        //   mainAxisAlignment:MainAxisAlignment.start,
                                        //     crossAxisAlignment:CrossAxisAlignment.start,
                                        //     children:[
                                        //       SizedBox(
                                        //           height:5
                                        //       ),
                                        //       Text("Quantity",style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                        //       SizedBox(
                                        //           height:10
                                        //       ),
                                        //       Text(orders[index]['quantity'].toString(),style: TextStyle(fontSize:12,fontWeight: FontWeight.bold),),
                                        //       SizedBox(
                                        //           height:10
                                        //       ),
                                        //
                                        //     ]),
                                        //   Spacer(),
                                        // SizedBox(
                                        //   width:80
                                        // ),
                                        Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          mainAxisAlignment:MainAxisAlignment.start,
                                          children: [
                                            Text("Order status",style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                            SizedBox(
                                                height:10
                                            ),

                                           // if(orders[index]['status']=='Pending')
                                              Text("Awaiting seller's approval",style: TextStyle(color:Colors.amber,fontSize:12,fontWeight: FontWeight.bold),),

                                          ],
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          );
                      }
                  ),
                ),
              ),
              ),

              Container(
                height: loading?20:0,
                width:double.infinity,
                child: Center(
                    child:CircularProgressIndicator()
                ),
              ),
            ]),
      ),
    );
  }
}
