import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/others/customAppBar.dart';
import 'package:sales_n_inventory_flutter_app/others/image_assets.dart';
import 'package:sales_n_inventory_flutter_app/others/notification.dart';

NotifyAlertState myAlert = NotifyAlertState();

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  FancyDrawerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
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
            drawerMenuItems(),
          ],
          child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                tooltip: "Add New Item",
                elevation: 5,
                splashColor: Colors.pink,
                isExtended: true,
                onPressed: () {},
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Stack(
                children: [bodyForHome(), customAppBar("Home", _controller)],
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

Widget bodyForHome() {
  return ListView(
    children: [
      Padding(
          padding: EdgeInsets.fromLTRB(10, 70, 10, 0),
          child: Text(
            "Welcome to Sales & Inventory Management System.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 2,
                wordSpacing: 3),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageAssets.InventoryLoading(),
          ImageAssets.InventoryChecking(),
        ],
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text(
            "You are Good to go.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.amber[700],
                letterSpacing: 1),
          )),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: ElevatedButton.icon(
            onPressed: () {},
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
