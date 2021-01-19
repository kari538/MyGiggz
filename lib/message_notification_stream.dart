import 'package:cloud_firestore/cloud_firestore.dart';
// import 'screens/welcome_screen.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_labels.dart';
import 'my_firebase.dart';
import 'package:flutter/material.dart';

class MessageNotificationStream {
  static String myUid;

  static void initiate(BuildContext context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // var android = AndroidInitializationSettings('@mipmap/ic_launcher');  //Original
    // var android = AndroidInitializationSettings('@mipmap-hdpi/ic_launcher');
    var android = AndroidInitializationSettings('ic_launcher');
    // var android = AndroidInitializationSettings('happy_face_sad_face_masks_blue-bg.png');
    // var android = AndroidInitializationSettings('app/src/main/res/mipmap-xhdpi/ic_launcher.png');
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
      String channelId = 'Messages';
      String channelName = 'New Messages';
      String channelDescription = 'A new message has come in';
      var android = AndroidNotificationDetails('$channelId', '$channelName', '$channelDescription',
        priority: Priority.high,
        importance: Importance.max,
        // sound: RawResourceAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
        // sound: UriAndroidNotificationSound('C:\\Users\\karol\\AndroidStudioProjects\\my_giggz\\assets\\note3.wav'),
        // sound: UriAndroidNotificationSound('assets/note3.wav'),
      );
      var iOS = IOSNotificationDetails();
      var bothPlatforms = NotificationDetails(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.show(5, '$title', '$notification', bothPlatforms, payload: 'A new message has come in');
    }

    await MyFirebase.myFutureFirebaseApp;
    Stream<QuerySnapshot> myConvSnapshots;
    // int convStreamCount = 0;
    //Listen to user events - log in, log out, change user,...:
    MyFirebase.authObject.idTokenChanges().listen((event) {
      var user = MyFirebase.authObject.currentUser;
      if(user!=null) {
        myUid = MyFirebase.authObject.currentUser.uid;

        //Get a stream of all conversations where I participate:
        myConvSnapshots = MyFirebase.storeObject
            .collection(kCollectionConversations)
            .where(kFieldParticipantsArray, arrayContains: myUid)
            .snapshots(/*includeMetadataChanges: true*/);
        myConvSnapshots.listen((event) {
          List<QueryDocumentSnapshot> convList = event.docs;

          //For each conversation I'm in, get a stream of the chat msgs:
          for (QueryDocumentSnapshot conv in convList) {
            // Map<String, dynamic> convData = conv.data();
            // print('convData is $convData');
            String id = conv.id;
            // print('id is $id');
            Stream<QuerySnapshot> chatStream =
              MyFirebase.storeObject.collection(kCollectionConversations).doc(id).collection(kSubCollectionChat).snapshots();
            chatStream.listen((event) {
              // print('chat event is $event');
              // print('the event happened in id $id');
              List<QueryDocumentSnapshot> msgDocsList = event.docs;
              // print('docs are $msgDocsList\n---------------------------------------------------');
              for (DocumentSnapshot msg in msgDocsList) {
                Map<String, dynamic> msgData = msg.data();
                // print('msgData is $msgData');
                // print('message is ${msgData[kFieldMessage]}');
                // showNotification('New message', '${msgData[kFieldMessage]}');
                if (msgData[kFieldRead] == false && msgData[kFieldSender] != myUid){
                  showNotification('New message', "You've got a new message");
                }
              }
            });
          }

          // List<DocumentChange> z = event.docChanges;
          // if (z != null) {
          //   print('Doc changes are: ${z[0].doc.data()}');
          //   // /*if(convStreamCount>0)*/ showNotification('New message', "You've got a new message");
          //   // convStreamCount++;
          // }
        });
      }
    });
  }
}