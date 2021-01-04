import 'view_profile_screen.dart';
import 'package:my_giggz/constants.dart';
import 'package:my_giggz/my_types_and_functions.dart';
import 'package:my_giggz/screens/search_criteria_screen.dart';

// import 'package:my_giggz/my_types_and_functions.dart';
// import 'package:my_giggz/screens/register_screen.dart';
import 'package:my_giggz/screens/user_type_screen.dart';
import 'file:///C:/Users/karol/AndroidStudioProjects/my_giggz/lib/units/giggz_popup.dart';
import 'package:my_giggz/screens/login_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// import 'package:my_giggz/main.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Map<String, dynamic> criteria;

  void addUserCard({@required List<Widget> userCards, @required Map<String, dynamic> userData}) {
    String firstName = userData[kFieldFirstName];
    userCards.add(
      Padding(
        padding: const EdgeInsets.all(2),
        child: GestureDetector(
          child: Container(
            color: Colors.white,
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage('images/default-avatar-profile-icon_no-bg.png'),
                  ),
                ),
                Expanded(
                  child: Text('$firstName', textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                ),
                Expanded(
                  child: GestureDetector(
                      child: Icon(
                        Icons.message,
                        color: Colors.black,
                      ),
                      // onTap: MyFirebase.authObject.currentUser != null ? () {
                      //                                 //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //                                 //     return ChatScreen(userData: userData);
                      //                                 //   }));
                      //                                 // }
                      //                                 //     : () {
                      //                                 //   GiggzPopup(
                      //                                 //       context: context,
                      //                                 //       title: 'Notice:',
                      //                                 //       desc: 'In order to send messages to users, you need to be logged in.\n\n'
                      //                                 //           'If you don\'t yet have a user account, you can register one for free',
                      //                                 //       buttons: [
                      //                                 //       LoginButton(setParentState: () {
                      //                                 //         setState(() {});
                      //                                 //       }),
                      //                                 //     //   RegisterButton(),
                      //                                 //     //   CancelButton(),
                      //                                 //     ]
                      //                                 //   ).show();
                      onTap: () async {
                        //If not logged in:
                        if (MyFirebase.authObject.currentUser == null) {
                          await GiggzPopup(
                            context: context,
                            title: 'Notice:',
                            desc: 'In order to send messages to users, you need to be logged in.\n\n'
                                'If you don\'t yet have a user account, you can register one for free',
                            buttons: [
                              LoginButton(),
                              RegisterButton(),
                              CancelButton(),
                            ],
                          ).show();
                        }
                        print('Back from must-login popup button.');
                        //If now somebody is logged in (which they might not be coz they could cancel):
                        if (MyFirebase.authObject.currentUser != null) {
                          print('Current user is ${MyFirebase.authObject.currentUser.email}');
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ChatScreen(userData: userData);
                          }));
                        }
                      }),
                ),
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ViewProfileScreen(userData: userData);
            }));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              criteria = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchCriteriaScreen();
              }));
              print('Result of SearchCriteriaScreen() is $criteria');
              setState(() {
                //New search with criteria
              });
            },
            iconSize: 45,
            // color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: MyFirebase.storeObject.collection(kCollectionUserInfo).orderBy(kFieldFirstName, descending: true).snapshots(),
          // stream: MyFirebase.storeObject.collection(kCollectionUserInfo).where(kFieldFirstName, isEqualTo: '${criteria['critName']}').snapshots(),
          builder: (context, asyncSnapshot) {
            List<Widget> userCards = [];
            QuerySnapshot foundUsers = asyncSnapshot.data;
            if (foundUsers != null) {
              //It always wants to be null at first, and then I get errors for calling on null.
              for (QueryDocumentSnapshot user in foundUsers.docs) {
                // print(user);
                Map<String, dynamic> userData = user.data();
                if (criteria != null) {
                  if (criteria[critName] != null) {
                    String x = 'ji';
                    // if(x.contains('other'));
                    x.toLowerCase();
                    // print('In StreamBuilder: userData[kFieldFirstName] is ${userData[kFieldFirstName]} and');
                    // print('criteria[critName] is ${criteria[critName]}');
                    //If first or last name of a user contains the string searched for, add that user:
                    if (userData[kFieldFirstName].toLowerCase().contains(criteria[critName].toLowerCase()) || userData[kFieldLastName].toLowerCase().contains(criteria[critName].toLowerCase())) {
                      addUserCard(userCards: userCards, userData: userData);
                    }
                  } else if(criteria[critEmail] != null){
                    if (userData[kFieldEmail].toLowerCase().contains(criteria[critEmail].toLowerCase())) {
                      addUserCard(userCards: userCards, userData: userData);
                    }
                  } else if(criteria[critUserType] != null){
                    print('Inside user type not null');
                    print('userData[kFieldUserType] is ${userData[kFieldUserType]}');
                    print('criteria[critUserType] is ${criteria[critUserType]}');
                    if(userData[kFieldUserType] == userDisplay(criteria[critUserType])){
                      print('Inside user type equality');
                      addUserCard(userCards: userCards, userData: userData);
                    }
                  }
                } else {
                  addUserCard(userCards: userCards, userData: userData);
                }
              }
            } else {
              CircularProgressIndicator();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              criteria == null
                  ? SizedBox()
                  : Text('Found users with '
                      '${criteria[critName] != null ? 'name ${criteria[critName]}:' : ''} '
                      '${criteria[critEmail] != null ? 'email ${criteria[critEmail]}:' : ''} '),
              userCards.isEmpty
                  ? Container(
                height: 100,
                child: Center(child: Text('(No users matched search criteria)', style: TextStyle(color: Theme.of(context).hintColor))),
              )
                  : Column(children: userCards),
            ]);
          },
        ),
      ),
    );
  }
}

// class LoginButton extends StatelessWidget {
class LoginButton extends DialogButton {
  @override
  Widget build(BuildContext context) {
    return GiggzPopupButton(
      text: 'Log in',
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginScreen(popWhenDone: true);
        }));
        // setParentState();
        Navigator.pop(context);
      },
    );
  }
}

class RegisterButton extends DialogButton {
  @override
  Widget build(BuildContext context) {
    return GiggzPopupButton(
      text: 'Register',
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UserTypeScreen(popWhenDone: true);
          // return RegisterScreen(userType: UserType.artist, popWhenDone: true);
        }));
        // setParentState();
        Navigator.pop(context);
      },
    );
  }
}

class CancelButton extends DialogButton {
  @override
  Widget build(BuildContext context) {
    return GiggzPopupButton(
      text: 'Cancel',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
