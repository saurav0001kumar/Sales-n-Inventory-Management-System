import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen1_home.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen2_authType.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';

class AppBarForSignUp extends StatefulWidget {
  var appTitle;

  var context;

  AppBarForSignUp(this.appTitle, this.context);

  @override
  State<StatefulWidget> createState() {
    var appTitle;
    return AppBarForSignUpState(this.appTitle, this.context);
  }
}

class AppBarForSignUpState extends State<AppBarForSignUp> {
  var appTitle;

  var context;

  AppBarForSignUpState(this.appTitle, this.context);

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
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                  child: Text(
                    appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.purple, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 35, 5, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if(FirebaseAuth.instance.currentUser==null)
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => AuthType()));
                      else {
                        DrawerMenuState.resetFontWeigts();
                        fw_inv=FontWeight.bold;
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(
                            builder: (context) => InventoryDashboard()));
                      }
                    },
                    label: Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
