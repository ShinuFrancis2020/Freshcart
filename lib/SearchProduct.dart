import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:freshcart_app/currentcity.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class SearchProduct extends StatefulWidget {
  final keyword,searchMsg,cityid;
  SearchProduct(this.keyword,this.searchMsg,this.cityid);
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
    var url = Prefmanager.baseurl+'/product/search?city='+widget.cityid;
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
      Fluttertoast.showToast(
            msg: json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 20.0
        );

    progress=false;
    loading=false;
    setState(() {});
  }

  bool selected=true;
  bool loading=false;
  @override
  bool typing = false;
  TextEditingController keyword = TextEditingController();
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
        child: Column(
          children: [
            Container(
                color:Colors.green,
                padding: EdgeInsets.all(8),
                //padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(

                  //onChanged: onTextChange,
                  //   onChanged: (text) {
                  //     //senddata();
                  //     callSearch(text);
                  //   },
                    onChanged: callSearch,
                    controller: keyword,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        // prefixIcon: Icon(Icons.search,color:Colors.black),
                        hintText: widget.keyword,
                        hintStyle: TextStyle(fontSize: 17),
                        //border: OutlineInputBorder( borderSide: BorderSide.none),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero
                    )
                )
            ),
            currentcity(),
            Expanded(
              child: Container(
                child: progress?Center( child: CircularProgressIndicator(),):
                    profile.isEmpty?
                        Container(
                            child: Center(child: Text("No search results found",style: TextStyle(fontWeight: FontWeight.bold),)))
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
                                      onTap:() {Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index])));
                                      }
                                  )
                              );
                          }
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
          ],
        ),
      ),
    );
  }
  var searchOnStopTyping;
  callSearch(String query) {
    const duration = Duration(milliseconds: 800);

    if (searchOnStopTyping != null) {

      setState(() {
        searchOnStopTyping.cancel();

      });
    }
    setState(() {
      searchOnStopTyping = new Timer(duration, () {
        senddata();

        setState(() {

        });
      });
    });
    //keyword.clear();
  }
  var searchMsg;
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/product/search?city='+widget.cityid;
      var token=await Prefmanager.getToken();
      Map data={
        'x-auth-token': token,
        'keyword':keyword.text,

      };
      // print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","x-auth-token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        //print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg,widget.cityid))).then((value) {
            //This makes sure the textfield is cleared after page is pushed.
            keyword.clear();
          });
        }

        else{
          searchMsg=json.decode(response.body)['msg'];
          print("no products");

          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg,cityid))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          // print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //     msg: json.decode(response.body)['msg'],
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     backgroundColor: Colors.grey,
          //     textColor: Colors.white,
          //     fontSize: 20.0
          // );
          keyword.clear();
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