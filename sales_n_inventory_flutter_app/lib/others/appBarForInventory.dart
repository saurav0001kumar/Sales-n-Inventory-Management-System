import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen2_authType.dart';

class AppBarForInventory extends StatefulWidget {
  var appTitle;

  var context;

  FancyDrawerController _controller;

  AppBarForInventory(this.appTitle, this._controller, this.context);

  @override
  State<StatefulWidget> createState() {
    var appTitle;
    return AppBarForInventoryState(
        this.appTitle, this._controller, this.context);
  }
}

class AppBarForInventoryState extends State<AppBarForInventory> {
  var appTitle;

  var context;

  var _controller;

  AppBarForInventoryState(this.appTitle, this._controller, this.context);

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
                padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
                child: GestureDetector(
                  child: Icon(
                    Icons.menu_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  onTap: () {
                    _controller.toggle();
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 35, 10, 0),
                  child: Text(
                    appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.purple, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 35, 5, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      AntDesign.logout,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      resetFontWeigts();
                      fw_home = FontWeight.bold;

                      if (FirebaseAuth.instance.currentUser == null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('You have Signed Out successfully!'),
                        ));
                        //ScaffoldMessenger.showSnackBar
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthType()));
                      }
                    },
                    label: Text(
                      'SignOut',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: Chip(
                backgroundColor: Colors.yellow[100],
                elevation: 3,
                onDeleted: () {},
                deleteIcon: Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  size: 18,
                  color: Colors.green,
                ),
                label: RichText(
                  text: TextSpan(
                      text: "Welcome, ",
                      style: TextStyle(
                          color: Colors.black, fontFamily: "GoogleSans"),
                      children: <TextSpan>[
                        TextSpan(
                            text: FirebaseAuth.instance.currentUser.email
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.indigo,
                                fontFamily: "GoogleSans")),
                      ]),
                ),
              ),
            )),
      ],
    );
  }
}
