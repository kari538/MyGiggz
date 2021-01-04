// import 'package:my_giggz/firebase_labels.dart';
//
// import 'my_firebase.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
//
// void setUpCloudMessaging() async {
//   await MyFirebase.myFutureFirebaseApp;
//   // String token = await FirebaseMessaging.instance.getToken();
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   String token = await _firebaseMessaging.getToken();
//   print('Device token is $token');
//
//   // Save the initial token to the database:
//   await saveTokenToDatabase(token);
//   _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);
//
//
//   //From package docs:
//   Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//     if (message.containsKey('data')) {
//       // Handle data message
//       final dynamic data = message['data'];
//     }
//
//     if (message.containsKey('notification')) {
//       // Handle notification message
//       final dynamic notification = message['notification'];
//     }
//
//     // Or do other work.
//     // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//     _firebaseMessaging.requestNotificationPermissions();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         // _showItemDialog(message);
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         // _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // _navigateToItemDetail(message);
//       },
//     );
//   }
//
//
// }
//
// Future<void> saveTokenToDatabase(String token) async {
//   // Assume user is logged in for this example
//  String userId;
//   // String userEmail;
//  var user = MyFirebase.authObject.currentUser;
//   if (user!=null) {
//     print('Logged in as ${user.email}');
//     try {
//      userId = MyFirebase.authObject.currentUser.uid;
//       // userEmail = MyFirebase.authObject.currentUser.email;
//      print("My user ID in saveTokenToDatabase() is $userId");
//       // print("My user email in saveTokenToDatabase() is $userEmail");
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
//
//  if (userId != null) {
//   // if (userEmail != null) {
//   //   String myDocumentId = await getUserId(userEmail);
//     try {
//       await MyFirebase.storeObject
//          .collection(kCollectionUserInfo)
//          .doc(userId)
// //           .collection(kUserinfoCollection)
// //           .doc(myDocumentId)
//           .update({
//         'tokens': FieldValue.arrayUnion([token]),
//       });
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
//
