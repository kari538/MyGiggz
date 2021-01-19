import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';

void main(){
  changeFirebaseFields();
}

void changeFirebaseFields() async {
  MyFirebase.myFutureFirebaseApp = Firebase.initializeApp();
  await MyFirebase.myFutureFirebaseApp;
  ///Update Conversations docs:
  // QuerySnapshot snapshot = await MyFirebase.storeObject.collection(kCollectionConversations).get();
  // List<QueryDocumentSnapshot> docList = snapshot.docs;
  // for(DocumentSnapshot user in docList){
  //   // Map<String, dynamic> convData = user.data();
  //   // List<String> array = [];
  //   // for(String value in convData[kFieldParticipants].values){
  //   //   print('User ID value is: $value');
  //   //   array.add(value);
  //   // }
  //   // MyFirebase.storeObject.collection(kCollectionConversations).user(user.id).update({
  //   //   kFieldParticipantsArray: array
  //   // });
  //   QuerySnapshot chatSnapshot = await MyFirebase.storeObject.collection(kCollectionConversations).user(user.id).collection(kSubCollectionChat).get();
  //   List<QueryDocumentSnapshot> docList = chatSnapshot.docs;
  //   for(DocumentSnapshot msgDoc in docList){
  //     print(msgDoc.data());
  //     // print('next message ----------------------------------------');
  //     MyFirebase.storeObject.collection(kCollectionConversations).user(user.id).collection(kSubCollectionChat).user(msgDoc.id).update({
  //       kFieldRead: true,
  //       kFieldDelivered: false,
  //     });
  //   }

  ///Update Userinfo docs (which can also be done in its own file, the below has never yet worked):
  // QuerySnapshot snapshot = await MyFirebase.storeObject.collection(kCollectionUserInfo).get();
  // List<QueryDocumentSnapshot> docList = snapshot.docs;
  // for(DocumentSnapshot user in docList){
  //   // Map<String, dynamic> convData = user.data();
  //   // List<String> array = [];
  //   // for(String value in convData[kFieldParticipants].values){
  //   //   print('User ID value is: $value');
  //   //   array.add(value);
  //   // }
  //   MyFirebase.storeObject.collection(kCollectionUserInfo).doc(user.id).update({
  //     kFieldTagLine : '',
  //     kFieldLocation : '',
  //   });

    print('next user ----------------------------------------');
  // }
}