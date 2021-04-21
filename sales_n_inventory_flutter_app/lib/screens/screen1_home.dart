import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
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
            appBar: AppBar(
              elevation: 4.0,
              title: Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  _controller.toggle();
                },
              ),
            ),
            body: Column(
              children: [Text("Body")],
            ),
          ),
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
