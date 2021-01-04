import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';

void changeFirebaseFields() async {
  await MyFirebase.myFutureFirebaseApp;
  ///Update Conversations docs:
  QuerySnapshot snapshot = await MyFirebase.storeObject.collection(kCollectionConversations).get();
  List<QueryDocumentSnapshot> docList = snapshot.docs;
  for(DocumentSnapshot doc in docList){
    // Map<String, dynamic> convData = doc.data();
    // List<String> array = [];
    // for(String value in convData[kFieldParticipants].values){
    //   print('User ID value is: $value');
    //   array.add(value);
    // }
    // MyFirebase.storeObject.collection(kCollectionConversations).doc(doc.id).update({
    //   kFieldParticipantsArray: array
    // });
    QuerySnapshot chatSnapshot = await MyFirebase.storeObject.collection(kCollectionConversations).doc(doc.id).collection(kSubCollectionChat).get();
    List<QueryDocumentSnapshot> docList = chatSnapshot.docs;
    for(DocumentSnapshot msgDoc in docList){
      print(msgDoc.data());
      // print('next message ----------------------------------------');
      MyFirebase.storeObject.collection(kCollectionConversations).doc(doc.id).collection(kSubCollectionChat).doc(msgDoc.id).update({
        kFieldRead: true,
        kFieldDelivered: false,
      });
    }

    // var chatSnap = doc.data();
    // var chat = chatSnap.keys;
    // print('chatSnap is $chatSnap and chat is $chat');
    print('next doc ----------------------------------------');
  }
}