/*
CAUTION: Do not delete or modify this file.
*/
import 'package:toast/toast.dart';

bool isDrawerOpen=false;

//List items Group by :
// 01. by Product Category
var categories={"Default"};
var selectedCategory="Default";

//Group By Vendor : Vendors List
var vendors={"ALL"};
var selectedVendor="ALL";

//Get Vendors Email & Phone:
var vendor_phones=[];
var vendor_emails=[];

//TOAST alert
void toastAlert(String message,context) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
}