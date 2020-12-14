import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class ProductAll extends StatefulWidget {
  final id;
  ProductAll(this.id);
  @override
  _ProductAll createState() => _ProductAll();
}
class _ProductAll extends State<ProductAll> {

  @override
  void initState() {
    super.initState();
    viewproduct();

    print(widget.id);
    //sellerprofile();
  }
  var d=new DateFormat('dd-MM-yy');
  bool progress=false;
  List profile=[];
  //List p=[];
  int page=1,count=5;
  var deldate;
  var len;
  void  viewproduct() async {
    setState(() {
      progress=true;
    });
//print('/product/getbyseller?city='+widget.id+'&sellerid='+widget.sellerid+'&count='+count.toString()+'&page='+page.toString());
    var url = Prefmanager.baseurl+'/product/all?city='+widget.id+'&count='+count.toString()+'&page='+page.toString();
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
      //deldate=json.decode(response.body)['data']['deliveryadddress']['deliverydate'];
      len=json.decode(response.body)['count'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        profile.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );

    progress=false;
    loading=false;
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
          title: Text('View products'
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),

            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: progress?Center( child: CircularProgressIndicator(),):
          Column(
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
                                                      Row(
                                                          children:[
                                                            profile[index]['deliverydetails']['deliveryDate']==null?
                                                            Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold)):
                                                            Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse( profile[index]['deliverydetails']['deliveryDate'])),style: TextStyle(fontWeight: FontWeight.bold),)),
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
                                     Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index])));
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
      ),

    );
  }

}