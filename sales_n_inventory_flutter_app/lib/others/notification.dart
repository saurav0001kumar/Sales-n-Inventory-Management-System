import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sales_n_inventory_flutter_app/screens/screen1_home.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class NotifyAlert extends StatefulWidget {
  var currentUser;

  @override
  State<StatefulWidget> createState() => NotifyAlertState();
}

class NotifyAlertState extends State<NotifyAlert> {
  var currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification::Inventory Alert'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }

  showNotification(int i,String payload) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high,
        importance: Importance.max,
        enableVibration: true,
        playSound: true);
    var iOS = new IOSNotificationDetails(sound: "sound.mp3");
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        i, 'Inventory Stock Alert!', payload, platform,
        payload: payload);
  }
}
