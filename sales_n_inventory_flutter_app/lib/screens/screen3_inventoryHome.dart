import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForInventory.dart';
import 'package:sales_n_inventory_flutter_app/others/notification.dart';

NotifyAlertState myAlert = NotifyAlertState();
FancyDrawerController _controller;

class InventoryDashboard extends StatefulWidget {
  InventoryDashboard({Key key}) : super(key: key);

  @override
  _InventoryDashboardState createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    if (FirebaseAuth.instance.currentUser != null) myAlert.showNotification();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            drawerMenuItems(context),
          ],
          child: Scaffold(
              backgroundColor: Colors.white,
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
        height: MediaQuery.of(context).size.height * 0.20,
      ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
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
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "1520\n",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: "GoogleSans",
                              fontSize: 37,
                            fontWeight: FontWeight.bold
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Products in Stock",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo,
                                    fontFamily: "GoogleSans",
                                    fontSize: 20)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: Card(
          elevation: 1,
          color:Colors.yellow[50],
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
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "19\n",
                        style: TextStyle(
                            color: Colors.amber,
                            fontFamily: "GoogleSans",
                            fontSize: 37,
                            fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Low Stock Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber[800],
                                  fontFamily: "GoogleSans",
                                  fontSize: 20)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
