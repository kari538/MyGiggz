import 'package:my_giggz/myself.dart';
import 'package:my_giggz/firebase_labels.dart';

import 'profile_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'file:///C:/Users/karol/AndroidStudioProjects/my_giggz/lib/units/giggz_popup.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/giggz_theme.dart';
import 'package:my_giggz/my_types_and_functions.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
   // const RegisterScreen({@required this.userType, @required this.popWhenDone});
   RegisterScreen({@required this.userType, @required this.popWhenDone}){
    print('Hi from RegisterScreen');
  }

  final UserType userType;
  final bool popWhenDone;

  @override
  _RegisterScreenState createState() => _RegisterScreenState(userType, popWhenDone);
}

class _RegisterScreenState extends State<RegisterScreen> {
  _RegisterScreenState(this.userType, this.popWhenDone);

  final UserType userType;
  final bool popWhenDone;
  String firstName = '';
  String lastName = '';
  String userEmail = '';
  String userPassword1 = '';
  String userPassword2 = '';
  bool showSpinner = false;
  Map<String, dynamic> userData;

  // @override
  // void initState(){
  //   super.initState();
  //   print('Init state of Register screen');
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage('images/michael/group-people-holding-cigarette-lighters-260nw-687342115.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: GestureDetector(
                  child: Column(
                    children: [
                      Text('User Type:', style: fancyText),
                      Text(userDisplay(userType), style: fancyText.copyWith(fontSize: 18)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      firstName = userEmail = userPassword1 = userPassword2 = '123456';
                    });
                  },
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    top: 40,
                    right: 40,
                    // bottom: MediaQuery.of(context).viewInsets.bottom,  //Seems to make as much padding as the keyboard takes up... PLUS gives room for the keyboard...
                    bottom: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
//                    shrinkWrap: true,
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                firstName = value;
                              });
                            },
                            decoration: InputDecoration(hintText: '*First name'),
                            textAlign: TextAlign.center,
                            autofocus: true,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                lastName = value;
                              });
                            },
                            decoration: InputDecoration(hintText: 'Last name'),
                            textAlign: TextAlign.center,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                userEmail = value;
                              });
                            },
                            decoration: InputDecoration(hintText: '*email address'),
//                      keyboardType: TextInputType.,
                            textAlign: TextAlign.center,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                userPassword1 = value;
                              });
                            },
                            decoration: InputDecoration(hintText: '*choose password'),
                            obscureText: true,
                            textAlign: TextAlign.center,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                userPassword2 = value;
                              });
                            },
                            decoration: InputDecoration(hintText: '*repeat password'),
                            obscureText: true,
                            textAlign: TextAlign.center,
                          ),
                          //Show as soon as the user starts typing in Repeat password:
                          userPassword2 != ''
                              ? userPassword1 == userPassword2
                                  //If passwords match:
                                  ? Text('Passwords match', style: TextStyle(fontSize: 12, color: Colors.tealAccent))
                                  //If passwords don't match:
                                  : Text('Passwords don\'t match', style: TextStyle(fontSize: 12, color: Colors.red))
                              : SizedBox(),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text('Register'),
                            //Button is active if all fields have values and passwords are equal:
                            onPressed: firstName != '' && userEmail != '' && userPassword1 != '' && userPassword1 == userPassword2
                                ? () async {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    await MyFirebase.myFutureFirebaseApp;
                                    try {
                                      var user =
                                          await MyFirebase.authObject.createUserWithEmailAndPassword(email: userEmail, password: userPassword1);
                                      if (user != null) {
                                        String myUid = MyFirebase.authObject.currentUser.uid;
                                        userData = {
                                          kFieldUserType: userDisplay(userType),
                                          kFieldEmail: userEmail,
                                          kFieldFirstName: firstName,
                                          kFieldLastName: lastName,
                                          kFieldRating: [],
                                          kFieldPrice: null,
                                          kFieldSocialMedia: {},
                                          kFieldPortfolio: {},
                                          kFieldVerified: false,
                                          kFieldPresentation: '',
                                          kFieldVisible: true,
                                          kFieldWallet: 500,
                                          kFieldUid: myUid
                                        };
                                        Myself.userData = userData;
                                        try {
                                          MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).set(userData);
                                        } catch (e) {
                                          print('Error trying to create userinfo doc: $e');
                                        }
                                        //This sub collection call works fine:
                                        // MyFirebase.storeObject.collection(kCollectionUserInfo).doc('clients').collection('clients').doc(myUid).set({
                                        //   kFieldEmail: userEmail,
                                        //   kFieldFirstName: firstName,
                                        //   kFieldLastName: lastName,
                                        // });
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        if (popWhenDone) {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            // return ProfileScreen(userData: userData);
                                            return ProfileScreen();
                                          }));
                                        }
                                      }
                                    } catch (e) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      print(e);
                                      String code = e.code;
                                      String formattedCode = code.replaceAll('-', ' ');
                                      GiggzPopup(
                                        context: context,
                                        title: '${capitalizeFirst(formattedCode)}!',
                                        desc: '${e.message}',
                                      ).show();
                                      // GiggzPopup(
                                      //   context: context,
                                      //   title: 'Failed to Register!',
                                      //   desc: '$e',
                                      // ).show();
                                    }
                                  }
                                : null,
                          ),
//                            SizedBox(height: 500),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
