import 'package:my_giggz/myself.dart';
import 'screens/view_profile_screen.dart';
import 'package:my_giggz/screens/giggz_screen.dart';
import 'package:my_giggz/screens/users_screen.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return  PopupMenuButton(itemBuilder: (context) => profileMenu(context), onSelected: (value){
      value();
    },);
  }
  List<PopupMenuEntry> profileMenu(BuildContext context){
    return [
      PopupMenuItem(child: Text('Search Users'), value: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
           return UsersScreen();
        }));
      }),
      PopupMenuItem(child: Text('Search Giggz'), value: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return GiggzScreen();
        }));
      }),
      PopupMenuItem(child: Text('View my Profile as Visitor'), value: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ViewProfileScreen(userData: Myself.userData);
        }));
      }),
      // PopupMenuItem(child: Text('Search All Users'), value: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context){
      //     return SearchScreen();
      //   }));
      // }),
    ];
  }
}
