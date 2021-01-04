import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MyFirebase {
  static Future<FirebaseApp> myFutureFirebaseApp;  //Initialized from main()
  static FirebaseFirestore storeObject = FirebaseFirestore.instance;
  static auth.FirebaseAuth authObject = auth.FirebaseAuth.instance;

  static void logOut(){
    authObject.signOut();
  }
}