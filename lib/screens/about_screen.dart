import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/profile_menu.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    return Scaffold(
      appBar: AppBar(
        title: Text('About MyGiggz'),
        actions: [ProfileMenu()],
      ),
      body: Center(
        child: Text('Bla bla...'),
      ),
    );
  }
}
