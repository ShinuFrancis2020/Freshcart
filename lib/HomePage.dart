import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:freshcart_app/AddressAdd.dart';
import 'package:freshcart_app/Cart.dart';
import 'package:freshcart_app/ProductAll.dart';
import 'package:freshcart_app/VieweachProduct.dart';
import 'package:freshcart_app/viewcategoryproducts.dart';
import 'package:freshcart_app/viewcityproducts.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/DeliveyAddress.dart';
import 'package:freshcart_app/MyCart.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:freshcart_app/SearchProduct.dart';
import 'package:freshcart_app/SellerView.dart';
import 'package:freshcart_app/ViewProduct.dart';
import 'package:freshcart_app/ViewProfile.dart';
import 'package:freshcart_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}
class _HomePage extends State<HomePage> {
  List n=[];
  var prid;
  var a,fulladdress,current;
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController location = TextEditingController();
  void initState() {
    super.initState();
    Home();

  }
  void Home()async{
    await profile();
    await sellerView();
    await category();
    await cartview();
    await ProductView();
    await viewproduct();
  }
  var mycity,myid;
  var listprofile;
  var cityid;
  List<bool> checkValue=[];
  List deliverylength=[];
  var st,ci;
  var currentcity;
  bool progress=true;
  void profile() async{
    var url=Prefmanager.baseurl+'/user/profile';
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
    if(json.decode(response.body)['status'])
    {
      listprofile=json.decode(response.body)['data'];
      print(listprofile);
      cityid=json.decode(response.body)['data']['currentcity']['_id'];
      print(cityid);
      mycity=json.decode(response.body)['data']['currentcity']['city'];

      deliverylength=listprofile['deliveryaddress'];
      for(int i=0;i<deliverylength.length;i++) {
        //checkValue.add(false);
        print(deliverylength);
      }


    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  var listcat=[];
  int i;
  void category() async{
    var url=Prefmanager.baseurl+'/category/getlist';
    var token=await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };
    var response = await http.get(url,headers:requestHeaders);
    if(json.decode(response.body)['status'])
    {
      for(i=0;i<json.decode(response.body)['data'].length;i++)
        listcat.add(json.decode(response.body)["data"][i]);


      //print(listcat[0]['cname']);
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    if(mounted)
      setState(() {});
  }
  var len;
  var d=new DateFormat('dd-MM-yy');
  List sellers=[];
  List p=[];
  int page=1,count=5;
  void  viewseller() async {
    var url = Prefmanager.baseurl+'/user/getsellersbycategory?count='+count.toString()+'&page='+page.toString();
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      //'category':widget.id,
    };
    var response = await http.get(url,headers:requestHeaders);
    //print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      p=json.decode(response.body)['data'];
      len=json.decode(response.body)['count'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        sellers.add(json.decode(response.body)['data'][i]);
      page++;
    }
    progress=false;
    loading=false;
    setState(() {});
  }

  void logout() async{
    var url=Prefmanager.baseurl+'/user/logout';
    var token=await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };
    var response = await http.get(url,headers:requestHeaders);
    if(json.decode(response.body)['status'])
    {
      Fluttertoast.showToast(msg:json.decode(response.body)['msg']);
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    if(mounted)
      setState(() {});
  }
  var le;
  List seller=[];
  int pag=0,coun=0;
  void  sellerView() async {
    print("seller view");
    var url = Prefmanager.baseurl+'/user/sellerlist?city='+cityid;

    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      //'category':widget.id,
    };
    print("ddff");
    var response = await http.get(url,headers:requestHeaders);
    //print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      seller=json.decode(response.body)['data'];

      le=json.decode(response.body)['count'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      //   seller.add(json.decode(response.body)['data'][i]);
     // page++;
    }
    progress=false;
    loading=false;
    setState(() {});
  }
  var leng;
  List product=[];
  //int pa=1,cou=5;
  void  ProductView() async {
    print("seller view");
    var url = Prefmanager.baseurl+'/product/all?city='+cityid;
      print("dgdg");
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token,
      //'category':widget.id,
    };
    print("ddff");
    var response = await http.get(url,headers:requestHeaders);
    //print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      product=json.decode(response.body)['data'];

      for(int i=0;i<product.length;i++)
      n.add(0);

      for(int j=0;j<cname.length;j++)
        {
          for(int i=0;i<product.length;i++)
          {
            if(cname[j]['product']['_id']==product[i]['_id']){
              n.removeAt(i);
              n.insert(i, cname[j]['quantity']);
            }

          }
        }


     // n.fillRange(0, product.length>6?6:product.length,{4});
      print(product);

      leng=json.decode(response.body)['count'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      //   seller.add(json.decode(response.body)['data'][i]);
      // page++;
    }
    progress=false;
    loading=false;
    setState(() {});
  }



  List search=[];
  //List p=[];
  var pid;
  void  viewproduct() async {
    var url = Prefmanager.baseurl+'/product/search?city='+cityid;
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      'keyword':keyword.text,
    };
    // print(data);
    var body = json.encode(data);
    var response = await http.post(url,headers: {"Content-Type": "application/json","x-auth-token": token,},body: body);
    print(json.encode(response.body));
    if (json.decode(response.body)['status']) {

      len=json.decode(response.body)['count'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        search.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else
      print("Somjj");

    progress=false;
    loading=false;
    setState(() {});
  }
  bool loading=false;

  Widget groupItems(){
    return Column(
        children:[
          SizedBox(
              height: 200.0,
              //width: double.infinity,
              // width:340,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Carousel(
                  images: [
                    AssetImage("assets/fishimage3.jpg"),
                    AssetImage("assets/vegetables.jpg"),
                    AssetImage("assets/meat.jpeg"),

                  ],
                  dotColor: Colors.red,
                ),
              )),
          SizedBox(
            height:30,
          ),
          Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children:[
                Container(
                    padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.topLeft,
                    child:Text("Category",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                ),

                // Container(
                //     padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                //     alignment: Alignment.topRight,
                //     child:Text("See all")
                // ),
              ]
          ),
          SizedBox(
            height:20,
          ),
          progress?Center(child:CircularProgressIndicator(),):
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2 ,
            children: List.generate(listcat.length,(index){
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(5) ,
                  //padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Image(image: AssetImage('assets/meat.jpeg')),
                      //  SizedBox(
                      //      height:10
                      //  ),
                      //Text("Fish",style:TextStyle(fontWeight: FontWeight.bold,),textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,),
                      if(listcat[index]['name']=='Fish')
                        Image(image: AssetImage('assets/fishimage2.jpg')),
                      if(listcat[index]['name']=='Meat')
                        Image(image: AssetImage('assets/meat.jpeg')),
                      if(listcat[index]['name']=='Vegetables')
                        Image(image: AssetImage('assets/vegetables.jpg')),
                      SizedBox(
                          height:10
                      ),
                      Text(listcat[index]['name'],style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,),textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,),

                    ],
                  ),),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => SellerView(listcat[index]["_id"],listcat[index]['name'])));
                  //Navigator.pop(context);
                },
              );
            }),
          ),
        ]
    );
  }
  Widget searchItems(){
    return Column(
      children: [
        SafeArea(
          child: progress?Center( child: CircularProgressIndicator(),):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child:NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    if(len>search.length){
                      print(len);
                      print(search.length);
                      //viewproduct();
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
                      itemCount: search.length,
                      itemBuilder: (BuildContext context,int index){
                        return
                          new Card(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:BorderRadius.circular(10.0)),
                              shape: new RoundedRectangleBorder(
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
                                                          Expanded(flex:1,child: Text(search[index]['productname']?? " ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:5,
                                                      ),
                                                      Row(
                                                          children:[
                                                            Expanded(flex:1,child: Text(search[index]['description'] ?? " ",)),
                                                          ]

                                                      ),
                                                      SizedBox(
                                                        height:5,
                                                      ),
                                                      // Row(
                                                      //     children:[
                                                      //       widget.deldate==null?
                                                      //       Text("No delivery date",style:TextStyle(fontWeight: FontWeight.bold)):
                                                      //       Expanded(flex:1,child: Text("Delivery by "+d.format(DateTime.parse(widget.deldate)),style: TextStyle(fontWeight: FontWeight.bold),)),
                                                      //     ]
                                                      // ),

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
                                    //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
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
      ],
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
  bool typing = false;
  TextEditingController keyword = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: listcat.length,
        child: Scaffold(
          appBar: AppBar(
            title:Text("FreshCart",style: TextStyle(fontSize: 18),),
            //centerTitle: true,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new Cart()));
                },
              )
            ],


          ),

          bottomNavigationBar: BottomAppBar(
            color: Colors.green,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: IconButton(icon: Icon(Icons.home),color: Colors.white,onPressed:(){
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new HomePage()));

                },),

                ),
                Expanded(child: IconButton(icon: Icon(Icons.shopping_cart),color: Colors.white,onPressed:(){
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new MyOrders()));
                },),

                ),
                //Expanded(child: new Text('')),
                // Expanded(child: IconButton(icon: Icon(Icons.notifications),color: Colors.white,onPressed:(){
                //   // Navigator.push(
                //   //     context, new MaterialPageRoute(
                //   //     builder: (context) => new ViewProduct()));
                // },),
                //
                // ),
                Expanded(child: IconButton(icon: Icon(Icons.person),color: Colors.white,onPressed: (){
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new ViewProfile()));
                },),),
              ],
            ),
          ),

          drawer:  Drawer(
            child:progress?Center(child:CircularProgressIndicator(),):
            ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  color:Colors.green,
                  child: DrawerHeader(
                    child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children:[
                          Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children:[
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Colors.blue,
                                  backgroundImage:AssetImage('assets/userlogo.jpg'),

                                ),
                              ]
                          ),

                          Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   padding: new EdgeInsets.all(10.0),
                              //   child:Text(listprofile["name"],style:TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height:10,
                            //   width:40,
                          ),
                        ]
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.home,color: Colors.black,),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new HomePage()));
                    //Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle,color: Colors.black,),
                  title: Text('My Account'),
                  onTap: () {
                    Navigator.push(
                        context, new MaterialPageRoute(
                        builder: (context) => new ViewProfile()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart,color: Colors.black,),
                  title: Text('My Orders'),
                  onTap: () {
                    Navigator.push(
                        context, new MaterialPageRoute(
                        builder: (context) => new MyOrders()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help,color: Colors.black,),
                  title: Text('Help & Support'),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home,color: Colors.black,),
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.person,color: Colors.black,), title: Text("Change Password"),
                //   onTap: () {
                //     //Navigator.push(context,MaterialPageRoute(builder: (context) => ChangePassword()));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.person,color: Colors.black,),
                  title: Text('Logout'),
                  onTap: () {
                    Prefmanager.clear();
                    //logout();
                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginScreen ()));
                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //     Container(
                  //       child:Column(
                  //         children: List.generate(listcat.length, (index) {
                  //   return TabBarView(
                  //     children: [
                  //      // for(int i=)
                  //       SellerView(listcat[index]["_id"],listcat[index]['name']),
                  //
                  //
                  //     ],
                  //   );
                  // }
                  //
                  //       )
                  //     ),
                  //     ),
                  Container(
                      color:Colors.green,
                      height: 60,
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
                              hintText: ' Search for products... ',
                              hintStyle: TextStyle(fontSize: 17),
                              //border: OutlineInputBorder( borderSide: BorderSide.none),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero
                          )
                      )
                  ),
                  //groupItems()
                  SizedBox(
                      height:10
                  ),

                  GestureDetector(
                      child: Container(
                        height: 50,
                        color:Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children:[
                                new Icon(Icons.add_location_alt),
                                Text.rich(
                                  TextSpan(
                                    text: ' Deliver to  ',
                                    style: TextStyle(fontSize:16),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: mycity,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          )),
                                      // can add more TextSpans here...
                                    ],
                                  ),
                                )
                              ]
                          ),
                        ),
                      ),
                      onTap:(){
                        displayModalBottomSheet(context);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        children:[
                          Text("Sellers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                        ]
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    height:150,
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:seller.length,
                        itemBuilder: (BuildContext context,int index){
                          return
                            InkWell(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:10,
                                    ),

                                    new Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[

                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:[
                                              Row(
                                                children: [

                                                  Container(
                                                    child: CircleAvatar(
                                                      radius: 40.0,
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage('assets/userlogo.jpg'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //Text('ghhh'),

                                              Text(seller[index]['name'],style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),textAlign:TextAlign.center),


                                            ]
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                onTap:() {
                                   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new viewcityproducts(seller[index]['_id'],cityid,seller[index]['name'])));
                                }
                            );
                        }
                    ),
                  ),
                  SizedBox(
                      height: 200.0,
                      //width: double.infinity,
                      // width:340,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Carousel(
                          images: [
                            AssetImage("assets/fishimage3.jpg"),
                            AssetImage("assets/vegetables.jpg"),
                            AssetImage("assets/meat.jpeg"),

                          ],
                          dotColor: Colors.red,
                        ),
                      )),
                  SizedBox(
                    height:30,
                  ),
                  Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                        Container(
                            padding:EdgeInsets.fromLTRB(80, 0, 10, 0),
                            alignment: Alignment.center,
                            child:Text("Shop from categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                        ),
                      ]
                  ),
                  SizedBox(
                    height:20,
                  ),
                  progress?Center(child:CircularProgressIndicator(),):
                  Container(
                    height: 150,
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.45,
                      crossAxisCount: 3,
                      children: List.generate(listcat.length,(index){
                        return GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(5) ,
                            //padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                // Image(image: AssetImage('assets/meat.jpeg')),
                                //  SizedBox(
                                //      height:10
                                //  ),
                                //Text("Fish",style:TextStyle(fontWeight: FontWeight.bold,),textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,),
                                if(listcat[index]['name']=='Fish')
                                  Image(image: AssetImage('assets/fishimage2.jpg')),
                                if(listcat[index]['name']=='Meat')
                                  Image(image: AssetImage('assets/meat.jpeg')),
                                if(listcat[index]['name']=='Vegetables')
                                  Image(image: AssetImage('assets/vegetables.jpg')),
                                SizedBox(
                                    height:10
                                ),
                                Text(listcat[index]['name'],style:TextStyle(fontSize:18,fontWeight: FontWeight.bold,),textAlign:TextAlign.center,overflow: TextOverflow.ellipsis,),

                              ],
                            ),),
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => viewcategoryproducts(listcat[index]["_id"],cityid)));
                            //Navigator.pop(context);
                          },
                        );
                      }),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(8),
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/home.png'),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  SizedBox(
                    height:50,
                  ),
                  Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                        Container(
                          color: Colors.grey[80],
                          height:40,
                            padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                            alignment: Alignment.topLeft,
                            child:Text("Top Deals",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                        ),
                        GestureDetector(
                          child: Container(
                              padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              alignment: Alignment.topLeft,
                              child:Text("View All",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.red),)
                          ),
                          onTap:() {
                            Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ProductAll(cityid)));
                          } ,
                        ),
                      ]
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    height:400,
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:product.length>6?6:product.length,
                        itemBuilder: (BuildContext context,int index){
                          return
                            Row(
                              children: [
                                SizedBox(
                                  width:5,
                                ),

                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[

                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          InkWell(
                                            child: Row(
                                              children: [

                                                Container(
                                                  child:Image(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgDiOpXuOp6oEfsOzwj0hYorplXPBx-6EifQ&usqp=CAU')),
                                                ),
                                              ],
                                            ),
                                              onTap:() {
                                                Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(product[index])));
                                              }
                                          ),
                                          //prid=product[index]['_id'],
                                          //Text(product[index]['_id']),
                                          Text(product[index]['productname'],style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),textAlign:TextAlign.center),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Container(
                                            height:30,
                                            color:Colors.green,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:CrossAxisAlignment.center,

                                              children: [
                                                Container(
                                                  height:20,
                                                  child:MaterialButton(
                                                    onPressed:()
                                                    {
                                                    setState(() {
                                                      n[index]++;
                                                    });
                                                    mycart(product[index]['_id'],n[index]);
                                                    print(n);

                                                    },
                                                    child: new Icon(Icons.add, color: Colors.black,size: 15,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                      //gradient: LinearGradient(colors: [Colors.red, Colors.blue])
                                                  ),
                                                ),
                                                 n[index]<=0?
                                                new Text("ADD",
                                                    style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)):
                                                 new Text('${n[index]}',
                                                     style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),

                                                Container(
                                                  height:20,
                                                  child: new MaterialButton(
                                                    onPressed:()
                                                    {
                                                      setState(() {
                                                        n[index]--;
                                                      });
                                                      mycart(product[index]['_id'],n[index]);
                                                    },
                                                    child: new Icon(
                                                        Icons.filter_list,
                                                        color: Colors.black,size: 15,)),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                      //gradient: LinearGradient(colors: [Colors.red, Colors.blue])
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ]
                                    ),
                                  ],
                                ),

                              ],
                            );
                        }
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/home.png'),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),

                  progress?Center(child:CircularProgressIndicator(),):
                  Container(
                    height:100,
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:sellers.length,
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

                                              Text(sellers[index]['seller']['name'],style:TextStyle(fontWeight: FontWeight.bold,),textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,),
                                              SizedBox(
                                                  height:5
                                              ),
                                              Row(
                                                children:[
                                                  //Expanded(flex:10,child: Text("Mobile:",style: TextStyle(fontSize: 16),)),
                                                  Expanded(flex:1,child: Text(sellers[index]['seller']['email'],)),
                                                ],
                                              ),
                                              SizedBox(
                                                height:5,
                                              ),
                                              Row(
                                                  children:[
                                                    Expanded(flex:1,child: Text(sellers[index]['seller']['phone'],)),
                                                  ]
                                              ),
                                              SizedBox(
                                                height:5,
                                              ),
                                              Row(
                                                  children:[
                                                    sellers[index]['deliveryDate']==null?
                                                    Text("No new delivery date set",style:TextStyle(fontWeight: FontWeight.bold))
                                                        :Expanded(flex:1,child: Text("Next delivery by "+d.format(DateTime.parse(sellers[index]['deliveryDate'],))?? " ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                                  ]
                                              ),
                                            ]
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                onTap:() {
                                  // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                                }
                            );
                        }
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  var searchMsg;
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/product/search?city='+cityid;
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
          Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg,cityid))).then((value) {
            //This makes sure the textfield is cleared after page is pushed.
            keyword.clear();
          });
        }

        else{
          searchMsg=json.decode(response.body)['msg'];
          print("no products");

           Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg,cityid))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          });
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
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        //_currentPosition = position;
        lat = position.latitude;
        lon = position.longitude;
        print("latitude:$lat");
        print("longitude:$lon");
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat,lon);
      print(coordinates);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state.text=first.adminArea;
      city.text=first.locality;
      location.text=first.featureName;
      //print("${first.adminArea} : ${first.}");
      print(state.text);
      print(location.text);
      print(city.text);


    } catch (e) {
      print(e);
    }
  }
  Position _currentPosition;
  var lat,lon;
  String _currentAddress;
  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder:(BuildContext context,StateSetter mystate) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              child: new Wrap(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10),
                      //height: MediaQuery.of(context).size.height,
                      child: Text("Where do you want the delivery?",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.indigo),)
                  ),
                  SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 3,
                              //height: 500,
                              child: ListView.builder(
                                  itemCount: deliverylength.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      elevation: 4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [

                                            Row(
                                              children: [
                                                new Checkbox(
                                                  value: a ==
                                                      listprofile['deliveryaddress'][index]['_id'] ? true : false,
                                                  //value:checkValue[index],
                                                  activeColor: Colors.green,
                                                  onChanged: (bool newValue) {
                                                    a =
                                                    listprofile['deliveryaddress'][index]['_id'];
                                                    fulladdress =
                                                    listprofile['deliveryaddress'][index]['fulladdress'];
                                                    st =
                                                    listprofile['deliveryaddress'][index]['state'];
                                                    ci =
                                                    listprofile['deliveryaddress'][index]['city'];
                                                    current =
                                                    listprofile['currentcity']['_id'];
                                                    //print(current);
                                                    //print(ci);
                                                    lon =
                                                    listprofile['deliveryaddress'][index]['location'][0];
                                                    lat =
                                                    listprofile['deliveryaddress'][index]['location'][1];
                                                    mystate(() {
                                                      //checkValue[index] = newValue;
                                                      // a =
                                                      // listprofile['deliveryaddress'][index]['_id'];
                                                      // print(a);
                                                      //ViewData();
                                                    });
                                                  },
                                                ),
                                                Text("Select delivery address"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(listprofile['name'],
                                                  style: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 10
                                            ),
                                            Row(
                                              children: [

                                                Expanded(flex: 1,
                                                    child: Text(
                                                      listprofile['deliveryaddress'][index]['fulladdress'],)),
                                              ],
                                            ),
                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Spacer(),
                                                SizedBox(
                                                    width: 80
                                                ),

                                              ],
                                            ),
                                            Container(
                                              child: FlatButton(
                                                textColor: Colors.green,
                                                child: Text(
                                                  'Update',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                                ),
                                                onPressed: () {
                                                  ViewData();
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                              child: FlatButton(
                                textColor: Colors.green,
                                child: Text(
                                  'Add New Address',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (
                                          context) => new AddressAdd()));
                                },
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      )
                  ),


                ],
              ),

            );

          }
            );
        });
  }
  void ViewData() async {
    var url = Prefmanager.baseurl +'/user/Edit';
    var token = await Prefmanager.getToken();
    Map data={
      "x-auth-token":token,
      "currentcity":current
    };
    print("ggg"+current);
    // print(token);
    //print(data.toString());
    var body =json.encode(data);
    var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      Navigator.of(context).pop(true);
      print("success");
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
  void mycart(productid,quantity) async {
    var url = Prefmanager.baseurl +'/Cart/Addorupdate';
    print("ffgg");
    var token = await Prefmanager.getToken();
    Map cartdata={
      "x-auth-token":token,
      "productid":productid,
      "quantity":quantity
    };
    print(cartdata);
    var body =json.encode(cartdata);
    print("print");
    var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
    print("response");
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
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
  var cname;
  void cartview() async {
    var url = Prefmanager.baseurl +'/Cart/all';
    print("ffgg");
    var token = await Prefmanager.getToken();
    Map cartdata={
      "x-auth-token":token,

    };
    print(cartdata);
    //var body =json.encode(cartdata);
    print("print");
    var response = await http.get(url, headers:{"Content-Type":"application/json", "x-auth-token":token});
    print("response");
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      cname=json.decode(response.body)['data'];
      print("success,added cart");
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