import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/others/appBarForSignUp.dart';
import 'package:sales_n_inventory_flutter_app/others/image_assets.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// Create a CollectionReference that references the firestore collection
CollectionReference inv_db = FirebaseFirestore.instance.collection('inventory_db');
//

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameTC = TextEditingController();
  final TextEditingController _phoneTC = TextEditingController();
  final TextEditingController _shop_nameTC = TextEditingController();

  //registration details
  String name, phone, shop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForSignUp(context),
              AppBarForSignUp("Sign Up", context)
            ],
          )),
    );
  }

  Widget bodyForSignUp(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Column(children: [
        Form(
            key: _formKey,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(child: ImageAssets.authLock()),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Sign Up Now to Get started',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty || (!value.contains("@"))) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password (use atleast 6 characters)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(
                          FlutterIcons.textbox_password_mco,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6)
                          return "Minimum 6 characters required";
                        return null;
                      },
                      obscureText: true,
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    ///////////////////////////////////////--------->>> registration details
                    TextFormField(
                      controller: _nameTC,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(
                          FlutterIcons.rename_box_mco,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      controller: _phoneTC,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(
                          FlutterIcons.phone_call_fea,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length < 10)
                          return "Invalid phone number";
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      controller: _shop_nameTC,
                      decoration: InputDecoration(
                        labelText: 'Shop Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(
                          FlutterIcons.shop_ent,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter shop name';
                        }
                        return null;
                      },
                    ),

                    //////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.person_add),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await _register();
                          }
                        },
                        label: Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ]),
    ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return inv_db.doc(_emailController.text).collection("user_details")
        .add({
          'email': _emailController.text,
          'name': _nameTC.text,
          'phone': _phoneTC.text,
          'shop_name': _shop_nameTC.text,
        })
        .then((value) => print("User Added"))
        .catchError((error) => toastAlert("Sign Up Failed! : $error", context));
  }

  // Code for registration.
  Future<void> _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      //add user data in db
      addUser();
      setState(() {
        toastAlert("Successfully Registered !", context);
        resetRegistrationFields();
      });
    } else {}
  }

  //Reset All Fields
  void resetRegistrationFields() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _nameTC.clear();
      _phoneTC.clear();
      _shop_nameTC.clear();
    });
  }
}
