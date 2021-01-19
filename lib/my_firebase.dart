import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:my_giggz/firebase_labels.dart';

class MyFirebase {
  static Future<FirebaseApp> myFutureFirebaseApp;  //Initialized from main()
  static FirebaseFirestore storeObject = FirebaseFirestore.instance;
  static auth.FirebaseAuth authObject = auth.FirebaseAuth.instance;

  static void logOut(){
    authObject.signOut();
  }
}


void michaelTracker(String screen) async {
  await MyFirebase.myFutureFirebaseApp;
  // if (MyFirebase.authObject.currentUser !=null && MyFirebase.authObject.currentUser.uid == 'gBGWdTnWQmdr8aSsg5Ysr6XKEaO2') {  //Karolina
  if (MyFirebase.authObject.currentUser !=null && MyFirebase.authObject.currentUser.uid == 'UvvpmV5z6SUrRZNQZUh9lBbo6wk1') {  //Michael
    MyFirebase.storeObject.collection(kCollectionMichealTracker).add({
      'screen' : screen,
      'timeStamp' : FieldValue.serverTimestamp(),
    });
  }
}