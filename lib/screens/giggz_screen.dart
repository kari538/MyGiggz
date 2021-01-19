import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/profile_menu.dart';
import 'package:flutter/material.dart';

class GiggzScreen extends StatefulWidget {
  @override
  _GiggzScreenState createState() {
    michaelTracker('${this.runtimeType}');
    return _GiggzScreenState();
  }
}

class _GiggzScreenState extends State<GiggzScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giggz'), actions: [ProfileMenu()]),
    );
  }
}
