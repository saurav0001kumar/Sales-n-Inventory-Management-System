import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';


// Create a CollectionReference that references the firestore collection
CollectionReference inv_db =
    FirebaseFirestore.instance.collection('inventory_db');
//

class addNewProductScreen extends StatefulWidget {
  var totalProducts;

  addNewProductScreen(this.totalProducts);

  @override
  State<StatefulWidget> createState() =>
      addNewProductScreenState(this.totalProducts);
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

var item_nameTC = new TextEditingController();
var categoryTC = new TextEditingController();
var brandTC = new TextEditingController();
var pricePerItemTC = new TextEditingController();
var quantityTC = new TextEditingController();

var date_modified;
var recently_added_items = 0;

class addNewProductScreenState extends State<addNewProductScreen> {
  var appTitle = "Add New product";

  var totalProducts;

  addNewProductScreenState(this.totalProducts);

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    print(totalProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForAddNewProductScreen(context),
              Column(
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
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 18),
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
                            child: Icon(
                              Icons.post_add_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget bodyForAddNewProductScreen(context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          SizedBox(
            height: MediaQuery.of(context).devicePixelRatio * 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: item_nameTC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '*';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: categoryTC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Product Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '*';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: brandTC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Product Brand',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '*';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: pricePerItemTC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price per item (INR)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '*';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: quantityTC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '*';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10),
            child: ElevatedButton.icon(
              label: Text("Add New"),
              icon: Icon(
                Icons.add_circle_outline,
                size: 30,
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await _addNewProduct();
                }
              },
            ),
          )
        ]));
  }

  Future<void> _addNewProduct() {
    // Call the user's CollectionReference to add a new user
    return inv_db
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .add({
      'item_name': item_nameTC.text,
      'category': categoryTC.text,
      'brand': brandTC.text,
      'price_per_item': int.parse(pricePerItemTC.text),
      'quantity': int.parse(quantityTC.text),
      'date_modified': DateTime.now(),
      'recently_added_items': int.parse(quantityTC.text),
    }).then((value) {
      //inventory_last_updated_on();
      setState(() {
        
        toastAlert("Transaction Successful!", context);
        resetFields();
      });
      print("New Product Added");
    }).catchError(
            (error) => toastAlert("Transaction Failed! : $error", context));
  }

  //Reset All Fields
  void resetFields() {
    setState(() {
      item_nameTC.clear();
      categoryTC.clear();
      brandTC.clear();
      pricePerItemTC.clear();
      quantityTC.clear();
    });
  }
  // Future<void> inventory_last_updated_on(){
  //   return inv_db
  //       .doc(FirebaseAuth.instance.currentUser.email.toString()).collection("user_details").doc()
  //       .update({'inventory_last_updated_on': DateTime.now()})
  //       .then((value) => print("Inventory Last Date Updated"))
  //       .catchError((error) => print("Failed to update modified date: $error"));
  // }
}
