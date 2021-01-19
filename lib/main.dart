import 'package:navigation_history_observer/navigation_history_observer.dart';
// import 'package:my_giggz/firebase_labels.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'cloud_messaging.dart';
// import 'temp_firebase_operations.dart';
import 'message_notification_stream.dart';
// import 'screens/notification_button_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:my_giggz/myself.dart';

import 'my_firebase.dart';
import 'package:my_giggz/screens/welcome_screen.dart';
import 'giggz_theme.dart';
import 'package:flutter/material.dart';

// void main() async {
void main() {
  WidgetsFlutterBinding.ensureInitialized();
   MyFirebase.myFutureFirebaseApp = Firebase.initializeApp(/*name: 'MyGiggz'*/);  //If I use 'name:', it seems to be interpreted as a secondary app, not the default...
    // await Firebase.initializeApp(/*name: 'MyGiggz', options:*/ );
  // await MyFirebase.myFutureFirebaseApp; //Needed if I use a different 'home:' than the WelcomeScreen().
  // changeFirebaseFields();
  // setUpCloudMessaging();
  // await MyFirebase.myFutureFirebaseApp;
  // if(MyFirebase.authObject.currentUser != null){
  //   String myUid = MyFirebase.authObject.currentUser.uid;
  //   DocumentSnapshot snapshot;
  //   try {
  //     snapshot = await MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).get();
  //     // print('snapshot is $snapshot');
  //   } catch (e) {
  //     print('Error getting user data: $e');
  //   }
  //   Map<String, dynamic> userData = snapshot.data();
  //   Myself.userData = userData;
  // }
  runApp(MyGiggz());
}

class MyGiggz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    MessageNotificationStream.initiate(context);
    return MaterialApp(
      theme: giggzTheme,
      home: WelcomeScreen(),  //IF not already logged in, in which case they'll get to their profile page.
      // home: SearchScreen(),  //Too much stuff to fix...!!
      // home: NotificationButtonScreen(),
      navigatorObservers: [NavigationHistoryObserver()],
      // showPerformanceOverlay: ,
    );
  }
}


