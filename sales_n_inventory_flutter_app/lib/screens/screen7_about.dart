import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/others/customAppBar.dart';
import 'package:sales_n_inventory_flutter_app/others/image_assets.dart';
import 'package:url_launcher/url_launcher.dart';

//License Summary as mentioned in the license -->

var paragraph1 =
    "This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.";

var paragraph2 =
    "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.";

var paragraph3 =
    "You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.";

var paragraph = [paragraph1, paragraph2, paragraph3];
//---------------------------------------------->

FancyDrawerController _controller;

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });

    setState(() {});
  }

  @override
  void dispose() {
    //_controller.dispose();
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
                  customAppBar("About", _controller)
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

  Widget bodyForHome(context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ImageAssets.appIcon(),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              "Sales & Inventory Management System.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 2,
                  wordSpacing: 5),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
            child: Text(
              "Made management of small to medium-sized shops easier.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                  letterSpacing: 1),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Chip(
              shadowColor: Colors.amberAccent,
              backgroundColor: Colors.white,
              elevation: 2,
              label: Text(
                "App Version: 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber[700],
                    letterSpacing: 1),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 12.0, top: 0.0, bottom: 20),
          child: Center(
            child: Text(
              "Copyright © 2021",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blue[600],
              ),
            ),
          ),
        ),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
            child: Center(
              child: Text(
                "${paragraph[i]}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.blueGrey[500],
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 12.0, top: 15, bottom: 25),
          child: Center(
            child: OutlineButton(
              onPressed: () {
                _launchAnyURL(
                    "https://raw.githubusercontent.com/saurav0001kumar/Sales-n-Inventory-Management-System/main/LICENSE");
              },
              child: Text(
                "View Full LICENSE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.blue[600],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//License URL Launcher
  _launchAnyURL(var getUrl) async {
    var url = getUrl;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
        enableDomStorage: true,
        forceSafariVC: true,
        universalLinksOnly: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
