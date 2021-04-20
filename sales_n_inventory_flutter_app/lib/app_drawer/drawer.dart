import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

bool isDrawerOpen = false;

//Font Weights of Menu Items
FontWeight fw_home = FontWeight.bold;
FontWeight fw_team = FontWeight.normal;
FontWeight fw_inv = FontWeight.normal;
FontWeight fw_about = FontWeight.normal;
FontWeight fw_info = FontWeight.normal;

Widget drawerMenuItems() {
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
            loadDuration: Duration(seconds: 6),
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
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 50),
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
          CustomMenuItems("Home", Icons.home, fw_home),
          CustomMenuItems("Inventory", Icons.inventory, fw_inv),
          CustomMenuItems("Our Team", Icons.people, fw_team),
          CustomMenuItems("About Us", Icons.info, fw_about),
          CustomMenuItems("App Info", Icons.perm_device_info, fw_info)
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Last Updated on :\n2001-01-01 10:15:06 IST",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
      ),
    ],
  );
}

Widget CustomMenuItems(txt, icon, fontWeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
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
