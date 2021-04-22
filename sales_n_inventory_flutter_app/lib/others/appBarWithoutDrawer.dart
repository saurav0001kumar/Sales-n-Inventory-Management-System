import 'package:flutter/material.dart';

Widget appBarWithoutDrawer(appTitle, context) {
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
                  Navigator.pop(context);
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
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage());
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
