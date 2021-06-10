import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForList.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';

//
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
    .where("date_modified",
    isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 10)));
//

class ItemsList extends StatefulWidget {
  var appBarTitle;

  var color1;

  var color2;

  ItemsList(this.appBarTitle, this.color1, this.color2);

  @override
  State<StatefulWidget> createState() =>
      ItemsListState(this.appBarTitle, this.color1, this.color2);
}

class ItemsListState extends State<ItemsList> {
  var color1;

  var appBarTitle;

  var color2;

  ItemsListState(this.appBarTitle, this.color1, this.color2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        height: MediaQuery
            .of(context)
            .size
            .height * 0.1,
      ),
      Column(children: [

        StreamBuilder<QuerySnapshot>(
            stream: inStock.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Padding(
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
                    children: [Center(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("No Data"),
                    ))]);

              return new Column(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Card(
                      child: Column(
                        children: [



                        ],
                      ),
                    ),
                  );
                }).toList(),
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
}
