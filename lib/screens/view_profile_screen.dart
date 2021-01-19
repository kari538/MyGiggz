import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_giggz/my_types_and_functions.dart';
import 'package:my_giggz/screens/edit_profile_screen.dart';
import 'package:my_giggz/units/stars.dart';
import 'package:my_giggz/profile_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart' as url;

// import 'package:my_giggz/my_types_and_functions.dart';
import 'user_type_screen.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:my_giggz/units/giggz_popup.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/giggz_theme.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:flutter/material.dart';

String tagLine;
String firstName;
String lastName;
String location;
final Color labelColor = Color(0xffe4d6ff); //activeCardContentColor of BMI Calculator
TextStyle tagTextStyle = TextStyle(
  color: labelColor,
);

class ViewProfileScreen extends StatelessWidget {
  ViewProfileScreen({@required this.userData}) {
    tagLine = userData[kFieldTagLine];
    firstName = userData[kFieldFirstName];
    lastName = userData[kFieldLastName];
    location = userData[kFieldLocation];
    // Color x = labelColor;
  }

  final Map<String, dynamic> userData;

  Widget nonActionTile({
    @required BuildContext context,
    @required String text,
    // @required String value,
    @required String field,
    TextStyle style,
  }) {
    if (field == kFieldSocialMedia) {
      List<Widget> rowChildren = [
        Text(text, textAlign: TextAlign.start, style: TextStyle(color: labelColor)),
      ];
      List<Widget> insideRowChildren = [];

      for (String category in userData[kFieldSocialMedia].keys) {
        rowChildren.add(socialMediaDivider());
        int mediaCount = 0;
        for (String mediaName in userData[kFieldSocialMedia][category].keys) {
          rowChildren.add(
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mediaCount == 0
                    ? Text(/*'YouTube'*/ '$category',
                        style: TextStyle(
                            color: socialMediaTagColor.containsKey(category) ? socialMediaTagColor[category] : Colors.orangeAccent,
                            fontWeight: FontWeight.bold))
                    : SizedBox(),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    child: Text(/*'Building Collapses'*/ '$mediaName', textAlign: TextAlign.end, style: TextStyle(fontSize: 16, /*fontWeight: FontWeight.bold,*/ color: Colors.lightBlueAccent, decoration: TextDecoration.underline)),
                    onTap: () async {
                      print('About to try url.launch');
                      PlatformException errorMsg /*= PlatformException()*/;
                      try {
                        await url.launch('${userData[kFieldSocialMedia][category][mediaName]}');
                      } catch (e) {
                        print('e is a $e.');
                        errorMsg = e;
                        String code = errorMsg.code;
                        String formattedCode = code.replaceAll('_', ' ');
                        print(formattedCode);
                        GiggzPopup(context: context, title: '${capitalizeFirst(formattedCode)}!', desc: '${errorMsg.message}\n\nTry checking the link address (URL)!').show();
                      }
                      print('Done trying url.launch');
                    },
                  ),
                ),
              ],
            ),
          );
          rowChildren.add(SizedBox(height: 10));
          mediaCount++;
        }
      }

      return Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
            // children: [
            //   Text(text, textAlign: TextAlign.start, style: TextStyle(color: labelColor)),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('YouTube', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            //       InkWell(
            //         child: Text('Building Collapses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //         onTap: () => url.launch('https://www.youtube.com/watch?v=NqRN63iDTqA&list=PL7919F11911D77D40&index=1'),
            //       ),
            //     ],
            //   ),
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('YouTube', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold)),
            //       InkWell(
            //         child: Text('National Anthem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //         onTap: () => url.launch('https://www.youtube.com/watch?v=NqRN63iDTqA&list=PL7919F11911D77D40&index=1'),
            //       ),
            //     ],
            //   ),
            //   socialMediaDivider(),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('Facebook', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
            //       InkWell(
            //         child: Text('My Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //         onTap: () => url.launch('http://facebook.com/karolina.hagegard'),
            //       ),
            //     ],
            //   ),
            // ],
          ),
        ),
      );
    }
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, textAlign: TextAlign.start, style: TextStyle(color: labelColor)),
          Text('${userData[field]}', textAlign: TextAlign.end, style: style ?? Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(thickness: 2, height: 2, color: Colors.blueGrey);
  }

  Widget socialMediaDivider() {
    return Divider(color: Colors.blueGrey.shade600);
  }

  double getRating() {
    double totalRating = 0;
    if (!userData[kFieldRating].isEmpty) {
      for (int rating in userData[kFieldRating]) {
        totalRating += rating;
      }
      totalRating = totalRating / userData[kFieldRating].length;
    }
    return totalRating;
  }

  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    return Scaffold(
      // appBar: AppBar(title: Text('Viewing Profile of ...')),
      appBar: AppBar(
        actions: [ProfileMenu()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Image(
                    image: AssetImage('images/michael/IMG-20201208-WA0037.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.width/4,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                child: Text(
                                    '$firstName $lastName', style: fancyText.copyWith(color: Colors.tealAccent, fontSize: 32, shadows: fancyShadows)),
                                alignment: Alignment.center,
                              ),
                            ),
                            // Expanded(child: SizedBox()),
                            Expanded(
                              flex: 4,
                              child: Image(
                                image: AssetImage('images/default-avatar-profile-icon_no-bg.png'),
                              ),
                            ),
                            Text(
                                '$tagLine', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, shadows: fancyShadows)),
                            Text(
                                'in ${location != '' ? location : '<Location>'}', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, shadows: fancyShadows)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Expanded(
                  //   child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${userData[kFieldUserType]}', style: fancyText.copyWith(color: labelColor)),
                      GestureDetector(
                        child: Icon(Icons.message, size: 30, color: labelColor),
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
                        },
                      ),
                    ],
                  ),
                  Container(
                    child: userData[kFieldRating].isEmpty
                        ? Text('no ratings yet', style: TextStyle(fontSize: 14))
                    // : Text('Rating: ${getRating().toStringAsFixed(1)}', style: tagTextStyle),
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Rating: ', style: tagTextStyle),
                        Stars(getRating()),
                      ],
                    ),
                    alignment: Alignment.topLeft,
                    // color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //    userData[kFieldPresentation] == ''
                  //       ? '(no presentation)'
                  //       : '${userData[kFieldPresentation]}', textAlign: TextAlign.center,
                  //   alignment: Alignment.center,
                  // style: TextStyle(color: Theme.of(context).hintColor),
                  //   height: 100,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, /*top: 10,  bottom:*/ 20),
                    child: userData[kFieldPresentation] == ''
                        ? Text('(no presentation)', style: TextStyle(color: Theme
                        .of(context)
                        .hintColor))
                        : Text('${userData[kFieldPresentation]}', textAlign: TextAlign.center),
                  )
                  // alignment: Alignment.center,
                  // height: 100,
                  ,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      divider(),
                      nonActionTile(context: context, text: 'Pay rate:', /*value: '${userData[kFieldPrice]}',*/ field: kFieldPrice),
                      // divider(),
                      // nonActionTile(context: context, text: 'Rating:', field: kFieldRating),
                      divider(),
                      nonActionTile(context: context, text: 'Verified:', field: kFieldVerified),
                      divider(),
                      nonActionTile(context: context, text: 'Social Media:', field: kFieldSocialMedia),
                      divider(),
                      nonActionTile(context: context, text: 'Portfolio:', field: kFieldPortfolio),
                      // EditProfileButton(profileUid: userData[kFieldUid]),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: EditProfileButton(profileUid: userData[kFieldUid]),
    );
  }
}


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

class EditProfileButton extends StatefulWidget {
  const EditProfileButton({@required this.profileUid});

  final String profileUid;

  @override
  _EditProfileButtonState createState() => _EditProfileButtonState(profileUid);
}

class _EditProfileButtonState extends State<EditProfileButton> {
  _EditProfileButtonState(this.profileUid);

  StreamSubscription loginListener;

  // bool isLoggedIn = false;
  bool isMe = false;
  String profileUid;

  @override
  void initState() {
    super.initState();
    loginStream();
  }

  @override
  void dispose() {
    super.dispose();
    loginListener.cancel();
  }

  void loginStream() {
    if (MyFirebase.authObject.currentUser != null) {
      // isLoggedIn = true;
      if (MyFirebase.authObject.currentUser.uid == profileUid) {
        isMe = true;
      } else {
        isMe = false;
      }
    } else {
      isMe = false;
    }
    loginListener = MyFirebase.authObject.idTokenChanges().listen((event) {
      if (MyFirebase.authObject.currentUser != null) {
        // isLoggedIn = true;
        if (event.uid == profileUid) {
          setState(() {
            isMe = true;
          });
        } else {
          setState(() {
            isMe = false;
          });
        }
      } else {
        setState(() {
          isMe = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return isMe ? GestureDetector(
    return isMe ? FloatingActionButton(
      child: Icon(
        Icons.edit_outlined,
        size: 27,
        // color: Colors.tealAccent,
      ),
      // onTap: (){
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return EditProfileScreen();
        }));
      },
    ) : SizedBox(height: 20);
  }
}

