import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/my_firebase.dart';
// import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // QuerySnapshot x = await MyFirebase.storeObject.collection(kCollectionUserInfo).get();
  // List<QueryDocumentSnapshot> y = x.docs;
  // for(QueryDocumentSnapshot z in y){
  //   // Map<String, dynamic> user = z.data();
  //   // print(user);
  //   MyFirebase.storeObject.collection(kCollectionUserInfo).doc(z.id).update({
  //     // kFieldUid: z.id
  //     kFieldLocation : '',
  //     kFieldTagLine : '',
  //   });
  // }

  QuerySnapshot x = await MyFirebase.storeObject.collection(kCollectionConversations).get();
  List<QueryDocumentSnapshot> y = x.docs;
  for(QueryDocumentSnapshot z in y){
    // Map<String, dynamic> user = z.data();
    // print(user);
    QuerySnapshot msgs = await MyFirebase.storeObject.collection(kCollectionConversations).doc(z.id).collection(kSubCollectionChat).orderBy(kFieldTimeStamp, descending: true).get();
    List<QueryDocumentSnapshot> msgsDocs = msgs.docs;
    if (msgsDocs.isNotEmpty) {
      DocumentSnapshot lastMsg = msgsDocs[0];
      // FieldValue lastTimeStamp = lastMsg.data()[kFieldTimeStamp];
      Timestamp lastTimeStamp = lastMsg.data()[kFieldTimeStamp];
      MyFirebase.storeObject.collection(kCollectionConversations).doc(z.id).update({
        kFieldLastTimeStamp : lastTimeStamp,
      });
    }
  }

}