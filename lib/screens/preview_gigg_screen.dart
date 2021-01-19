import 'package:my_giggz/my_firebase.dart';
import 'package:flutter/material.dart';

class PreviewGiggScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    return Scaffold(
        appBar: AppBar(title: Text('Preview Gigg Ad')),
        body: Column()
    );
  }
}
