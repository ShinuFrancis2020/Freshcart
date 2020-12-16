import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshcart_app/AddressAdd.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/Prefmanager.dart';

class currentcity extends StatefulWidget {

  @override
  _currentcity createState() => _currentcity();
}
class _currentcity extends State<currentcity> {
  var a,fulladdress,current,lat,lon;
  void initState() {
    super.initState();
    profile();
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
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
          child: Container(
            height: 50,
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  children: [
                    new Icon(Icons.add_location_alt),
                    Text.rich(
                      TextSpan(
                        text: ' Deliver to  ',
                        style: TextStyle(fontSize: 16),
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
          onTap: () {
            displayModalBottomSheet(context);
          }
      );
  }

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

}