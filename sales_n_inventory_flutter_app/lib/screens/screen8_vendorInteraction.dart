import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        (vendors.length).toString(),
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
              for (int i = 0; i < vendors.length; i++)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 0.5,
                    color: Colors.blue[50],
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          vendors[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.deepPurple),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(vendor_phones[i]);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Chip(
                                      elevation: 1,
                                      backgroundColor: Colors.white,
                                      label: Icon(
                                        Icons.phone,
                                        color: Colors.indigo,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _makePhoneSMS(vendor_phones[i]);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Chip(
                                      elevation: 1,
                                      backgroundColor: Colors.white,
                                      label: Icon(
                                        Icons.message,
                                        color: Colors.indigo,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _sendEmail("", "", vendor_emails[i]);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Chip(
                                      elevation: 1,
                                      backgroundColor: Colors.white,
                                      label: Icon(
                                        Icons.mail,
                                        color: Colors.indigo,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ))
    ]);
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

  Future<void> _sendEmail(
      String email_body, String email_subject, email_ID) async {
    final Email email = Email(
      body: email_body,
      subject: email_subject,
      recipients: [email_ID],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Success! Check your Mailbox for sent items.';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  //Method for displaying Vendors List

  void getVendors() {
    FirebaseFirestore.instance
        .collection('inventory_db')
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          if (!vendors.contains(doc['vendor_name'].toString())) {
            if (doc['vendor_name'] != null) {
              vendors.add(doc['vendor_name'].toString());
              vendor_phones.add(doc['vendor_phone'].toString());
              vendor_emails.add(doc['vendor_email'].toString());
            }
          }
        });
      });
    });
  }
}
