import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_n_inventory_flutter_app/app_drawer/drawer.dart';
import 'package:sales_n_inventory_flutter_app/authentication/register_page.dart';
import 'package:sales_n_inventory_flutter_app/others/otherFunctions.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

var item_nameTC = new TextEditingController();
var categoryTC = new TextEditingController();
var brandTC = new TextEditingController();
var pricePerItemTC = new TextEditingController();
var quantityTC = new TextEditingController();

var previousQuantity = 0;

class editItem extends StatefulWidget {
  Map<String, dynamic> data;

  String id;

  editItem(this.data, this.id);

  @override
  State<StatefulWidget> createState() => editItemState(this.data, this.id);
}

class editItemState extends State<editItem> {
  var appTitle = "Edit Item";

  Map<String, dynamic> data;

  String id;

  editItemState(this.data, this.id);

  @override
  void initState() {
    super.initState();
    setState(() {
      item_nameTC.text = data['item_name'];
      categoryTC.text = data['category'];
      brandTC.text = data['brand'];
      pricePerItemTC.text = data['price_per_item'].toString();
      quantityTC.text = data['quantity'].toString();
      previousQuantity = data['quantity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              bodyForeditItem(context),
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
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 35, 5, 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.edit,
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

  Widget bodyForeditItem(context) {
    return ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextFormField(
                controller: item_nameTC,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextFormField(
                controller: categoryTC,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Product Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextFormField(
                controller: brandTC,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Product Brand',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextFormField(
                controller: pricePerItemTC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price per item (INR)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextFormField(
                controller: quantityTC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
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
                label: Text("Update"),
                icon: Icon(
                  Icons.stream,
                  size: 30,
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await _update();
                  }
                },
              ),
            )
          ]))
    ]);
  }

  Future<void> _update() {
    return inv_db
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("products")
        .doc(id)
        .update({
      'item_name': item_nameTC.text,
      'category': categoryTC.text,
      'brand': brandTC.text,
      'price_per_item': int.parse(pricePerItemTC.text),
      'quantity': int.parse(quantityTC.text),
      'date_modified': DateTime.now(),
      'recently_added_items':
          (int.parse(quantityTC.text) - previousQuantity).abs(),
    }).then((value) {
      print("Inventory Item Updated");
      inventory_last_updated_on();
      toastAlert("Item updated successfully!", context);
    }).catchError((error) => print("Failed to update item: $error"));
  }

  Future<void> inventory_last_updated_on() {
    return inv_db
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .collection("user_details")
        .doc(FirebaseAuth.instance.currentUser.email.toString())
        .update({'inventory_last_updated_on': DateTime.now()})
        .then((value) => print("Inventory Last Date Updated"))
        .catchError((error) => print("Failed to update modified date: $error"));
  }
}
