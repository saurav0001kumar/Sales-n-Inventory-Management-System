/*
CAUTION: Do not delete or modify this file.
*/
import 'package:toast/toast.dart';

bool isDrawerOpen=false;

//TOAST alert
void toastAlert(String message,context) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
}