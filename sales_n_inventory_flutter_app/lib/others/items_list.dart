import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForList.dart';

//
CollectionReference inv_db = FirebaseFirestore.instance.collection('inventory_db');
//

class ItemsList extends StatefulWidget {
  var appBarTitle;

  var color1;

  ItemsList( this.appBarTitle, this.color1);

  @override
  State<StatefulWidget> createState() => ItemsListState(this.appBarTitle, this.color1);
}

class ItemsListState extends State<ItemsList> {
  var color1;

  var appBarTitle;

  ItemsListState(this.appBarTitle, this.color1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForItemsList(context),
              AppBarForList(appBarTitle, context, color1)
            ],
          )),
    );
  }

  Widget bodyForItemsList(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Column(children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


              ],
            ),
          ),
        ),
      ]),
    ]);
  }


}
