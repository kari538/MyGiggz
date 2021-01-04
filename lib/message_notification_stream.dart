import 'package:cloud_firestore/cloud_firestore.dart';
// import 'screens/welcome_screen.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_labels.dart';
import 'my_firebase.dart';
import 'package:flutter/material.dart';

class MessageNotificationStream {
  static void initiate(BuildContext context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);

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

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

    void showNotification(String title, String notification) async {
      var android = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription',
        priority: Priority.high,
        importance: Importance.max,
        // sound: RawResourceAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
        // sound: UriAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
        sound: UriAndroidNotificationSound('assets/note3.wav'),
      );
      var iOS = IOSNotificationDetails();
      var bothPlatforms = NotificationDetails(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.show(5, '$title', '$notification', bothPlatforms, payload: 'A new message has come in from somebody to somebody');
    }

    await MyFirebase.myFutureFirebaseApp;
    var user = MyFirebase.authObject.currentUser;
    Stream<QuerySnapshot> convSnapshots;
    int convStreamCount = 0;
    if(user!=null) {
      convSnapshots = MyFirebase.storeObject
          .collection(kCollectionConversations)
          .where(kFieldParticipantsArray, arrayContains: MyFirebase.authObject.currentUser.uid)
          .snapshots(/*includeMetadataChanges: true*/);
      convSnapshots.listen((event) {
        //onPressed
        // var y = event.data();
        List<QueryDocumentSnapshot> docsList = event.docs;
        // print('yyy is $y');
        for (QueryDocumentSnapshot doc in docsList) {
          Map<String, dynamic> convData = doc.data();
          // print('convData is $convData');
          String id = doc.id;
          // print('id is $id');
          Stream<QuerySnapshot> chatStream =
              MyFirebase.storeObject.collection(kCollectionConversations).doc(id).collection(kSubCollectionChat).snapshots();
          chatStream.listen((event) {
            // print('chat event is $event');
            // print('the event happened in id $id');
            List<QueryDocumentSnapshot> msgSnapshotsList = event.docs;
            // print('docs are $msgSnapshotsList\n---------------------------------------------------');
            for (DocumentSnapshot msg in msgSnapshotsList) {
              // print('y is $y');
              Map<String, dynamic> msgData = msg.data();
              // print('msgData is $msgData');
              // print('message is ${msgData[kFieldMessage]}');
              // print('${msgData[kFieldMessage]}');
              // showNotification('New message', '${msgData[kFieldMessage]}');
              if (convStreamCount > 0) showNotification('New message', "You've got a new message");
            }
          });
        }

        List<DocumentChange> z = event.docChanges;
        if (z != null) {
          print('Doc changes are: ${z[0].doc.data()}');
          // /*if(convStreamCount>0)*/ showNotification('New message', "You've got a new message");
          convStreamCount++;
        }
      });
    }
  }
}