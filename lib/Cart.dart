import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/CartOrder.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:freshcart_app/currentcity.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class Cart extends StatefulWidget {

  @override
  _Cart createState() => _Cart();
}
class _Cart extends State<Cart> {


  @override
  void initState() {
    super.initState();
    viewproduct();

    //sellerprofile();
  }

  List n = [];
  var d = new DateFormat('dd-MM-yy');
  bool progress = false;
  List profile = [];

  //List p=[];
  var pid;
  int page = 1,
      count = 5;
  var deldate;
  var len;

  void viewproduct() async {
    setState(() {
      progress = true;
    });
//print('/product/getbyseller?city='+widget.id+'&sellerid='+widget.sellerid+'&count='+count.toString()+'&page='+page.toString());
    var url = Prefmanager.baseurl +'/Cart/all';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,

    };
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      profile = json.decode(response.body)['data'];
      for(int j=0;j<profile.length;j++)
      {
        n.add(0);
      }
    }
    else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );

    progress = false;
    loading = false;
    setState(() {});
  }

  bool selected = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('My Cart'
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),

            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: progress ? Center(child: CircularProgressIndicator(),) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              currentcity(),
              profile.length == 0 ?
              Container(
                height: 200,
                width: double.infinity,
                //color: Colors.grey,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(30),
                child: Text("No products addded to cart",
                    style: TextStyle(fontSize: 18)),
              )
                  : Expanded(child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!loading && scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    if (len > profile.length) {
                      print(len);
                      print(profile.length);
                      viewproduct();
                      setState(() {
                        loading = true;
                      });
                    }
                    else {}
                  }
                  else {}
                  //  setState(() =>loading = false);
                  return true;
                },
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: profile.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                          new Card(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:BorderRadius.circular(10.0)),
                              shape: selected
                                  ? new RoundedRectangleBorder(
                                //side: new BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0))
                                  : new RoundedRectangleBorder(
                                //side: new BorderSide(color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 4.0,

                              child: InkWell(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),

                                    Expanded(
                                      child: new Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(65.0),
                                              child: FadeInImage(
                                                //   image:NetworkImage(
                                                //       Prefmanager.baseurl+"/u/"+profile[index]['seller']["photo"]) ,
                                                image: AssetImage(
                                                    'assets/vegetables.jpg'),
                                                placeholder: AssetImage(
                                                    "assets/userlogo.jpg"),
                                                fit: BoxFit.cover,
                                                width: 90,
                                                height: 90,
                                              ),

                                            ),
                                          ),
                                          //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                          Expanded(
                                              child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        //Text("Tom George")
                                                        Expanded(flex: 1,
                                                            child: Text(
                                                              profile[index]['product']['productname'] ??
                                                                  " ",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight
                                                                      .bold),)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                        children: [
                                                          Expanded(flex: 1,
                                                              child: Text(
                                                                profile[index]['product']['description'] ??
                                                                    " ",)),
                                                        ]

                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                        children: [

                                                          Expanded(flex: 1,
                                                              child: Text(
                                                                "Quantity" +
                                                                    profile[index]['quantity'].toString(),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold),)),
                                                        ]
                                                    ),
                                                    Container(

                                                      height: 30,

                                                      color: Colors.green,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .end,

                                                        children: [
                                                          Container(
                                                            height: 20,

                                                            child: MaterialButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  n[index]++;
                                                                });
                                                                mycart(
                                                                    profile[index]['product']['_id'], n[index]);

                                                              },

                                                              child: new Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white
                                                              //gradient: LinearGradient(colors: [Colors.red, Colors.blue])
                                                            ),
                                                          ),
                                                          n[index] <= 0 ?
                                                          new Text("ADD",
                                                              style: new TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight
                                                                      .bold)) :
                                                          new Text(
                                                              '${n[index]}',
                                                              style: new TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight
                                                                      .bold)),

                                                          Container(
                                                            height: 20,
                                                            child: new MaterialButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    n[index]--;
                                                                  });
                                                                  print(n);
                                                                },
                                                                child: new Icon(
                                                                  Icons
                                                                      .filter_list,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,)),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white
                                                              //gradient: LinearGradient(colors: [Colors.red, Colors.blue])
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  ]
                                              )
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap:() {
                                  Navigator.push(context,new MaterialPageRoute(builder: (context)=>new CartOrder(profile[index])));
                                }
                              )
                          );
                      }
                  ),
                ),
              ),
              ),
              Container(
                height: loading ? 20 : 0,
                width: double.infinity,
                child: Center(
                    child: CircularProgressIndicator()
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  void mycart(productid, quantity) async {
    var url = Prefmanager.baseurl + '/Cart/Addorupdate';
    print("ffgg");
    var token = await Prefmanager.getToken();
    Map cartdata = {
      "x-auth-token": token,
      "productid": productid,
      "quantity": quantity
    };
    print(cartdata);
    var body = json.encode(cartdata);
    print("print");
    var response = await http.post(url,
        headers: {"Content-Type": "application/json", "x-auth-token": token},
        body: body);
    print("response");
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
      //Navigator.of(context).pop(true);
      print("success,added cart");
      viewproduct();
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