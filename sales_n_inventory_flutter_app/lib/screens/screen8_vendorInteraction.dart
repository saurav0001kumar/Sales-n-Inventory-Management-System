import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';
import 'package:url_launcher/url_launcher.dart';

var Stocks = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .orderBy('item_name');

class VendorInteraction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VendorInteractionState();
}

class VendorInteractionState extends State<VendorInteraction> {
  var appTitle = "Vendor/Manufacturer Interaction";

  @override
  void initState() {
    super.initState();
    getVendors();
    setState(() {
      Stocks = FirebaseFirestore.instance
          .collection('inventory_db')
          .doc(FirebaseAuth.instance.currentUser.email.toString())
          .collection("products")
          .orderBy('item_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForVendorInteraction(context),
              Column(
                children: [
                  Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                          child: GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 28,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                            child: Text(
                              appTitle,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 18),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget bodyForVendorInteraction(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            children: [
              Card(
                child: Container(
                  height: 70,
                  child: Column(
                    children: [
                      Text(
                        (vendors.length - 1).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.purple),
                      ),
                      Text(
                        "  Registered Vendors/Manufacturers ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: ListTile(

                      leading: CircleAvatar(radius:30,child: Icon(Icons.person, size: 30,),),
                    ),
                  ),
                ),
              )
            ],
          ))
    ]);
  }

  void getVendors() {
    FirebaseFirestore.instance
        .collection('inventory_db')
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          vendors.add(doc['vendor_name']);
        });
      });
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _makePhoneSMS(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _sendEmail(String email, String subject, String msg){

    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );

    launch(emailLaunchUri.toString());

  }

}
