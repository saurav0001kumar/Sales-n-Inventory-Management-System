import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/authentication/register_page.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen1_home.dart';

class AppBarWithoutDrawer extends StatefulWidget {
  var appTitle;

  var context;

  AppBarWithoutDrawer(this.appTitle, this.context);

  @override
  State<StatefulWidget> createState() {
    var appTitle;
    return AppBarWithoutDrawerState(this.appTitle, this.context);
  }
}

class AppBarWithoutDrawerState extends State<AppBarWithoutDrawer> {
  var appTitle;

  var context;

  AppBarWithoutDrawerState(this.appTitle, this.context);

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
                      Icons.person_add_alt,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    label: Text(
                      'Sign Up',
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
