import 'package:flutter/material.dart';
import 'package:freshcart_app/PhoneVerify.dart';
class FirstPage extends StatefulWidget
{
  @override
  _FirstPage  createState() =>_FirstPage ();
}
class _FirstPage  extends State <FirstPage > {
  var phone;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation:0.0,
        title: Text("Verification"),

      ),
      body:SafeArea(
        child: SingleChildScrollView(
          child: //progress?Center( child: CircularProgressIndicator(),):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  validator: (value) {
                    //Pattern pattern = r'^[a-zA-Z]';
                    //RegExp regex = new RegExp(pattern);
                    if (value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    // else if (!regex.hasMatch(value))
                    //   return 'Invalid Username';
                    // else
                    //   null;
                  },
                  onSaved: (v) {
                    phone = v;
                  },
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                  ),
                ),
                SizedBox(
                    height:350
                ),
                FlatButton(
                  height: 50,
                  minWidth:MediaQuery.of(context).size.width /1,
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text('Send OTP'),
                  onPressed: () {
                    //Navigator.push(
                       // context, new MaterialPageRoute(
                       // builder: (context) => new PhoneVerify()));
                  },
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}