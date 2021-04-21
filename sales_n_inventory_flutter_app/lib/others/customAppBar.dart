import 'package:fancy_drawer/src/controller.dart';
import 'package:flutter/material.dart';

Widget customAppBar(appTitle, FancyDrawerController _controller) {
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
                padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                child: Text(
                  appTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
            ),
          ]),
        ),
      ),
    ],
  );
}
