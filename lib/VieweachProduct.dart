import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/PlaceOrder.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/ViewsellerProductsall.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class VieweachProduct extends StatefulWidget {
  final pid,sellerid,deldate;
  VieweachProduct(this.pid,this.sellerid,this.deldate);
  @override
  _VieweachProduct createState() => _VieweachProduct();
}
class _VieweachProduct extends State<VieweachProduct> {
  @override
 Future<void> initState(){
    super.initState();
   allFunctions();
  }
 Future<void> allFunctions() async{
   await senddata();
    await vieweachproduct();
    await sellerproducts();

  }
  var d=new DateFormat('dd-MM-yy');
  bool progress=true;
  bool buttonCheck=false;
  var product;
  //List product=[];
  //List p=[];
  void  vieweachproduct() async {
    var url = Prefmanager.baseurl+'/product/info?id='+widget.pid;
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      //'category':widget.id,
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      //for (int i = 0; i < json.decode(response.body)['data'].length; i++)
       // product.add(json.decode(response.body)['data'][i]);
      product=json.decode(response.body)['data'];
    }
    else
      print("Somjj");

    progress=false;
    loading=false;
    setState(() {});
  }
  bool prog=true;
  List profile=[];
  void  sellerproducts() async {
    var url = Prefmanager.baseurl+'/product/getbyseller?sellerid='+widget.sellerid;
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      //'category':widget.id,
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {


      for (int i = 0; i <json.decode(response.body)['data'].length; i++){
        if(json.decode(response.body)['data'][i]['_id']==widget.pid)
          {

          }
        else
        profile.add(json.decode(response.body)['data'][i]);
      }
     }
    else
      print("Somjj");

    prog=false;
    setState(() {});
  }

bool selected=true;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title:  progress?Center( child: CircularProgressIndicator(),):Text(product['productname']
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: progress?Center( child: CircularProgressIndicator(),):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      height:10
                  ),
                  Image(image: AssetImage('assets/vegetables.jpg')),
                  SizedBox(
                    height:20
                  ),
                  Row(
                      children:[
                        Expanded(flex:1,child: Text(product['productname']?? " ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                      ]
                  ),
                  SizedBox(
                      height:5
                  ),

                  Row(
                      children:[
                        Expanded(flex:1,child: Text(product['description']?? " ")),
                      ]
                  ),
                  SizedBox(
                      height:5
                  ),


                  Row(
                    children: [
                      widget.deldate==null?
                      Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold)):
                      Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse(widget.deldate)),style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  SizedBox(
                      height:20
                  ),
                  FlatButton(
                    height: 50,
                    minWidth:MediaQuery.of(context).size.width /1,
                    textColor: Colors.white,
                    color:  buttonCheck==true?Colors.green:Colors.grey,
                    child: Text('Place Order'),
                    onPressed: () {
                      buttonCheck==true?
                      Navigator.push(context,new MaterialPageRoute(builder: (context)=>new PlaceOrder(widget.pid,product['unit']))):null;

                    },
                    //onPressed: null,
                  ),
                  SizedBox(
                      height:10
                  ),
                  buttonCheck==false?Center(child: Text(tostDisplay,style: TextStyle(fontWeight: FontWeight.bold),)):SizedBox.shrink(),
                      SizedBox(
                        height:20
                      ),
                profile.length>1?
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children:[
                            Text("More by Seller",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                            FlatButton(
                              textColor: Colors.green,
                              child: Text(
                                'See All',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      ViewsellerProductsall(widget.sellerid,widget.pid,widget.deldate)),
                                  //MaterialPageRoute(builder: (context) => DrawerDemo()),
                                ); //signup screen
                              },
                            ),
                          ]
                      ),
                      SizedBox(
                        height:20,
                      ),
                      Container(
                        height:300,
                        child: prog?Center( child: CircularProgressIndicator(),): ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: profile.length>3?3:profile.length,
                              itemBuilder: (BuildContext context,int index){
                                return
                                  InkWell(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),

                                          new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[

                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:[
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Image(image: AssetImage('assets/fishimage2.jpg'),),
                                                    SizedBox(
                                                        height:10
                                                    ),
                                                    // Column(
                                                    //     children:sellerProducts(context)
                                                    // ),
                                                    Text(profile[index]['productname'],style:TextStyle(fontWeight: FontWeight.bold,),textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,),
                                                    SizedBox(
                                                        height:5
                                                    ),
                                                    Expanded(flex:1,child: Text(profile[index]['description']?? " ")),
                                                    // widget.deldate==null?
                                                    // Text("No delivery date",style:TextStyle(fontWeight: FontWeight.bold)):
                                                    // Expanded(flex:1,child: Text("Delivery by "+d.format(DateTime.parse(widget.deldate)),style: TextStyle(fontWeight: FontWeight.bold),)),
                                                  ]
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap:() {
                                        Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                                      }
                                  );
                              }
                          ),
                      ),
                    ],
                  )
                    :SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),


    );

  }
  var tostDisplay;
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/Purchase/checkdate';
      var token=await Prefmanager.getToken();
      Map data={
        'x-auth-token': token,
        'product':widget.pid,
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
          buttonCheck=true;
          setState(() {

          });
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new PlaceOrder(widget.pid,product['unit'])));

        }

        else{
          buttonCheck=false;
         tostDisplay=json.decode(response.body)['msg'];
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
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
