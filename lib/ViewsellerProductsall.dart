import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class ViewsellerProductsall extends StatefulWidget {
  final sellerid,pid,deldate;
  ViewsellerProductsall(this.sellerid,this.pid,this.deldate);
  @override
  _ViewsellerProductsall createState() => _ViewsellerProductsall();
}
class _ViewsellerProductsall extends State<ViewsellerProductsall> {
  @override
  void initState() {
    super.initState();
    sellerproducts();
  }
  var d=new DateFormat('dd-MM-yy');
  bool progress=true;
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
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      //profile.add(json.decode(response.body)['data'][i]);
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

    progress=false;
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
          title: Text("View All"
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),

            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: progress?Center( child: CircularProgressIndicator(),):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
                scrollDirection: Axis.vertical,
              //physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2 ,
              children: List.generate(profile.length,(index){
                  return
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              SizedBox(
                                height: 5,
                              ),
                              Image(image: AssetImage('assets/fishimage2.jpg')),
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
                              widget.deldate==null?
                              Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold)):
                              Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse(widget.deldate)),style: TextStyle(fontSize:12,fontWeight: FontWeight.bold),)),
                            ]
                        ),
                        onTap:() {
                          Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                          //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ServiceView(profile[index]['_id'])));
                        }
                    );
                }
            ),

            ),
          ),
        ),
      ),

    );

  }
}
