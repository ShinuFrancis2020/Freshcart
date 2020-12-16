import 'dart:convert';
import 'package:freshcart_app/ApprovedOrder.dart';
import 'package:freshcart_app/DeliveredOrder.dart';
import 'package:freshcart_app/PendingOrder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:http/http.dart' as http;
class MyOrders extends StatefulWidget
{
  @override
  _MyOrders createState() =>_MyOrders();
}
class _MyOrders extends State <MyOrders> {
  @override
  void initState() {
    super.initState();
    myOrders1();
  }
  //int count=5,page=1;
  List orders1=[];
  void myOrders1() async{
    print('/Purchase/groupedmyorders?count=5'+'&page=1');
    var url=Prefmanager.baseurl+'/Purchase/groupedmyorders?count=5&page=1';
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      'count':count.toString(),
      'page':page.toString()

    };

    var response = await http.get(url,headers:requestHeaders);
    print("ndjfnsd");
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      orders.clear();
      //orders=json.decode(response.body)['data'];
      //print(orders);
      len = json.decode(response.body)['count'];
      pages=json.decode(response.body)['pages'];
      //orders.clear();
     orders=json.decode(response.body)['data'];
     page++;
     loading=false;
     setState(() {

     });
    }
    else {
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    }
    progress=false;
    setState(() {});
  }
  List orders=[];
  bool progress=true;
  int page=1,count=5;
  var len,pages,status;
  var d=new DateFormat('dd-MM-yy');
  void myOrders() async{
    print('/Purchase/groupedmyorders?count='+count.toString()+'&page='+page.toString());
    var url=Prefmanager.baseurl+'/Purchase/groupedmyorders?count='+count.toString()+'&page='+page.toString();
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,


    };

    var response = await http.get(url,headers:requestHeaders);
    print("ndjfnsd");
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      //orders=json.decode(response.body)['data'];
      //print(orders);
      len = json.decode(response.body)['count'];
      pages=json.decode(response.body)['pages'];
      //orders.clear();
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        orders.add(json.decode(response.body)['data'][i]);
        page++;
      print(orders.length);
    }
    else {
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    }
    progress=false;
    loading=false;
    setState(() {

    });
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
    print("fndjn");
    print(response.body);
    if (json.decode(response.body)['status']) {
      print(orders.length);
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
     await myOrders1();
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
  bool selected=false;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(

        elevation:0.0,
        title: Text("My Orders"),

      ),
      body:SafeArea(
        child: progress?Center( child: CircularProgressIndicator(),):
            orders.isEmpty?
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
              Image(image: AssetImage('assets/cart.jpg'),height:100),
                SizedBox(
                  height:20,
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:[Text("No Orders yet",style:TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                      ]
                  ),
                  SizedBox(
                    height:5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[Text("Looks like you haven't made"),
                      ]
                  ),
                  SizedBox(
                    height:5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[Text("your order yet."),
                      ]
                  )
                ],
              ),

            ),
          ],
        )
        :Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 15),
                child:ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                   GestureDetector(
                     child: Container(
                       margin: EdgeInsets.only(left:1),
                       alignment:Alignment.center,
                       width:MediaQuery.of(context).size.width/6,
                         child:Text("All",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold),)
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
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.white)
                          // ),
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
                        }
                    )

                  ],
                )
              ),

              Expanded(child:NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
        if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
        if(pages>=page){
        myOrders();
        print("bhhh");
        print(page);
        print(pages);
        print(orders.length);
        setState(() {
        loading = true;
        });
        }
        else{
          setState(() {
            loading = false;
          });
        }

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:10
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Ordered on "+d.format(DateTime.parse(orders[index]['orderdate'].toString())),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      orders[index]['total']>0?
                                      Text("Total price "+orders[index]['total'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()

                                    ],
                                  ),
                                ),


                                Column(
                                  children:
                                      List.generate(orders[index]['orderdata'].length,(p){
                                    return Column(
                                      children: [
                                        //Text(orders[index]['orderdata'][p]['status']),

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
                                                      borderRadius:BorderRadius.circular(17.0),
                                                      child:FadeInImage(
                                                        // image:NetworkImage(
                                                        //     Prefmanager.baseurl+"/document/get/"+profile[index]["icon"]) ,
                                                        image: AssetImage('assets/fishimg1.jpg'),
                                                        placeholder: AssetImage("assets/cloud.jpg"),
                                                        fit: BoxFit.fill,
                                                        width:100,
                                                        height:100,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(

                                                      child:Column(
                                                        children:
                                                             List.generate(orders[index]['orderdata'][p]['product'].length,(k){
                                        return Column(
                                        children:[
                                        SizedBox(
                                        height: 8,
                                        ),

                                        Row(
                                        children:[
                                        Text(orders[index]['orderdata'][p]['product'][k]['productname'],style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,)),
                                        // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                        ],
                                        ),
                                        SizedBox(
                                        height:5,
                                        ),
                                        Row(
                                        children: [
                                        Text("Quantity : "+orders[index]['orderdata'][p]['quantity'].toString()+orders[index]['orderdata'][p]['product'][k]['unit'],style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

                                        ],
                                        ),
                                        SizedBox(
                                        height:10
                                        ),
                                         Row(
                                           children:[
                                             orders[index]['orderdata'][p]['status']=='Delivered'&&orders[index]['orderdata'][p]['totalprice']!=null?
                                           Text("Price : "+orders[index]['orderdata'][p]['totalprice'].toString(),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()
                                        ]
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
                                                      if(orders[index]['orderdata'][p]['status']!='Delivered')
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                       // Text("Ordered on "+d.format(DateTime.parse(orders[index]['orderdate'].toString())),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                        // Spacer(),
                                        // SizedBox(
                                        // //width:70
                                        // width:MediaQuery.of(context).size.width/3
                                        // ),
                                         if(orders[index]['orderdata'][p]['status']=='Pending')
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
                                        _showDialog(orders[index]['orderdata'][p]['_id']);
                                        print(orders[index]['orderdata'][p]['_id']);
                                        },
                                        ),
                                        ],
                                        ),


                                        SizedBox(
                                        height:5,
                                        ),


                                        ]
                                        );
                                        })

                                                      ),

                                                  ),

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
                                              Column(
                                               crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                children: [
                                                  Text("Order status",style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                                  SizedBox(
                                                      height:10
                                                  ),

                                                  if(orders[index]['orderdata'][p]['status']=='Pending')
                                                    Text("Awaiting seller's approval",style: TextStyle(color:Colors.amber,fontSize:12,fontWeight: FontWeight.bold),),
                                                  if(orders[index]['orderdata'][p]['status']=='Approved')
                                                    Text("Order approved by seller",style: TextStyle(color:Colors.orange,fontSize:12,fontWeight: FontWeight.bold),),
                                                  if(orders[index]['orderdata'][p]['status']=='Rejected')
                                                   Text("Order rejected by seller due to "+orders[index]['orderdata'][p]['rejectreason'],style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                                 // Text(orders[index]['orderdata'][p]['rejectreason'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                                  if(orders[index]['orderdata'][p]['status']=='Delivered')
                                                    Text("Delivered on "+d.format(DateTime.parse(orders[index]['orderdata'][p]['deliverydate'])),style: TextStyle(color:Colors.green,fontSize:12,fontWeight: FontWeight.bold),)
                                                ],
                                              )
                                            ],
                                          )
                                        ),
                                      ],
                                    );
                                      })
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
