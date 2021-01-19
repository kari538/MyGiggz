import 'edit_profile_screen.dart';
import 'package:my_giggz/myself.dart';
import 'package:my_giggz/screens/my_messages_screen.dart';
import 'package:my_giggz/profile_menu.dart';
import 'edit_visible_screen.dart';
import 'loading_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/my_firebase.dart';
import 'edit_price_screen.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/giggz_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // const ProfileScreen({@required this.userData});
  // const ProfileScreen();

  // final String firstName;
  final Map<String, dynamic> userData = Myself.userData;

  Widget actionTile(
      {@required BuildContext context,
      @required String text,
      /* @required String value, */ @required String field,
      @required Object goto /* @required Function(String) goto,  @required Function([dynamic value]) goto,*/
      }) {
    return GestureDetector(
      child: nonActionTile(context: context, text: text, field: field, style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationThickness: 2)),
      onTap: () async {
        // String newValue = await Navigator.push(context, MaterialPageRoute(builder: (context) {
        var newValue = await Navigator.push(context, MaterialPageRoute(builder: (context) {
          // return EditPriceScreen(userData[field]);
          // return goto('${userData[field]}');
          return goto;
        }));
        if (newValue != null) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LoadingScreen(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
          // Navigator.push(context, MaterialPageRoute(builder: (context){
          //   return LoadingScreen();
          // }));
          print('New value is $newValue');
          String myUid = MyFirebase.authObject.currentUser.uid;
          await MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).update(
            // {field: '$newValue'},
            {field: newValue},
            // SetOptions(merge: true)  //If using .set() instead of .update()
          );
          Navigator.pop(context);
          // userData.remove(kFieldPrice);
          // userData.putIfAbsent(kFieldPrice, () => newValue);
          userData.remove(field);
          userData.putIfAbsent(field, () => newValue);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              // pageBuilder: (context, animation1, animation2) => ProfileScreen(userData: userData),
              pageBuilder: (context, animation1, animation2) => HomeScreen(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        }
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        //   return ProfileScreen(userData: userData);
        // },));
      },
    );
  }

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
          Expanded(child: Text('${userData[field]}', textAlign: TextAlign.end, style: style ?? Theme.of(context).textTheme.bodyText2)),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(thickness: 2, height: 2, color: Colors.blueGrey);
  }

  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    return Scaffold(
      appBar: AppBar(actions: [ProfileMenu()]
          // [PopupMenuButton(itemBuilder: (context) => profileMenu(context), onSelected: (value){
          //   value();
          // },),],
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Container(
            //     child: Image(image: AssetImage('images/happy_face_sad_face_masks-no-bg.png')),
            //     height: MediaQuery.of(context).size.height / 20,
            //     alignment: Alignment.centerLeft,
            //   ),
            // ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: /*MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height :*/ MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage('images/michael/IMG-20201208-WA0035.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.width/4,
                  // width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.width/4,
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
                                child: Text('Welcome ${userData[kFieldFirstName]}', style: fancyText.copyWith(fontSize: 32, shadows: fancyShadows)),
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
                              child: GestureDetector(
                                child: FittedBox(child: Text('Edit profile')),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return EditProfileScreen();
                                  }));
                                },
                              ),
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
                    Container(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Icon(Icons.message, size: 30),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            // return SearchScreen();
                            return MyMessagesScreen();
                          }));
                        },
                      ),
                      alignment: Alignment.centerRight,
                      // color: Colors.blue,
                    ),
                  // ),
                  // Expanded(
                  //   flex: 5,
                    // child:
                  SingleChildScrollView(  //This doesn't scroll anymore...
                      child:
                      Column(
                        children: [
                          divider(),
                          actionTile(
                            context: context, text: 'My pay rate:', /*value: '${userData[kFieldPrice]}',*/ field: kFieldPrice,
                            goto: EditPriceScreen((userData[kFieldPrice])),
                            // goto: (String field) {
                            //   return EditPriceScreen(field);
                            // },
                          ),
                          divider(),
                          actionTile(
                            context: context, text: 'Profile is visible:', /*value: '${userData[kFieldPrice]}',*/ field: kFieldVisible,
                            goto: EditVisibleScreen((userData[kFieldVisible])),
                            // goto: (String field) {
                            //   return EditVisibleScreen(field);
                            // },
                          ),
                          divider(),
                          nonActionTile(context: context, text: 'User type:', field: kFieldUserType),
                          divider(),
                          nonActionTile(context: context, text: 'Rating:', field: kFieldRating),
                          divider(),
                          nonActionTile(context: context, text: 'Verified:', field: kFieldVerified),
                          divider(),
                          nonActionTile(context: context, text: 'Portfolio:', field: kFieldPortfolio),
                          divider(),
                          nonActionTile(context: context, text: 'My Wallet:', field: kFieldWallet),
                          SizedBox(height: 20),
                          RaisedButton(
                            child: Text('Log out', style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              MyFirebase.logOut();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
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
