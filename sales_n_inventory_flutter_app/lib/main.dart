import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'others/notification.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sales & Inventory Management',
        theme: ThemeData(
            fontFamily: 'GoogleSans',
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent),
        home: NotifyAlert());
  }
}
