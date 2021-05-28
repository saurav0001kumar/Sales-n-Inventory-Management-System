import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';

class AppBarForList extends StatefulWidget {
  var appTitle;

  var context;

  var color1;

  AppBarForList(this.appTitle, this.context, this.color1);

  @override
  State<StatefulWidget> createState() {
    var appTitle;
    return AppBarForListState(this.appTitle, this.context, this.color1);
  }
}

class AppBarForListState extends State<AppBarForList> {
  var appTitle;

  var context;

  var color1;

  AppBarForListState(this.appTitle, this.context, this.color1);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => InventoryDashboard()));
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                  child: Text(
                    appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: color1, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
