import 'package:flutter/material.dart';

ThemeData giggzTheme = ThemeData.dark().copyWith(
  // colorScheme: ColorScheme.dark(
  //   onSurface:
  // ),
//  scaffoldBackgroundColor: const Color(0xff1D1E33), //Angela's BMI calculator scaffoldBackgroundColor
  scaffoldBackgroundColor: const Color(0xff131529),
  //Angela's BMI calculator scaffoldBackgroundColor - 10 on all
  appBarTheme: AppBarTheme().copyWith(
    color: Colors.black,
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(fontSize: 18),
  ),
  buttonTheme: ButtonThemeData().copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    buttonColor: Colors.indigo,
//    disabledColor: Colors.blueGrey,
  ),
  // inputDecorationTheme: InputDecorationTheme().copyWith(
    // hintStyle: TextStyle(color: Colors.pink),
  // ),
  // hint
  popupMenuTheme: PopupMenuThemeData(
    // color: Colors.blueGrey.shade900,
    color: Colors.white,
    textStyle: TextStyle(
      fontSize: 18,
      color: Color(0xff131529),
    ),
  ),
  // iconTheme: IconThemeData(color: Colors.white)
);

TextStyle fancyText = TextStyle(
  fontFamily: 'Pacifico',
  fontSize: 28,
);

List<Shadow> fancyShadows = [
  Shadow(
    color: Colors.black,
    offset: Offset(2, 2),
  ),

];