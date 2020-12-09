import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class SearchProduct extends StatefulWidget {
  final keyword,searchMsg;
  SearchProduct(this.keyword,this.searchMsg);
  @override
  _SearchProduct createState() => _SearchProduct();
}
class _SearchProduct extends State<SearchProduct> {

  @override
  void initState() {
    super.initState();
    viewproduct();
    //sellerprofile();
  }
  var d=new DateFormat('dd-MM-yy');
  bool progress=true;
  List profile=[];
  //List p=[];
  int page=1,count=5;
  var len,pages,pid;
  void  viewproduct() async {
    var url = Prefmanager.baseurl+'/product/search';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      'keyword':widget.keyword,
      'count':count.toString(),
      'page':page.toString(),
    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(url,headers: {"Content-Type": "application/json","x-auth-token": token,},body: body);
    print(json.encode(response.body));
    if (json.decode(response.body)['status']) {

      len=json.decode(response.body)['count'];
      pages=json.decode(response.body)['pages'];
      //d=json.decode(response.body)['data']['deliverydetails'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        profile.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else
      print("Somjj");

    progress=false;
    loading=false;
    setState(() {});
  }

  bool selected=true;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(" "
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),

          onPressed: () => Navigator.of(context).pop(true),
        ),
      ),
      body: SafeArea(
        child: progress?Center( child: CircularProgressIndicator(),):
            profile.isEmpty?
                Center(child: Text("No search results found",style: TextStyle(fontWeight: FontWeight.bold),))
        :Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child:NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if(len>profile.length){
                    print(len);
                    print(profile.length);
                    viewproduct();
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
                child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: profile.length,
                    itemBuilder: (BuildContext context,int index){
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
                                      width: 5,
                                    ),

                                    Expanded(
                                      child: new Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:BorderRadius.circular(65.0),
                                              child:FadeInImage(
                                                //   image:NetworkImage(
                                                //       Prefmanager.baseurl+"/u/"+profile[index]['seller']["photo"]) ,
                                                image: AssetImage('assets/vegetables.jpg'),
                                                placeholder: AssetImage("assets/userlogo.jpg"),
                                                fit: BoxFit.cover,
                                                width:90,
                                                height:90,
                                              ),

                                            ),
                                          ),
                                          //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                          Expanded(
                                              child:Column(
                                                  children:[
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children:[
                                                        //Text("Tom George")
                                                        Expanded(flex:1,child: Text(profile[index]['productname']?? " ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:5,
                                                    ),
                                                    Row(
                                                        children:[
                                                          Expanded(flex:1,child: Text(profile[index]['description'] ?? " ",)),
                                                        ]

                                                    ),
                                                    SizedBox(
                                                      height:5,
                                                    ),
                                                   // if(profile[index]['deliverydetails']!=null)
                                                   //  Row(
                                                   //      children:[
                                                   //        profile[index]['deliverydetails']==null && profile[index]['deliverydetails']['deliverydate']==null?
                                                   //        Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold)):
                                                   //        Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse( profile[index]['deliverydetails']['deliveryDate'])),style: TextStyle(fontWeight: FontWeight.bold),)),
                                                   //      ]
                                                   //  ),

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
                                  Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'], profile[index]['deliverydetails']['deliveryDate'])));
                                }
                            )
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
            )
          ],
        ),
      ),
    );
  }

}