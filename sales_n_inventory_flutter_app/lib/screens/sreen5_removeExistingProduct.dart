import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/authentication/register_page.dart';

var Stocks = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .orderBy('item_name');

class removeExistingProductScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => removeExistingProductScreenState();
}

class removeExistingProductScreenState
    extends State<removeExistingProductScreen> {
  var appTitle = "Remove Existing Products";

  @override
  void initState(){
    super.initState();
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
              bodyForRemoveExistingProductScreen(context),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 35, 5, 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.leak_remove,
                              color: Colors.deepPurple,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget bodyForRemoveExistingProductScreen(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: Stocks.snapshots(includeMetadataChanges: true),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Network Error'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator.adaptive())
                      ]);
                }
                if (!snapshot.hasData) return Text("Network Error!");

                return new Column(
                  children: snapshot.data.docs.map((DocumentSnapshot d) {
                    return Column(
                      children: [
                        Container(),
                        Card(
                          elevation: 1,
                          color: d.data()['quantity'] > 5
                              ? Colors.lightBlue[50]
                              : (d.data()['quantity'] <= 0
                                  ? Colors.red[50]
                                  : Colors.amber[50]),
                          child: ListTile(
                            title: Text(
                              d.data()['item_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            trailing:
                                GestureDetector(
                                    onTap: (){},//inventory_last_updated_on,
                                    child: Icon(Icons.delete_forever, color: Colors.red)),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Category: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      d.data()['category'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Brand: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      d.data()['brand'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rate (INR): ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "₹ " +
                                          d.data()['price_per_item'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Quantity: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      d.data()['quantity'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              })),
    ]);
  }

  // Future<void> inventory_last_updated_on() {
  //   return inv_db
  //       .doc(FirebaseAuth.instance.currentUser.email.toString())
  //       .update({'inventory_last_updated_on': DateTime.now()})
  //       .then((value) => print("Inventory Last Date Updated"))
  //       .catchError((error) => print("Failed to update modified date: $error"));
  // }
}
