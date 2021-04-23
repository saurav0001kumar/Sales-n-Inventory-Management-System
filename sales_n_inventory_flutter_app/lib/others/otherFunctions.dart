//TOAST alert
import 'package:toast/toast.dart';

void toastAlert(String message,context) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
}