import 'screens/advertize_gigg_screen.dart';
import 'screens/about_screen.dart';
import 'package:my_giggz/screens/edit_profile_screen.dart';
import 'package:my_giggz/screens/login_screen.dart';
import 'package:my_giggz/screens/user_type_screen.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'constants.dart';
import 'package:my_giggz/screens/home_screen.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/myself.dart';
import 'screens/view_profile_screen.dart';
import 'package:my_giggz/screens/giggz_screen.dart';
import 'package:my_giggz/screens/users_screen.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  void backToLandingScreen(BuildContext context) {
    print(NavigationHistoryObserver().history);
    bool foundProfileRoute = false;
    bool foundUsersRoute = false;
    for (Route route in NavigationHistoryObserver().history) {
      print(route.settings.name);
      if (route.settings.name == routeHomeScreen) {
        foundProfileRoute = true;
        break;
      } else if (route.settings.name == routeUsersScreen) {
        foundUsersRoute = true;
        // break;
      }
    }
    if (foundProfileRoute) {
      print('Found Profile route!');
      Navigator.popUntil(context, ModalRoute.withName(routeHomeScreen));
    } else if (foundUsersRoute) {
      print('Found Users route!');
      Navigator.popUntil(context, ModalRoute.withName(routeUsersScreen));
    } else {
      print('Didn\'t find route.');
      // Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  List<PopupMenuEntry> profileMenu(BuildContext context) {
    bool isLoggedIn = MyFirebase.authObject.currentUser == null ? false : true;
    return [
      PopupMenuItem(
          child: Text('🔍 Search Users'),
          value: () {
            backToLandingScreen(context);
            if (NavigationHistoryObserver().top.settings.name != routeUsersScreen) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: routeUsersScreen),
                      builder: (context) {
                        return UsersScreen();
                      }));
            }
          }),

      PopupMenuItem(
          child: Text('🔍 Search Giggz'),
          value: () {
            backToLandingScreen(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GiggzScreen();
            }));
          }),

      PopupMenuItem(
          child: Text('📰 Advertize Gigg'),
          value: () {
            backToLandingScreen(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AdvertizeGiggScreen();
            }));
          }),

      PopupMenuItem(
          child: Text('About'),
          value: () {
            backToLandingScreen(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AboutScreen();
            }));
          }),

      isLoggedIn
          ? PopupMenuItem(
              child: Text('🏠 Home'),
              value: () {
                backToLandingScreen(context);
                if (NavigationHistoryObserver().top.settings.name != routeHomeScreen) {
                  print('HomeScreen is not on top');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: routeHomeScreen),
                          builder: (context) {
                            return HomeScreen();
                          }));
                } else {
                  print('HomeScreen is on top');
                }
              })
          : null,

      isLoggedIn
          ? PopupMenuItem(
              child: Text('👤‍ My Profile'),
              value: () {
                backToLandingScreen(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewProfileScreen(userData: Myself.userData);
                }));
              })
          : null,

      isLoggedIn
          ? PopupMenuItem(
              child: Text('✏️ Edit My Profile'),
              value: () {
                backToLandingScreen(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfileScreen();
                }));
              })
          : null,

      isLoggedIn
          ? null
          : PopupMenuItem(
              child: Text('Register Account'),
              value: () {
                // backToLandingScreen(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserTypeScreen(popWhenDone: true);
                }));
              }),

      isLoggedIn
          ? PopupMenuItem(
              child: Text('❎ Log out'),
              value: () async {
                await MyFirebase.authObject.signOut();
                // MyFirebase.logOut();
                print('User in log out is ${MyFirebase.authObject.currentUser}');
                Myself.userData = null;
                Navigator.popUntil(context, (route) {
                  if (route.isFirst) return true;
                  return false;
                });
              })
          : PopupMenuItem(
              child: Text('Log in'),
              value: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen(popWhenDone: true);
                }));
              }),

      // PopupMenuItem(child: Text('Log out'), value: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context){
      //     return SearchScreen();
      //   }));
      // }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => profileMenu(context),
      onSelected: (value) {
        value();
      },
    );
  }
}
