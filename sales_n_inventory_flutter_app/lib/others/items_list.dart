import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForList.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen6_ItemEdit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'otherFunctions.dart';

class ItemsList extends StatefulWidget {
  var appBarTitle;

  var color1;

  var color2;

  var stock;

  var stockCounts;

  ItemsList(
      this.appBarTitle, this.color1, this.color2, this.stock, this.stockCounts);

  @override
  State<StatefulWidget> createState() => ItemsListState(
      this.appBarTitle, this.color1, this.color2, this.stock, this.stockCounts);
}

class ItemsListState extends State<ItemsList> {
  var color1;

  var appBarTitle;

  var color2;

  var stock;

  var stockCounts;

  ItemsListState(
      this.appBarTitle, this.color1, this.color2, this.stock, this.stockCounts);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
    selectedCategory = "Default";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                bodyForItemsList(context),
                Column(
                  children: [
                    AppBarForList(appBarTitle, context, color1),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
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
      ),
    );
  }

  Widget bodyForItemsList(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.18,
      ),
      Column(children: [
        StreamBuilder<QuerySnapshot>(
            stream: stockCounts.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Something went wrong'),
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: CircularProgressIndicator())]);
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

              return Card(
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      Text(
                        snapshot.data.size.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: color2),
                      ),
                      Text(
                        "  " + appBarTitle + "  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        appBarTitle == "Products in Stock"
                            ? "Items with quantity > 0"
                            : (appBarTitle == "Low Stock Items"
                                ? "  Items with quantity > 0 & <= 5  "
                                : (appBarTitle == "Items Out of Stock"
                                    ? "Items with quantity = 0"
                                    : "Items updated in last 30 days")),
                        style: TextStyle(
                            color: color2[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            }),
        StreamBuilder<QuerySnapshot>(
            stream: stock.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Something went wrong'),
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: CircularProgressIndicator())]);
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
                  SizedBox(
                    height: 10,
                  ),
                  new Column(
                    children: snapshot.data.docs.map((DocumentSnapshot d) {
                      if (((appBarTitle == "Products in Stock" &&
                                  d.data()['quantity'] > 0) ||
                              (appBarTitle == "Low Stock Items" &&
                                  (d.data()['quantity'] > 0 &&
                                      d.data()['quantity'] <= 5)) ||
                              (appBarTitle == "Items Out of Stock" &&
                                  d.data()['quantity'] <= 0) ||
                              (appBarTitle == "Recently Updated Items")) &&
                          selectedCategory == "Default")
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Stack(
                            children: [
                              Card(
                                elevation: 1,
                                color: d.data()['quantity'] > 5
                                    ? Colors.lightBlue[50]
                                    : (d.data()['quantity'] <= 0
                                        ? Colors.red[50]
                                        : Colors.amber[50]),
                                shadowColor: d.data()['quantity'] > 5
                                    ? Colors.lightBlue
                                    : (d.data()['quantity'] <= 0
                                        ? Colors.red
                                        : Colors.amber),
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
                                      if (appBarTitle ==
                                          "Recently Updated Items")
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity updated: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              d.data()['recently_added_items'] >=
                                                      0
                                                  ? "+" +
                                                      d
                                                          .data()[
                                                              'recently_added_items']
                                                          .toString()
                                                  : d
                                                      .data()[
                                                          'recently_added_items']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: d.data()[
                                                              'recently_added_items'] >=
                                                          0
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          ],
                                        ),
                                      if (appBarTitle ==
                                          "Recently Updated Items")
                                        Row(
                                          children: [
                                            Text(
                                              "Modified date: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    DateTime.fromMicrosecondsSinceEpoch(d
                                                            .data()[
                                                                'date_modified']
                                                            .microsecondsSinceEpoch)
                                                        .toString()
                                                        .split(" ")[0],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateTime.fromMicrosecondsSinceEpoch(d
                                                                .data()[
                                                                    'date_modified']
                                                                .microsecondsSinceEpoch)
                                                            .toString()
                                                            .split(" ")[1]
                                                            .split(".")[0] +
                                                        " (IST)",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                            "" +
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
                                            "" +
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
                                            "" +
                                                d
                                                    .data()['vendor_phone']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      //Buttons: call, sms, email
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _makePhoneCall(
                                                  d.data()['vendor_phone']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 1,
                                                backgroundColor: Colors.white,
                                                label: Icon(
                                                  Icons.phone,
                                                  color: color1,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _makePhoneSMS(
                                                  d.data()['vendor_phone']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 1,
                                                backgroundColor: Colors.white,
                                                label: Icon(
                                                  Icons.sms,
                                                  color: color1,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _sendEmail(
                                                  "Hello, I want to request for item " +
                                                      "'" +
                                                      d.data()['item_name'] +
                                                      "' of brand " +
                                                      "'" +
                                                      d.data()['brand'] +
                                                      "'. *Required Item QUANTITY = 50 ",
                                                  "Order Request for item '" +
                                                      d.data()['item_name'] +
                                                      "'.",
                                                  d.data()['vendor_email']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 2,
                                                backgroundColor: Colors.white,
                                                label: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.shopping_cart,
                                                      color: color1,
                                                      size: 33,
                                                    ),
                                                    Text("Order Now",
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    onTap: () {
                                      //to edit item
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editItem(d.data(), d.id)));
                                    },
                                    child: Chip(
                                      elevation: 1,
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.deepPurple,
                                      label: Text(
                                        "Edit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        );
                      else if (((appBarTitle == "Products in Stock" &&
                                  d.data()['quantity'] > 0) ||
                              (appBarTitle == "Low Stock Items" &&
                                  (d.data()['quantity'] > 0 &&
                                      d.data()['quantity'] <= 5)) ||
                              (appBarTitle == "Items Out of Stock" &&
                                  d.data()['quantity'] <= 0) ||
                              (appBarTitle == "Recently Updated Items")) &&
                          d.data()['category'] == selectedCategory)
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Stack(
                            children: [
                              Card(
                                elevation: 1,
                                color: d.data()['quantity'] > 5
                                    ? Colors.lightBlue[50]
                                    : (d.data()['quantity'] <= 0
                                        ? Colors.red[50]
                                        : Colors.amber[50]),
                                shadowColor: d.data()['quantity'] > 5
                                    ? Colors.lightBlue
                                    : (d.data()['quantity'] <= 0
                                        ? Colors.red
                                        : Colors.amber),
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
                                      if (appBarTitle ==
                                          "Recently Updated Items")
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity updated: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              d.data()['recently_added_items'] >=
                                                      0
                                                  ? "+" +
                                                      d
                                                          .data()[
                                                              'recently_added_items']
                                                          .toString()
                                                  : d
                                                      .data()[
                                                          'recently_added_items']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: d.data()[
                                                              'recently_added_items'] >=
                                                          0
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          ],
                                        ),
                                      if (appBarTitle ==
                                          "Recently Updated Items")
                                        Row(
                                          children: [
                                            Text(
                                              "Modified date: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    DateTime.fromMicrosecondsSinceEpoch(d
                                                            .data()[
                                                                'date_modified']
                                                            .microsecondsSinceEpoch)
                                                        .toString()
                                                        .split(" ")[0],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateTime.fromMicrosecondsSinceEpoch(d
                                                                .data()[
                                                                    'date_modified']
                                                                .microsecondsSinceEpoch)
                                                            .toString()
                                                            .split(" ")[1]
                                                            .split(".")[0] +
                                                        " (IST)",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                            "" +
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
                                            "" +
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
                                            "" +
                                                d
                                                    .data()['vendor_phone']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      //Buttons: call, sms, email
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _makePhoneCall(
                                                  d.data()['vendor_phone']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 1,
                                                backgroundColor: Colors.white,
                                                label: Icon(
                                                  Icons.phone,
                                                  color: color1,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _makePhoneSMS(
                                                  d.data()['vendor_phone']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 1,
                                                backgroundColor: Colors.white,
                                                label: Icon(
                                                  Icons.sms,
                                                  color: color1,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _sendEmail(
                                                  "Hello, I want to request for item " +
                                                      "'" +
                                                      d.data()['item_name'] +
                                                      "' of brand " +
                                                      "'" +
                                                      d.data()['brand'] +
                                                      "'. *Required Item QUANTITY = 50 ",
                                                  "Order Request for item '" +
                                                      d.data()['item_name'] +
                                                      "'.",
                                                  d.data()['vendor_email']);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Chip(
                                                elevation: 2,
                                                backgroundColor: Colors.white,
                                                label: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.shopping_cart,
                                                      color: color1,
                                                      size: 30,
                                                    ),
                                                    Text("Order Now",
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    onTap: () {
                                      //to edit item
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editItem(d.data(), d.id)));
                                    },
                                    child: Chip(
                                      elevation: 1,
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.deepPurple,
                                      label: Text(
                                        "Edit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        );
                      else
                        return Container();
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            }),
      ]),
    ]);
  }

  //Back Button Function
  Future<bool> _onBackButtonPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => InventoryDashboard()));
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
}
