// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class EditVisibleScreen extends StatelessWidget {
  const EditVisibleScreen(this.visible);
  // final String visible;
  final bool visible;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your current visibility is $visible'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(child: Text('Cancel'), onPressed: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(width: 10),
                  RaisedButton(child: Text('Change'), onPressed: (){
                    // Navigator.pop(context, visible=='true' ? 'false' : 'true');
                    Navigator.pop(context, visible ? false : true);
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
