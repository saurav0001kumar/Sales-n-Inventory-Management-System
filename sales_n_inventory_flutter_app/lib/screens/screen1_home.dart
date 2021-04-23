import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/others/customAppBar.dart';
import 'package:sales_n_inventory_flutter_app/others/image_assets.dart';
import 'package:sales_n_inventory_flutter_app/others/notification.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen2_authType.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';

NotifyAlertState myAlert = NotifyAlertState();
FancyDrawerController _controller;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    if(FirebaseAuth.instance.currentUser!=null)
    myAlert.showNotification();
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
                  bodyForHome(context),
                  customAppBar("Home", _controller)
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

Widget bodyForHome(context) {
  return ListView(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            "Welcome to Sales & Inventory Management System.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 2,
                wordSpacing: 5),
          )),
      ImageAssets.InventoryBuilding(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageAssets.InventoryLoading(),
          ImageAssets.InventoryChecking(),
        ],
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            "You are Good to go.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.amber[700],
                letterSpacing: 1),
          )),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ElevatedButton.icon(
            onPressed: () {
              if(FirebaseAuth.instance.currentUser==null)
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AuthType()));
              else {
                resetFontWeigts();
                fw_inv=FontWeight.bold;
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context) => InventoryDashboard()));
              }
            },
            icon: Icon(
              Feather.check_circle,
              size: 28,
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                " Goto Inventory",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 1),
              ),
            )),
      ),
    ],
  );
}
