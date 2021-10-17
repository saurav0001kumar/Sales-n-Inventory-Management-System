import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForInventory.dart';
import 'package:sales_n_inventory_flutter_app/others/floatingActionXS.dart';
import 'package:sales_n_inventory_flutter_app/others/items_list.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen4_addNewProduct.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen5_removeExistingProduct.dart';

var inStock = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .where("quantity", isGreaterThan: 0);

var lowStock = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .where("quantity", isLessThan: 5, isGreaterThan: 0);

var emptyStock = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .where("quantity", isLessThanOrEqualTo: 0);

var recentTransaction = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("products")
    .orderBy("date_modified", descending: true)
    .where("date_modified",
        isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 10)));

//
var InStocks = 0, OutStocks = 0;
//

FancyDrawerController _controller;

class InventoryDashboard extends StatefulWidget {
  InventoryDashboard({Key key}) : super(key: key);

  @override
  _InventoryDashboardState createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    //
    setState(() {
      inStock = FirebaseFirestore.instance
          .collection('inventory_db')
          .doc(FirebaseAuth.instance.currentUser.email.toString())
          .collection("products")
          .where("quantity", isGreaterThan: 0);

      lowStock = FirebaseFirestore.instance
          .collection('inventory_db')
          .doc(FirebaseAuth.instance.currentUser.email.toString())
          .collection("products")
          .where("quantity", isLessThan: 5, isGreaterThan: 0);

      emptyStock = FirebaseFirestore.instance
          .collection('inventory_db')
          .doc(FirebaseAuth.instance.currentUser.email.toString())
          .collection("products")
          .where("quantity", isLessThanOrEqualTo: 0);

      recentTransaction = FirebaseFirestore.instance
          .collection('inventory_db')
          .doc(FirebaseAuth.instance.currentUser.email.toString())
          .collection("products")
          .orderBy("date_modified", descending: true)
          .where("date_modified",
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 10)));
    });
    //
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Material(
        child: FancyDrawerWrapper(
          backgroundColor: Colors.deepPurple,
          controller: _controller,
          drawerItems: <Widget>[
            DrawerMenu(),
          ],
          child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,

              //Init Floating Action Bubble

              floatingActionButton: HawkFabMenu(
                  blur: 0,
                  icon: AnimatedIcons.menu_close,
                  fabColor: Colors.deepPurple,
                  iconColor: Colors.white,
                  items: [
                    HawkFabMenuItem(
                      label: 'Add New Product',
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    addNewProductScreen(InStocks + OutStocks)));
                      },
                      icon: Icon(Icons.add_shopping_cart),
                      labelColor: Colors.white,
                      labelBackgroundColor: Colors.blue,
                    ),
                    HawkFabMenuItem(
                      label: "Remove Existing Product",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    removeExistingProductScreen()));
                      },
                      icon: Icon(Icons.remove_shopping_cart),
                    ),
                  ],
                  body: Container()),
              body: Stack(
                children: [
                  bodyForInventoryDashboard(context),
                  AppBarForInventory(
                      "Inventory Dashboard", _controller, context)
                ],
              )),
        ),
      ),
    );
  }

  //App Exit Alert Function
  Future<bool> _onBackButtonPressed() {
    if (_controller.state.toString() == "DrawerState.closed") {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  "Do you really want to exit app?",
                ),
                actions: [
                  FlatButton.icon(
                      onPressed: () => Navigator.pop(context, true),
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Yes",
                      )),
                  FlatButton.icon(
                      onPressed: () => Navigator.pop(context, false),
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      label: Text(
                        "No",
                        style: TextStyle(fontFamily: "productSans"),
                      ))
                ],
              ));
    }
  }
}

Widget bodyForInventoryDashboard(context) {
  return ListView(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.18,
      ),
      //Products IN STOCK
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsList("Products in Stock",
                        Colors.indigo, Colors.lightBlue, inStock)));
          },
          child: Card(
            elevation: 1,
            color: Colors.blue[50],
            child: Container(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      FontAwesome.shopping_bag,
                      size: 70,
                      color: Colors.lightBlue,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream:
                              inStock.snapshots(includeMetadataChanges: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Network Error'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator())
                                  ]);
                            }
                            InStocks = snapshot.data.size;
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: snapshot.hasData
                                      ? snapshot.data.size.toString() + "\n"
                                      : "0\n",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "GoogleSans",
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Products in Stock",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.indigo,
                                            fontFamily: "GoogleSans",
                                            fontSize: 20)),
                                  ]),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
      ),

      // Low Stock
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsList("Low Stock Items",
                        Colors.amber[800], Colors.amber, lowStock)));
          },
          child: Card(
            elevation: 1,
            color: Colors.yellow[50],
            child: Container(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      FontAwesome.shopping_bag,
                      size: 70,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream:
                              lowStock.snapshots(includeMetadataChanges: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Network Error'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator())
                                  ]);
                            }

                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: snapshot.hasData
                                      ? snapshot.data.size.toString() + "\n"
                                      : "0\n",
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: "GoogleSans",
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Low Stock Items",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.amber[800],
                                            fontFamily: "GoogleSans",
                                            fontSize: 20)),
                                  ]),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
      ),

      // Out of Stock
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsList("Items Out of Stock",
                        Colors.red[800], Colors.redAccent, emptyStock)));
          },
          child: Card(
            elevation: 1,
            color: Colors.red[50],
            child: Container(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      FontAwesome.shopping_bag,
                      size: 70,
                      color: Colors.redAccent,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: emptyStock.snapshots(
                              includeMetadataChanges: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Network Error'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator())
                                  ]);
                            }
                            OutStocks = snapshot.data.size;
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: snapshot.hasData
                                      ? snapshot.data.size.toString() + "\n"
                                      : "0\n",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontFamily: "GoogleSans",
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Items Out of Stock",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red[800],
                                            fontFamily: "GoogleSans",
                                            fontSize: 20)),
                                  ]),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
      ),

      // Recent Transaction
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsList("Recently Updated Items",
                        Colors.teal, Colors.green, recentTransaction)));
          },
          child: Card(
            elevation: 1,
            color: Colors.green[50],
            child: Container(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      FlutterIcons.track_changes_mdi,
                      size: 70,
                      color: Colors.green,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: recentTransaction.snapshots(
                              includeMetadataChanges: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Network Error'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator())
                                  ]);
                            }

                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: snapshot.hasData
                                      ? snapshot.data.size.toString() + "\n"
                                      : "0\n",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: "GoogleSans",
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Recently Updated\nItems",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.teal,
                                            fontFamily: "GoogleSans",
                                            fontSize: 20)),
                                  ]),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "*Note:\n",
              style: TextStyle(
                  color: Colors.pink,
                  fontFamily: "GoogleSans",
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text:
                      "To increase/decrease the quantity of existing items in inventory,\nplease click on the respective cards above.",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontFamily: "GoogleSans",
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )
              ]),
        ),
      ),

      SizedBox(
        height: MediaQuery.of(context).size.height * 0.12,
      ),
    ],
  );
}
