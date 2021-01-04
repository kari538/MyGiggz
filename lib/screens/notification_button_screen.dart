import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationButtonScreen extends StatefulWidget {
  @override
  _NotificationButtonScreenState createState() => _NotificationButtonScreenState();
}

class _NotificationButtonScreenState extends State<NotificationButtonScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Alert'),
        content: Text('$payload'),
      ),
    );
  }

  void showNotification() async {
    var android = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription',
      priority: Priority.high,
      importance: Importance.max,
      // sound: RawResourceAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
      // sound: UriAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
      sound: UriAndroidNotificationSound('assets/note3.wav'),
    );
    var iOS = IOSNotificationDetails();
    var bothPlatforms = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(5, 'New Tutorial', 'Local Notification', bothPlatforms, payload: 'AndroidCoding.in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('Tap for notification', style: Theme.of(context).textTheme.headline6),
          onPressed: showNotification,
        ),
      ),
    );
  }
}

