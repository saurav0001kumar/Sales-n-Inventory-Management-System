import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/authentication/signin_page.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarWithoutDrawer.dart';

class AuthType extends StatefulWidget {
  AuthType({Key key}) : super(key: key);

  @override
  _AuthTypeState createState() => _AuthTypeState();
}

class _AuthTypeState extends State<AuthType>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForAuthType(context),
              appBarWithoutDrawer("Sign in", context)
            ],
          )),
    );
  }
}

Widget bodyForAuthType(context) {
  return ListView(
    children: [SignInPage()],
  );
}
