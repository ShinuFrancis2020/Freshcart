import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/ViewProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class SellerView extends StatefulWidget
{
  final id,name;
  SellerView(this.id,this.name);
  @override
  _SellerView createState() =>_SellerView();
}
class _SellerView extends State <SellerView> {
  @override
  void initState() {
    super.initState();
    viewprofile();
  }
  var len;
  var d=new DateFormat('dd-MM-yy');
  bool progress=true;
  List profile=[];
  List p=[];
  int page=1,count=5;
  void  viewprofile() async {
    var url = Prefmanager.baseurl+'/user/getsellersbycategory?category='+widget.id+'&count='+count.toString()+'&page='+page.toString();
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
      p=json.decode(response.body)['data'];
      len=json.decode(response.body)['count'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        profile.add(json.decode(response.body)['data'][i]);
      page++;
    }
    progress=false;
    loading=false;
    setState(() {});
  }
  bool loading=false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation:0.0,
        title: Text(widget.name),

      ),
      body:SafeArea(
        child: progress?Center( child: CircularProgressIndicator(),):
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height:10
                ),
                Text("Sellers",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                SizedBox(
                  height:20
                ),
                p.isEmpty?
                    Center(child: Text("No sellers available under this category",style:TextStyle(fontWeight: FontWeight.bold)))
                :Expanded(child:NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      if(len>profile.length){
                        print(len);
                        print(profile.length);
                        viewprofile();
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
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
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
                                                child: CircleAvatar(
                                                  radius: 50.0,
                                                  backgroundColor: Colors.blue,
                                                  backgroundImage:AssetImage('assets/userlogo.jpg'),

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
                                                           //Text("Tom George")
                                                            Expanded(flex:1,child: Text(profile[index]['seller']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:5,
                                                        ),
                                                        Row(
                                                          children:[
                                                            //Expanded(flex:10,child: Text("Mobile:",style: TextStyle(fontSize: 16),)),
                                                            Expanded(flex:1,child: Text(profile[index]['seller']['email'],)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:5,
                                                        ),
                                                        Row(
                                                            children:[
                                                              Expanded(flex:1,child: Text(profile[index]['seller']['phone'],)),
                                                            ]
                                                        ),
                                                        SizedBox(
                                                          height:5,
                                                        ),
                                                        Row(
                                                            children:[
                                                              profile[index]['deliveryDate']==null?
                                                                  Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold))
                                                              :Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse(profile[index]['deliveryDate'],))?? " ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                                            ]
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
                                      Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ViewProduct(profile[index]['seller']['_id'],widget.id,profile[index]['seller']['name'],widget.name,profile[index]['deliveryDate'])));
                                    }
                                )
                            );
                        }
                    ),
                  ),
                ),),
                Container(
                  height: loading?20:0,
                  width:double.infinity,
                  child: Center(
                      child:CircularProgressIndicator()
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
