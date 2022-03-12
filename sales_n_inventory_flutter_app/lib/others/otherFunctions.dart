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
var vendors=[];
// var selectedVendor="ALL";

//Get Vendors Email & Phone:
var vendor_phones=[];
var vendor_emails=[];

//Notification Alert Items Count (Low Stock & Out of Stock)
var out_of_stocks=0;
var low_stocks=0;

//TOAST alert
void toastAlert(String message,context) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
}