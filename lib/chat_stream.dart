import 'package:flutter/cupertino.dart';

import 'firebase_labels.dart';
import 'my_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Straight from Angela's Flash Chat:
class MessageStream extends StatelessWidget {
  MessageStream({@required this.convId, @required this.myUid, @required this.convIdReady});
  final String convId;
  final String myUid;
  final bool convIdReady;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: _firestore.collection('messages').snapshots(),
      stream: convIdReady
          ? MyFirebase.storeObject.collection(kCollectionConversations).doc(convId).collection(kSubCollectionChat).orderBy(kFieldTimeStamp).snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
            ),
          );
        }
        // final messages = snapshot.data.documents.reversed;
        final messages = snapshot.data.docs.reversed;
        // final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()[kFieldMessage];
          final senderUid = message.data()[kFieldSender];

          // final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            // sender: senderUid,
            text: messageText,
            isMe: myUid == senderUid,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
            controller: ScrollController(keepScrollOffset: true),

          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    // this.sender,
    this.text, this.isMe});

  // final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe ? EdgeInsets.fromLTRB(60.0, 10, 10, 10) : EdgeInsets.fromLTRB(10, 10, 60, 10),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   sender,
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            // shadowColor: Colors.white,
            color: isMe ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
