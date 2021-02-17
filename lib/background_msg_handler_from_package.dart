import 'package:firebase_messaging/firebase_messaging.dart';

// Future<dynamic> backgroundMessageHandlerFromPackage(Map<String, dynamic> message) async {
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('Running backgroundMessageHandler(). Message is $message');
  // if (message.containsKey('data')) {
  //   // Handle data message
  //   final dynamic data = message['data'];
  // }
  if (message.notification != null) {
    // Handle notification message
    final dynamic notification = message.notification;
    // print(notification.titel + ' ' + notification.body);
    print('notification is $notification');
  }

  if (message.data != null) {
    // Handle data message
    final dynamic data = message.data;
    print(data);
  }
}
