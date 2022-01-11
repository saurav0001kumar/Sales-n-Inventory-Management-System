import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForList.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen6_ItemEdit.dart';

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
                          child: Card(
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              trailing: GestureDetector(
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
                                  if (appBarTitle == "Recently Updated Items")
                                    Row(
                                      children: [
                                        Text(
                                          "Quantity updated: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          d.data()['recently_added_items'] >= 0
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
                                  if (appBarTitle == "Recently Updated Items")
                                    Row(
                                      children: [
                                        Text(
                                          "Modified date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateTime.fromMicrosecondsSinceEpoch(d
                                                        .data()['date_modified']
                                                        .microsecondsSinceEpoch)
                                                    .toString()
                                                    .split(" ")[0],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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
                          child: Card(
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              trailing: GestureDetector(
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
                                  if (appBarTitle == "Recently Updated Items")
                                    Row(
                                      children: [
                                        Text(
                                          "Quantity updated: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          d.data()['recently_added_items'] >= 0
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
                                  if (appBarTitle == "Recently Updated Items")
                                    Row(
                                      children: [
                                        Text(
                                          "Modified date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateTime.fromMicrosecondsSinceEpoch(d
                                                        .data()['date_modified']
                                                        .microsecondsSinceEpoch)
                                                    .toString()
                                                    .split(" ")[0],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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
}
