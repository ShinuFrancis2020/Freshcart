import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_app/AdddeliveryAddress.dart';
import 'package:freshcart_app/Prefmanager.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
class EditDeliveryaddress extends StatefulWidget
{
  final delid,fulladdress,lon,lat;
  EditDeliveryaddress(this.delid,this.fulladdress,this.lon,this.lat);
  @override
  _EditDeliveryaddress  createState() =>_EditDeliveryaddress();
}
class _EditDeliveryaddress  extends State <EditDeliveryaddress > {
  Completer<GoogleMapController> _controller = Completer();
    CameraPosition _kGooglePlex ;
  CameraPosition _kLake ;
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  LatLng postion ;
  var state,city,fulladdress,lat,lon;

  @override
  void initState() {
    super.initState();
    setInitalValues();
    print(lat);

  }
  setInitalValues() {
    fulladdress=widget.fulladdress;
    lon = widget.lon;
    lat = widget.lat;
    print(lat);
    print(lon);
    _markers.add(Marker(
        position:LatLng(lat,lon),
        markerId: MarkerId("selected-location"),
        onTap: (){
          //CommonFunction.openMap(postion);
        }
    ));

    _kGooglePlex = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 14.4746,
    );

    loading = false;
      setState(() {});
  }
  bool loading = true;
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
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
      state=first.adminArea;
      city=first.locality;
      fulladdress=first.addressLine;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat,lon),
          zoom: 17.151926040649414);
      loading = false;
      if(mounted)
        setState(() {});
    } catch (e) {
      print(e);
    }
  }
  _getAddressFromLatLon() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat,lon);
      print(coordinates);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state=first.adminArea;
      city=first.locality;
      fulladdress=first.addressLine;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat,lon),
          zoom: 17.151926040649414);
      loading = false;
      if(mounted)
        setState(() {});
    } catch (e) {
      print(e);
    }

  }
  Position _currentPosition;
  String _currentAddress;
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation:0.0,
          title: Text("Edit Delivery Address"),
        ),
        body: loading ? Center(child: CircularProgressIndicator(),):SafeArea(
            child: SingleChildScrollView(
              child: //progress?Center( child: CircularProgressIndicator(),):
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          markers:_markers,
                          onTap:(latlon){
                            postion = latlon;
                            onMapTapFun(latlon);
                       setState(() {
               _markers.add(Marker(
                position:postion,
                markerId: MarkerId("selected-location"),
               onTap: (){
        //CommonFunction.openMap(postion);
      }
  ));
});
                          } ,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                      SizedBox(
                          height:20
                      ),
                      new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [

                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Expanded(flex:0,child: Text(fulladdress)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height:10
                      ),
                      FlatButton(
                        height: 50,
                        minWidth:MediaQuery.of(context).size.width /1,
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Update'),
                        onPressed: () {
                          // if(checkValue==true)
                          senddata();
                        },
                      ),
                    ]
                ),
              ),
            ))
    );
  }
  void onMapTapFun(latlon) {
    print("gggh");
    lat=latlon.latitude;
    print(lat);
    lon=latlon.longitude;
    print(lon);
    setState(() {
      _getAddressFromLatLon();
    });
  }
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/deliveryaddress/edit';
      var token=await Prefmanager.getToken();
      Map data={
        'x-auth-token': token,
        'id': widget.delid,
        'state':state,
        'city':city,
        'fulladdress':fulladdress,
        'lat': lon,
        'lon': lat,
      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","x-auth-token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new AdddeliveryAddress()));
        }

        else{
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
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

