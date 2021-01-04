import 'package:my_giggz/my_types_and_functions.dart';
import 'user_type_screen.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:my_giggz/units/giggz_popup.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/giggz_theme.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({@required this.userData});
  final Map<String, dynamic> userData;


  Widget nonActionTile({
    @required BuildContext context,
    @required String text,
    // @required String value,
    @required String field,
    TextStyle style,
  }) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, textAlign: TextAlign.start),
          Text('${userData[field]}', textAlign: TextAlign.end, style: style ?? Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(thickness: 2, height: 2, color: Colors.blueGrey);
  }

  double getRating(){
    double totalRating =0;
    if(!userData[kFieldRating].isEmpty){
      for(int rating in userData[kFieldRating]){
        totalRating += rating;
      }
      totalRating = totalRating / userData[kFieldRating].length;
    }
    return totalRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Viewing Profile of ...')),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    clipBehavior: Clip.hardEdge,
                    child: Image(
                      image: AssetImage('images/michael/IMG-20201208-WA0037.jpg'),
                      // fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/4,
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
                                child: Text('${userData[kFieldFirstName]} ${userData[kFieldLastName]}', style: fancyText.copyWith(fontSize: 32, shadows: fancyShadows)),
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
                            Expanded(
                              child: FittedBox(child: Text('Eg. Singer/song-righter')),
                            ),
                            Expanded(
                              child: FittedBox(child: Text('in <Location>')),
                            ),
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
                      Text('${userData[kFieldUserType]}', style: fancyText),
                      GestureDetector(
                        child: Icon(Icons.message, size: 30),
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
                    child: userData[kFieldRating].isEmpty ? Text('no ratings yet', style: TextStyle(fontSize: 14)) : Text('Rating: ${getRating()}'),
                    alignment: Alignment.topLeft,
                    // color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: userData[kFieldPresentation] == ''
                        ? Text('(no presentation)', style: TextStyle(color: Theme.of(context).hintColor))
                        : Text('${userData[kFieldPresentation]}', textAlign: TextAlign.center),
                    alignment: Alignment.center,
                    height: 100,
                  ),
                  Column(
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
                      SizedBox(height: 20),
                    ],
                  ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
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
