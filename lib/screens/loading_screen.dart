import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool showSpinner = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: ModalProgressHUD(inAsyncCall: showSpinner, child: SizedBox()),
    );
  }
}
