import 'chat_screen.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_giggz/myself.dart';

class MyMessagesScreen extends StatefulWidget {
  @override
  _MyMessagesScreenState createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
  String myUid = MyFirebase.authObject.currentUser.uid;
  List<int> newsList = [];

  Future<int> countNewMsg(String convId/*, int i*/) async {
    //TODO: Don't have to count every damned msg.... only the latest, until I find a read one
    int newMsgs = 0;
    // var msgs = MyFirebase.storeObject.collection(kCollectionConversations).doc(convId).collection(kSubCollectionChat).snapshots();
    QuerySnapshot msgs = await MyFirebase.storeObject.collection(kCollectionConversations).doc(convId).collection(kSubCollectionChat).get();
    // msgs.listen((event) {
    //   List<QueryDocumentSnapshot> docs = event.docs;
      List<QueryDocumentSnapshot> docs = msgs.docs;
      for(QueryDocumentSnapshot doc in docs){
        Map<String, dynamic> msgData = doc.data();
        // print('Msg data is $msgData\n*******************************');
        if(msgData[kFieldRead]== false && msgData[kFieldSender] != myUid) {
          print('Read is false in msg ${msgData[kFieldMessage]}');
          newMsgs++;
        }
      }
    // });
    return newMsgs;
  }

  void updateNews(int i, Future<int> _newMsgs) async {
    newsList[i] = await _newMsgs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Messages')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: MyFirebase.storeObject.collection(kCollectionConversations).where(kFieldParticipantsArray, arrayContains: myUid).snapshots(),
          builder: (context, asyncSnapshot) {
            List<Widget> convCards = [];
            int i = 0;
            QuerySnapshot foundConversations = asyncSnapshot.data;
            if (foundConversations != null) {
              //It always wants to be null at first, and then I get errors for calling on null.
              for (QueryDocumentSnapshot conv in foundConversations.docs) {
                // print(conv);
                Map<String, dynamic> convData = conv.data();
                //TODO: Change from name to uid with conversion to name
                String myName = Myself.userData[kFieldFirstName];
                String name = myName; //At first... for conversations w myself
                for(String participant in convData[kFieldParticipants].keys){
                  if(participant != myName) name = participant;
                }
                // = convData[kFieldFirstName];
                // String news = '??';
                newsList.add(0);
                Future<int> newNews = countNewMsg(conv.id, /*, i*/);
                updateNews(i, newNews);

                convCards.add(
                  GestureDetector(
                      onTap: () async {
                        String yourUid = myUid;
                        for(String participantUid in convData[kFieldParticipantsArray]){
                          if(participantUid != myUid) yourUid = participantUid;
                        }
                        Map<String,dynamic> userData;
                        if (yourUid != myUid) {
                          var userSnapshot = await MyFirebase.storeObject.collection(kCollectionUserInfo).doc(yourUid).get();
                          userData = userSnapshot.data();
                        } else {
                          userData = Myself.userData;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ChatScreen(userData: userData);
                        }));
                      },

                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: Container(
                        color: Colors.blue,
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Image(
                                image: AssetImage('images/default-avatar-profile-icon_no-bg.png'),
                              ),
                            ),
                            Expanded(
                              child: Text('$name', textAlign: TextAlign.start, style: TextStyle(color: Colors.black)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text('New: ${newsList[i]}', textAlign: TextAlign.end, style: TextStyle(
                                  color: newsList[i] == 0 ? Colors.transparent : Colors.white,
                                ),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                i++;
                // for(var y in x.data().keys){
                //   print('key is $y and value is ${x.data()[y]}');
                //
                // }
              }
            } else {
              CircularProgressIndicator();
            }
            return Column(
              children: convCards,
            );
          },
        ),
      ),
    );
  }
}
