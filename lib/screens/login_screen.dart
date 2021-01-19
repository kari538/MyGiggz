import 'package:my_giggz/constants.dart';
import 'package:my_giggz/my_types_and_functions.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_giggz/myself.dart';
import 'file:///C:/Users/karol/AndroidStudioProjects/my_giggz/lib/units/giggz_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({@required this.popWhenDone});
  final bool popWhenDone;

  @override
  _LoginScreenState createState(){
    michaelTracker('${this.runtimeType}');
    return _LoginScreenState(popWhenDone);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginScreenState(this.popWhenDone);
  final bool popWhenDone;
  bool showSpinner = false;
  String userEmail = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log in')),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  child: Image(
                    image: AssetImage('images/michael/IMG-20201208-WA0039.jpg'),
                    fit: BoxFit.cover,
                  ),
                  onTap: (){
                    setState(() {
                      userEmail = "karolinahagegard@gmail.com";
                      password = '123456';
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 0, right: 40, bottom: 40),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'e-mail address'),
                      onChanged: (value) {
                        setState(() {
                          userEmail = value;
                        });
                      },
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(hintText: 'password'),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      textAlign: TextAlign.center,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text('Log in'),
                      onPressed: userEmail == '' || password == ''
                          ? null
                          : () async {
                              setState(() {
                                showSpinner = true;
                              });
                              var user;
                              try {
                                user = await MyFirebase.authObject.signInWithEmailAndPassword(email: userEmail, password: password);
                              } catch (e) {
                                // print(e);
                                // setState(() {
                                //   showSpinner = false;
                                // });
                                print('runtimeType is ${e.runtimeType}');
                                print('code is ${e.code}');
                                print('message is ${e.message}');
                                print('email is ${e.email}');
                                print('phoneNumber is ${e.phoneNumber}');
                                print('tenantId is ${e.tenantId}');
                                print('credential is ${e.credential}');
                                String code = e.code;
                                String formattedCode = code.replaceAll('-', ' ');
                                print('Formatted code is $formattedCode');
                                print('Formatted code 2 is ${formattedCode.toUpperCase()}');
                                GiggzPopup(
                                  context: context,
                                  title: '${capitalizeFirst(formattedCode)}!',
                                  desc: '${e.message}',
                                ).show();
                                // GiggzPopup(
                                //   context: context,
                                //   title: '${formattedCode.toUpperCase()}!',
                                //   desc: '${e.message}',
                                // ).show();
                                showSpinner = false;
                              }
                              if (user != null) {
                                // setState(() {
                                //   showSpinner = false;
                                // });
                                // firstName = user[kFieldFirstName];
                                String myUid = MyFirebase.authObject.currentUser.uid;
                                DocumentSnapshot snapshot;
                                try {
                                  snapshot = await MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).get();
                                  print('snapshot is $snapshot');
                                } catch (e) {
                                  print('Error getting user data: $e');
                                }
                                Map<String, dynamic> userData = snapshot.data();
                                print('data is $userData');
                                Myself.userData = userData;
                                if (popWhenDone) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacement(context, MaterialPageRoute(settings: RouteSettings(name: routeHomeScreen), builder: (context) {
                                    // return ProfileScreen(firstName: firstName);
                                    // return ProfileScreen(userData: userData);
                                    return HomeScreen();
                                  }));
                                }
                              }
                            },
                    ),
                    MyFirebase.authObject.currentUser == null
                        ? SizedBox()
                        : RaisedButton(
                            child: Text('Proceed'),
                            onPressed: () async {
                              String myUid = MyFirebase.authObject.currentUser.uid;
                              DocumentSnapshot snapshot;
                              try {
                                snapshot = await MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).get();
                                // print('snapshot is $snapshot');
                              } catch (e) {
                                print('Error getting user data: $e');
                              }
                              Map<String, dynamic> userData = snapshot.data();
                              Myself.userData = userData;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                // return ProfileScreen(userData: userData);
                                return HomeScreen();
                              }));
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
