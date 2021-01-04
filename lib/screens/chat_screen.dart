import 'package:my_giggz/chat_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/myself.dart';
import 'package:flutter/material.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({@required this.userData});

  final Map<String, dynamic> userData;

  @override
  _ChatScreenState createState() => _ChatScreenState(userData);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.yourUserData);

  Map<String, dynamic> yourUserData;
  Map<String, dynamic> myUserData;
  String yourUid;
  String myUid;
  Future<String> futureConvId;
  String convId;
  bool convIdReady = false;
  String msg = '';
  TextEditingController msgFieldController = TextEditingController();

  @override
  void initState(){
    super.initState();
    // msgFieldController.
    myUserData = Myself.userData;
    yourUid = yourUserData[kFieldUid];
    myUid = myUserData[kFieldUid];  //This is where it crashes
    futureConvId = getConversationId();
    waitForConvId();
  }

  Future<String> getConversationId() async {
    String _convId;
    // _convId = myUid.substring(0, 10)+'-'+yourUid.substring(0, 10);
    _convId = yourUid.substring(0, 10)+'-'+myUid.substring(0, 10);

    // QuerySnapshot myMsgs = await MyFirebase.storeObject.collection(kCollectionConversations).where(kFieldParticipants, arrayContains: [myUid, yourUid]).get();
    DocumentSnapshot myMsgs = await MyFirebase.storeObject.collection(kCollectionConversations).doc(_convId).get();
    print(myMsgs.data());
    // if(myMsgs.docs.isEmpty /*== null*/){
    if(myMsgs.exists){
      print('Attempt 1 has data');
      print('convId is $_convId');
      return _convId;
    } else {
      // _convId = yourUid.substring(0, 10)+'-'+myUid.substring(0, 10);
      _convId = myUid.substring(0, 10)+'-'+yourUid.substring(0, 10);
      DocumentSnapshot myMsgs = await MyFirebase.storeObject.collection(kCollectionConversations).doc(_convId).get();
      if (myMsgs.exists) {
        print('Attempt 2 has data');
        print('convId is $_convId');
        return _convId;
      }
    }
    //If none of the tried convIds have worked, create the conversation:
    print('The conversation does not exist');
    try {
      await MyFirebase.storeObject.collection(kCollectionConversations).doc(_convId).set({
        kFieldParticipants: {myUserData[kFieldFirstName]: myUid, yourUserData[kFieldFirstName]: yourUid},
        kFieldParticipantsArray: [myUid, yourUid],
        kFieldStarted: FieldValue.serverTimestamp(),
      });
      // await MyFirebase.storeObject.collection(kCollectionConversations).doc(_convId).collection(kSubCollectionChat).doc().set({});
    } catch (e) {
      print(e);
    }
    return _convId;
  }

  void waitForConvId() async {
    convId = await futureConvId;
    setState(() {
      convIdReady = true;
    });
    //Mark as read:
    QuerySnapshot snapshot = await MyFirebase.storeObject.collection(kCollectionConversations).doc(convId).collection(kSubCollectionChat).where(kFieldSender, isNotEqualTo: myUid).get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for(QueryDocumentSnapshot doc in docs){
      // Map<String, dynamic> chatData = doc.data();
      MyFirebase.storeObject.collection(kCollectionConversations).doc(convId).collection(kSubCollectionChat).doc(doc.id).update({
        kFieldRead: true,
      });
    }
  }

  // List<Widget> messages() {
  //   return [Text('hi')];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(title: Text('Chat with ${yourUserData[kFieldFirstName]}'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          SizedBox(),
          MessageStream(convId: convId, myUid: myUid, convIdReady: convIdReady,),
          TextField(
            onChanged: (value){
              setState(() {
                msg = value;
              });
            },
            maxLines: 9,
            minLines: 1,
            // expands: true,
            decoration: InputDecoration(
              hintText: ' write your message',
              suffixIcon: GestureDetector(
                child: Icon(Icons.send, color: Colors.white),
                onTap: msg == '' ? null : () async {
                  msgFieldController.clear();
                  MyFirebase.storeObject.collection(kCollectionConversations).doc(await futureConvId).collection(kSubCollectionChat).doc().set({
                    kFieldMessage: '$msg',
                    kFieldSender: myUid,
                    kFieldTimeStamp: FieldValue.serverTimestamp(),
                    kFieldDelivered: false,
                    kFieldRead: false,
                  });
                  msgFieldController.value = TextEditingValue(text: '', );
                  print('After controller.value = "", msg = $msg and controller.value = ${msgFieldController.value}');
                  setState(() {
                    msg = '';
                  });
                  // var myMsgs = MyFirebase.storeObject.collection(kCollectionMessages).where(kFieldParticipants, arrayContains: myUid).where(kFieldParticipants, arrayContains: yourUid).snapshots();
                },
              ),
              filled: true,
              fillColor: Colors.black26,
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
            autofocus: true,
            controller: msgFieldController,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}

