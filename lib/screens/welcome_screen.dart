import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_giggz/constants.dart';
import 'loading_screen.dart';
import 'users_screen.dart';
import 'package:my_giggz/giggz_theme.dart';
// import 'package:my_giggz/message_notification_stream.dart';
import 'package:my_giggz/myself.dart';
// import 'dart:math';
import 'home_screen.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/my_firebase.dart';
import 'login_screen.dart';
import 'user_type_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {

  Future<bool> isLoggedIn() async {
    await MyFirebase.myFutureFirebaseApp;
    User user = MyFirebase.authObject.currentUser;
    print('user is $user');
    // if (user == null) {
    if (user != null) {
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
      String firstName = userData[kFieldFirstName];
      print('First name from logged in user is $firstName');
      return true;
      }
    return false;
    }

  @override
  Widget build(BuildContext context) {
    print('Building ${this.runtimeType}');
    Future<bool> perhapsLoggedIn = isLoggedIn();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 5, 8),
                      child: Text('Log in', style: TextStyle(fontSize: 18)),
                    ),
                    onTap: () async {
                        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2){
                          return LoadingScreen();
                        }));
                        perhapsLoggedIn = isLoggedIn();
                        bool loggedIn = await perhapsLoggedIn;
                        print('loggedIn is $loggedIn');
                        if(loggedIn)
                          {
                            Navigator.pushReplacement(context, MaterialPageRoute(settings: RouteSettings(name: routeHomeScreen), builder: (context) {
                          // return ProfileScreen(userData: userData);
                          return HomeScreen();
                          // return SearchScreen();
                        }));
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return LoginScreen(popWhenDone: false);
                        }));
                      }
                    },
                  ),
                  SizedBox(child: Center(child: Text('|', style: TextStyle(fontSize: 22))), /*width: 10,*/),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 0, 8),
                      child: Text('Sign up', style: TextStyle(fontSize: 18)),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return UserTypeScreen(popWhenDone: false);
                      }));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
        actionsIconTheme: IconThemeData(size: 20),
      ),
      body:
      // ModalProgressHUD(
      //   inAsyncCall: showSpinner,
      //   child:
        Container(
          child: SingleChildScrollView(

            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: Image(image: AssetImage('images/michael/IMG-20201208-WA0034.jpg'),
                //   fit: BoxFit.cover,
                //   ),
                // ),
                // RichText(
                //   textAlign: TextAlign.center,
                //   text: TextSpan(
                //       text: 'Welcome to',
                //       style: TextStyle(fontFamily: 'Pacifico', fontSize: 34),
                //       children: <TextSpan>[TextSpan(text: '\nMyGiggz', style: TextStyle(fontSize: 28))]),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Welcome to MyGiggz',
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 34, fontWeight: FontWeight.bold, shadows: fancyShadows),
                      children: <TextSpan>[
                        TextSpan(text: '\nbusiness meeting place for entertainers', style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal))
                      ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Column(
                  children: [
                   RaisedButton(
                      child: Text('Search MyGiggz'),
                      onPressed: () async {
                        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2){
                          return LoadingScreen();
                        }));
                        //So that I put my info in Myself.userData if logged in:
                        await perhapsLoggedIn;
                        Navigator.pushReplacement(context, MaterialPageRoute(settings: RouteSettings(name: routeUsersScreen), builder: (context){
                          return UsersScreen();
                          // return SearchCriteriaScreen();
                        }));
                      }
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: AssetImage('images/michael/IMG-20201208-WA0034.jpg'),
              image: AssetImage('images/michael/saxophone_cropped.jpg'),
              fit: BoxFit.cover
            ),
          ),
        ),
      // ),
    );
  }
}

// // Logo:
// Padding(
//   padding: const EdgeInsets.only(top: 100, right: 10),
//   child: Container(
//     child: Transform(
//         transform: Matrix4.rotationY(pi),
//         alignment: Alignment.center,
//         child: Image(image: AssetImage('images/happy_face_sad_face_masks-no-bg.png'))),
//     height: MediaQuery.of(context).size.height / 14,
//     alignment: Alignment.centerRight,
//   ),
// ),
