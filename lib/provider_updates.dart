import 'firebase_labels.dart';
import 'my_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:my_giggz/my_firebase.dart';
//import 'package:provider/provider.dart';

class ProviderUpdates extends ChangeNotifier {
  Map<String, String> providerUserIdMap = {};
  Map<String, String> providerUserPicMap = {};
  Map<String, int> providerUserZoomMap = {};
  Map<String, dynamic> myUserData = {};
  String myFirstName = '';
  // String myUid = '';
  String myEmail = '';

  void updateMyUserData(Map<String, dynamic> newUserData) {
    myUserData = newUserData;
    notifyListeners();
  }

  void updateMyFirstName(String newMe) {
    myFirstName = newMe;
    notifyListeners();
  }

  // void updateMyId(String newId){
  //   myUid = newId;
  //   notifyListeners();
  // }

  void updateMyEmail(String newEmail) {
    myEmail = newEmail;
    notifyListeners();
  }

  void updateUserIdMap(Map<String, String> newUserIdMap, Map<String, String> newUserPicMap, Map<String, int> newUserZoomMap) {
    providerUserIdMap = newUserIdMap;
    providerUserPicMap = newUserPicMap;
    providerUserZoomMap = newUserZoomMap;
    
    notifyListeners();
  }

  String getScreenName(String key) {
    return providerUserIdMap.containsKey(key) ? providerUserIdMap[key] : "Anonymous";
  }

// ignore: cancel_subscriptions
  StreamSubscription allUsersUpdatesStream, myselfUpdatesStream;

// StreamSubscription myselfUpdatesStream;

  void initialize() async {
    //Starting listening to changes in userdata in general AND in my userdata in particular:
    await MyFirebase.myFutureFirebaseApp;
    Map<String, String> _newUserIdMap = {};
    Map<String, String> _newUserPicMap = {};
    Map<String, int> _newUserZoomMap = {};

    allUsersUpdatesStream = MyFirebase.storeObject.collection(kCollectionUserInfo).snapshots().listen((event) {
      // Map<String, dynamic> eventData
      var docs = event.docs;
      for (DocumentSnapshot doc in docs) {
        Map<String, dynamic> userData = doc.data();
        if (userData != null) {
          //Dunno if it can, but...
          _newUserIdMap.addAll({'${doc.id}': userData[kFieldFirstName]});  //If the user has no first name, the value will be null
          _newUserPicMap.addAll({'${doc.id}': userData[kFieldPhotoUrl]});
          _newUserZoomMap.addAll({'${doc.id}': userData[kFieldZoom]});
        }
      }
      print('The newUserIdMap is $_newUserIdMap');
      updateUserIdMap(_newUserIdMap, _newUserPicMap, _newUserZoomMap);
    });

    MyFirebase.authObject.idTokenChanges().listen((event) {
      //Should hear every time somebody logs in or out on this phone
      print("An idTokenChange detected in ProviderUpdates.initialize()");
      if(myselfUpdatesStream != null) myselfUpdatesStream.cancel();
      if (MyFirebase.authObject.currentUser != null) {
        String myUid = MyFirebase.authObject.currentUser.uid;
        myselfUpdatesStream = MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).snapshots().listen((event) {
          //Should hear every time something changes in my userData doc online
          print('Detected a change in my user data in ProviderUpdates.initialize()');
          Map<String, dynamic> myNewUserData = event.data();
          String newName = myNewUserData[kFieldFirstName];
          updateMyUserData(myNewUserData);
          updateMyFirstName(newName);
        });
      }
    });
  }
}
