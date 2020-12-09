import 'dart:convert';
import 'package:freshcart_app/DeliveredOrder.dart';
import 'package:freshcart_app/MyCart.dart';
import 'package:freshcart_app/PendingOrder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class ApprovedOrder extends StatefulWidget
{
  @override
  _ApprovedOrder  createState() =>_ApprovedOrder ();
}
class _ApprovedOrder  extends State <ApprovedOrder > {
  @override
  void initState() {
    super.initState();
    myOrders();
  }
  List orders=[];
  bool progress=true;
  int page=1,count=5;
  var len,pages,status;
  var d=new DateFormat('dd-MM-yy');
  void myOrders() async{
    var url=Prefmanager.baseurl+'/Purchase/groupedmyorders?count='+count.toString()+'&page='+page.toString()+'&status='+'Approved';
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
      pages=json.decode(response.body)['pages'];
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
                            child:Text("Pending",style:TextStyle(fontWeight:FontWeight.bold))
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
                              child:Text("Orders",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold))
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
                  Center(child: Text("No orders awaiting delivery",style:TextStyle(fontWeight: FontWeight.bold)))
             : Expanded(child:NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    if(pages>=page){
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Ordered on "+d.format(DateTime.parse(orders[index]['orderdate'].toString())),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                      //Spacer(),
                                      //orders[index]['total']>0?
                                      //Text("Total price "+orders[index]['total'].toString(),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()

                                    ],
                                  ),
                                ),

                                Column(
                                  children:
                    List.generate(orders[index]['orderdata'].length,(p) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),

                                      Expanded(
                                        child: new Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(15.0),
                                                child: FadeInImage(
                                                  // image:NetworkImage(
                                                  //     Prefmanager.baseurl+"/document/get/"+profile[index]["icon"]) ,
                                                  image: AssetImage(
                                                      'assets/fishimg1.jpg'),
                                                  placeholder: AssetImage(
                                                      "assets/cloud.jpg"),
                                                  fit: BoxFit.fill,
                                                  width: 70,
                                                  height: 70,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                  children:
                   List.generate(orders[index]['orderdata'][p]['product'].length,(k) {
                      return Column(
                      children: [
                      Row(
                      children: [
                      SizedBox(
                      height: 10,
                      ),
                      Text(
                      orders[index]['orderdata'][p]['product'][k]['productname'],
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight
                          .bold,)),
                      // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                      ],
                      ),


                      SizedBox(
                      height: 10,
                      ),
                      Row(
                      children: [
                      Text("Quantity : " +
                      orders[index]['orderdata'][p]['quantity']
                          .toString()+orders[index]['orderdata'][p]['product'][k]['unit'],
                      style: TextStyle(
                      color: Colors
                          .grey,
                      fontSize: 12,
                      fontWeight: FontWeight
                          .bold),),

                      ],
                      ),
                      SizedBox(
                      height: 5
                      ),
                        Column(
                            children:
                            List.generate(orders[index]['orderdata'][p]['seller'].length,(q){
                              return Column(
                                  children:[
                                    SizedBox(
                                        height:10
                                    ),
                                    Row(
                                      children:[
                                        Text("Seller name : "+orders[index]['orderdata'][p]['seller'][q]['name'],style:TextStyle(fontSize:12,fontWeight:FontWeight.bold,color:Colors.grey)),
                                        // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                    SizedBox(
                                        height:10
                                    ),

                                      Row(
                                        children: [
                                          orders[index]['orderdata'][p]['deliverydate']!=null?
                                          Text("Next delivery by : "+d.format(DateTime.parse(orders[index]['orderdata'][p]['deliverydate'])),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),)
                                              :SizedBox.shrink()
                                        ],
                                      ),

                                    SizedBox(
                                      height:5,
                                    ),

                                  ]
                              );
                            })
                        ),


                      SizedBox(
                      height: 5,
                      ),

                      ]
                      );
                      }
                                            )
                                            )
                                        ),

])
                                            )]
                                  ),
                                ],
                              );
                            }
                                ),
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
                                            Text("Order approved by seller",style: TextStyle(color:Colors.amber,fontSize:12,fontWeight: FontWeight.bold),),

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
