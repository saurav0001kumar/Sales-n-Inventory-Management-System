import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen1_home.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen2_authType.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen3_inventoryHome.dart';

bool isDrawerOpen = false;

var userDetails = FirebaseFirestore.instance
    .collection('inventory_db')
    .doc(FirebaseAuth.instance.currentUser.email.toString())
    .collection("user_details");

//Font Weights of Menu Items
FontWeight fw_home = FontWeight.bold;
FontWeight fw_inv = FontWeight.normal;
FontWeight fw_about = FontWeight.normal;

void resetFontWeigts() {
  fw_home = FontWeight.normal;
  fw_inv = FontWeight.normal;
  fw_about = FontWeight.normal;
}

Widget drawerMenuItems(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 10, 15),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextLiquidFill(
            text: "Sales &\nInventory\nManagement\nSystem".toUpperCase(),
            boxBackgroundColor: Colors.deepPurple,
            waveColor: Colors.lightBlueAccent,
            waveDuration: Duration(seconds: 2),
            loadDuration: Duration(seconds: 3),
            loadUntil: 0.999,
            boxHeight: 150,
            boxWidth: 200,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 35),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.blueGrey[200],
              size: 45,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              FlutterIcons.dropbox_ant,
              color: Colors.amber,
              size: 50,
            ),
          ],
        ),
      ),
      Column(
        children: [
          GestureDetector(
              onTap: () {
                resetFontWeigts();
                fw_home = FontWeight.bold;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: CustomMenuItems("Home", Icons.home, fw_home)),
          GestureDetector(
              onTap: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  resetFontWeigts();
                  fw_inv = FontWeight.bold;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InventoryDashboard()));
                } else {
                  resetFontWeigts();
                  fw_home = FontWeight.bold;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthType()));
                }
              },
              child: CustomMenuItems("Inventory", Icons.inventory, fw_inv)),
          CustomMenuItems("About", Icons.info, fw_about),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                FirebaseAuth.instance.currentUser == null
                    ? "Inventory".toUpperCase() +
                        "\nLast Updated on :\n[ Sign in to see last update. ]"
                    : "Inventory".toUpperCase() + "\nLast Updated on :",
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (FirebaseAuth.instance.currentUser != null)
                StreamBuilder<QuerySnapshot>(
                    stream: userDetails.snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Network Error'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: CircularProgressIndicator.adaptive())
                            ]);
                      }
                      if (!snapshot.hasData) return Text("No Data");

                      return new Column(
                        children: snapshot.data.docs.map((DocumentSnapshot d) {
                          return Column(
                            children: [
                              Text(
                                DateTime.fromMicrosecondsSinceEpoch(d
                                        .data()['inventory_last_updated_on']
                                        .microsecondsSinceEpoch)
                                    .toString()
                                    .split(".")[0],
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }),
            ]),
      ),
    ],
  );
}

Widget CustomMenuItems(txt, icon, fontWeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          txt,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: fontWeight,
          ),
        ),
      ],
    ),
  );
}
