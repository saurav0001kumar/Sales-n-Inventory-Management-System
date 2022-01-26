import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/authentication/register_page.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';

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
  void initState() {
    super.initState();
    getCategories();
    selectedCategory = "Default";
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(0)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Group by\nProduct Category :",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    MaterialIcons.sort,
                                    color: Colors.deepPurple,
                                    size: 23,
                                  ),
                                  iconDisabledColor: Colors.grey,
                                  iconEnabledColor: Colors.deepPurple,
                                  isDense: false,
                                  autofocus: false,
                                  borderRadius: BorderRadius.circular(10),
                                  underline: SizedBox(),
                                  isExpanded: false,
                                  alignment: Alignment.center,
                                  focusColor: Colors.white,
                                  value: selectedCategory,
                                  elevation: 10,
                                  style: TextStyle(color: Colors.white),
                                  items: categories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontFamily: 'GoogleSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Product Category",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
        height: MediaQuery.of(context).size.height * 0.18,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                if (!snapshot.hasData)
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("No Data"),
                        ))
                      ]);

                return Column(
                  children: [
                    Card(
                      child: Container(
                        height: 70,
                        child: Column(
                          children: [
                            Text(
                              snapshot.data.size.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.blue),
                            ),
                            Text(
                              "  Registered products in Inventory  ",
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
                    new Column(
                      children: snapshot.data.docs.map((DocumentSnapshot d) {
                        if (selectedCategory == "Default")
                          return Column(
                            children: [
                              Container(),
                              Stack(children: [
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
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
                                                  d
                                                      .data()['price_per_item']
                                                      .toString(),
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
                                        Row(
                                          children: [
                                            Text(
                                              "Vendor Name: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              d
                                                  .data()['vendor_name']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Vendor Email: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              d
                                                  .data()['vendor_email']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Vendor Contact: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              d
                                                  .data()['vendor_phone']
                                                  .toString(),
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
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                        onTap: () {
                                          //to delete product
                                          removeProduct(
                                              d.id, d.data()['item_name']);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.red),
                                        )),
                                  ),
                                ),
                              ]),
                            ],
                          );
                        else if (d.data()['category'] == selectedCategory)
                          return Column(
                            children: [
                              Container(),
                              Stack(
                                children: [
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
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
                                                    d
                                                        .data()[
                                                            'price_per_item']
                                                        .toString(),
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
                                          Row(
                                            children: [
                                              Text(
                                                "Vendor Name: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                d
                                                    .data()['vendor_name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Vendor Email: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                d
                                                    .data()['vendor_email']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Vendor Contact: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                d
                                                    .data()['vendor_phone']
                                                    .toString(),
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
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            //to delete product
                                            removeProduct(
                                                d.id, d.data()['item_name']);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.red),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        else
                          return Container();
                      }).toList(),
                    ),
                  ],
                );
              })),
    ]);
  }

  //to delete existing product
  Future<void> removeProduct(String id, itemName) {
    return inv_db
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .doc(id)
        .delete()
        .then((value) {
      inventory_last_updated_on();
      toastAlert("'${itemName}'" + " removed successfully!", context);
      print(id + " deleted successfully");
    }).catchError((error) => print("Failed to delete product: $error"));
  }

  Future<void> inventory_last_updated_on() {
    return inv_db
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("user_details")
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .update({'inventory_last_updated_on': DateTime.now()})
        .then((value) => print("Inventory Last Date Updated"))
        .catchError((error) => print("Failed to update modified date: $error"));
  }

  void getCategories() {
    var categ = [];
    FirebaseFirestore.instance
        .collection('inventory_db')
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          categories.add(doc['category']);
        });
      });
    });
  }
}
