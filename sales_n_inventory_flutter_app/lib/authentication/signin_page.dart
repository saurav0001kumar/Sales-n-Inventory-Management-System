import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_n_inventory_flutter_app/others/image_assets.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var loggedIn;

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        _EmailPasswordForm(),
      ],
    );
  }

  // Code for sign out.
  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(child: ImageAssets.auth()),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign in to continue',
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
                          if (value.isEmpty)
                            return 'Please enter registered email';
                          else if (!value.contains("@"))
                            return "Please enter an email";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          prefixIcon: Icon(
                            FlutterIcons.textbox_password_mco,
                            color: Colors.deepPurple,
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please enter your password';
                          else if (value.length < 6)
                            return "Minimum 6 characters required";
                          return null;
                        },
                        obscureText: true,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await _signInWithEmailAndPassword();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${user.email}'),
        ),
      );
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NotifyAlert(_auth.currentUser)));
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
}
