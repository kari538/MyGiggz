import 'package:my_giggz/my_types_and_functions.dart';
import 'register_screen.dart';
import 'package:flutter/material.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({@required this.popWhenDone});
  final bool popWhenDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage('images/michael/IMG-20201208-WA0039.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 0),
                  Text('What kind of user account defines you?', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Pacifico', fontSize: 24)),
                  Column(
                    children: [
                      RaisedButton(
                        child: Text('Artist'),
                        onPressed: () async {
                          print('Pressed Artist. popWhenDone is $popWhenDone');
                          await Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return RegisterScreen(userType: UserType.artist, popWhenDone: popWhenDone);
                          }));
                          if (popWhenDone) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Text('Musicians, comedians, etc...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      SizedBox(height: 20),
                      RaisedButton(
                        child: Text(kArtistHirer),
                        onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return RegisterScreen(userType: UserType.artistHirer, popWhenDone: popWhenDone);
                            }));
                            if (popWhenDone) {
                              Navigator.pop(context);
                            }
                        },
                      ),
                      Text('Club owners, event managers, concert halls, etc...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      SizedBox(height: 20),
                      RaisedButton(
                        child: Text(kArtistServices),
                        onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return RegisterScreen(userType: UserType.artistServices, popWhenDone: popWhenDone);
                            }));
                            if (popWhenDone) {
                              Navigator.pop(context);
                            }
                        },
                      ),
                      Text('Studio recorders, video makers, managers etc...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
