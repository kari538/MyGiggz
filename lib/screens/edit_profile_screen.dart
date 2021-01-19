import 'package:flutter/widgets.dart';
import 'package:my_giggz/add_new_media.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_giggz/profile_menu.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/myself.dart';
import 'package:my_giggz/screens/view_profile_screen.dart';

const double _outerPadding = 20;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() {
    michaelTracker('${this.runtimeType}');
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    profileChangeStream();
  }

  @override
  void dispose() {
    super.dispose();
    profileListener.cancel();
  }

  bool showSpinner = false;
  StreamSubscription profileListener;
  Map<String, dynamic> profileData;
  String myUid = Myself.userData[kFieldUid];
  Map<String, dynamic> socialMedia;
  TextEditingController socialMediaController = TextEditingController();

  //I use the length of the below list to decide how many controllers and editings I need:
  List<String> profileTextFields = [
    kFieldLocation,
    kFieldFirstName,
    kFieldLastName,
    kFieldPresentation,
    kFieldTagLine,
  ];

  Map<String, bool> editing = {};
  Map<String, TextEditingController> controller = {};

  void profileChangeStream() {
    profileListener = MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).snapshots().listen((event) {
      profileData = event.data();
      for (String field in profileTextFields) {
        controller.addAll({
          field: TextEditingController(text: profileData[field]),
        });
        editing.addAll({
          field: false,
        });
      }
      socialMedia = profileData[kFieldSocialMedia];
      socialMediaController.text = '$socialMedia';

      showSpinner = false;
      Myself.userData = profileData;

      setState(() {
        //Build again with new values
      });
    });
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(/*vertical:*/ 20),
      child: Divider(thickness: 2, height: 2, color: Colors.blueGrey),
    );
  }

//Field functions:---------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------

  Widget profileTextField(String key) {
    String newValue;
    return (editing[key] ?? false)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
            child: Column(
              children: [
                key == kFieldPresentation
                    ? TextField(
                        onChanged: (value) {
                          newValue = value;
                        },
                        maxLines: 20,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(),
                        controller: controller[key],
                        autofocus: true,
                      )
                    : TextField(
                        onChanged: (value) {
                          newValue = value;
                        },
                        decoration: InputDecoration(),
                        controller: controller[key],
                        autofocus: true,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            newValue = null;
                            editing[key] = false;
                          });
                        }),
                    RaisedButton(
                        child: Text('Save Changes'),
                        onPressed: () {
                          if (newValue != null) {
                            showSpinner = true;
                            MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).update({key: newValue});
                            newValue = null;
                          }
                          setState(() {
                            editing[key] = false;
                          });
                        }),
                  ],
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Text(
                  '${profileData != null ? profileData[key] : ''}',
                  style: TextStyle(color: Colors.blueGrey.shade100),
                )),
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    setState(() {
                      editing[key] = true;
                    });
                  },
                ),
              ],
            ),
          );
  }

  bool isEditingSocialMedia = false;
  Map<String, dynamic> newSocialMediaMap;
  Map<String, dynamic>
      originalSocialMediaMap; //For some reason I can't make this equal the above... so the comparison doesn't work. Had to go around it.

  Widget socialMediaField() {
    bool isEmpty = newSocialMediaMap != null
        ? false
        : profileData != null
            ? profileData[kFieldSocialMedia].isEmpty ?? true
            : true;
    print('isEmpty is $isEmpty');
    if (isEmpty && !isEditingSocialMedia) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
        child: Column(
          children: [
            Row(
              children: [Text('' /*'${profileData[kFieldSocialMedia]}'*/)],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Icon(Icons.edit),
                onTap: () {
                  setState(() {
                    isEditingSocialMedia = true;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    if (isEditingSocialMedia) {
      Map<String, dynamic> socialMediaMap = profileData[kFieldSocialMedia];
      print('socialMediaMap is $socialMediaMap');
      newSocialMediaMap = socialMediaMap; //These are now one and the same, until socialMediaMap is declared again.
      originalSocialMediaMap = {};
      for (String category in socialMediaMap.keys) {
        originalSocialMediaMap.addAll({category: {}});
        for (String mediaName in socialMediaMap[category].keys) {
          String mediaLink = socialMediaMap[category][mediaName];
          originalSocialMediaMap[category].addAll({mediaName: mediaLink});
        }
      }
      print('newSocialMediaMap is $newSocialMediaMap');
      List<Widget> children = [];
      // Map<String, TextEditingController> mediaControllers = {};
      List<TextEditingController> nameControllers = [];
      List<TextEditingController> linkControllers = [];
      List<String> nameValues = [];
      List<String> linkValues = [];
      int mediaCount = 0;

      if (newSocialMediaMap.isEmpty) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
          child: Container(
            height: 100,
            child:
                Center(child: Text('Press the "+" button to add your first Social Media link', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor))),
          ),
        ));
      } else {
        for (String category in newSocialMediaMap.keys) {
          children.add(Text('$category',
              style: TextStyle(
                  color: category == 'Facebook'
                      ? Colors.lightBlue
                      : category == 'YouTube'
                          ? Colors.red
                          : Colors.amber,
                  fontWeight: FontWeight.bold)));
          for (String mediaName in newSocialMediaMap[category].keys) {
            String mediaLink = newSocialMediaMap[category][mediaName];
            int thisMedia = mediaCount;
            // mediaControllers.addAll({
            //   mediaName: TextEditingController(text: mediaName)
            // });
            nameControllers.add(TextEditingController(text: '$mediaName'));
            linkControllers.add(TextEditingController(text: '$mediaLink'));
            nameValues.add('$mediaName');
            // print('nameValues is $nameValues');
            // print('nameValues[mediaCount] is ${nameValues[mediaCount]}');
            linkValues.add('$mediaLink');
            children.add(
              TextField(
                onChanged: (value) {
                  // print('name values');
                  nameValues[thisMedia] = value;
                  // print('Value no $thisMedia');
                  // print('is ${nameValues[thisMedia]}');
                },
                decoration: InputDecoration(
                  hintText: 'media name',
                  labelText: 'Media name (optional):',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                // controller: nameControllers[mediaName],
                controller: nameControllers[thisMedia],
              ),
            );
            children.add(
              TextField(
                onChanged: (value) {
                  linkValues[thisMedia] = value;
                },
                decoration: InputDecoration(
                  hintText: 'link address',
                  labelText: 'Link address (URL) to your media:',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                minLines: 1,
                maxLines: 3,
                // controller: linkControllers[mediaName],
                controller: linkControllers[mediaCount],
              ),
            );
            children.add(
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton(
                    child: Icon(Icons.delete_forever, size: 30),
                    itemBuilder: (context) {
                      List<PopupMenuItem<dynamic>> items = [
                        PopupMenuItem(
                            child: Text('Delete'),
                            value: () {
                              print('Clicked delete');
                              setState(() {
                                newSocialMediaMap[category].remove(nameValues[thisMedia]);
                              });
                              if (newSocialMediaMap[category].isEmpty) {
                                setState(() {
                                  newSocialMediaMap.remove(category);
                                });
                              }
                            }),
                        PopupMenuItem(
                            child: Text('Cancel'),
                            value: () {
                              print('Clicked cancel');
                            }),
                      ];
                      return items;
                    },
                    onSelected: (value) {
                      value();
                    },
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
            );
            mediaCount++;
          }
        }
      }

      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            child: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                addNewMedia(
                    context: context,
                    newSocialMediaMap: newSocialMediaMap,
                    setParentState: () {
                      print('Setting state of EditProfileScreen');
                      setState(() {
                        // newSocialMediaMap
                      });
                    });
              },
              backgroundColor: Colors.pink,
            ),
            alignment: Alignment.center,
          ),
        ),
      );

      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                newSocialMediaMap = null;
                setState(() {
                  isEditingSocialMedia = false;
                });
              },
            ),
            RaisedButton(
              child: Text('Save Changes'),
              onPressed: () {
                print('Pressed save changes');
                bool changed = false;
                Map<String, dynamic> newerSocialMediaMap = {};
                mediaCount = 0;
                for (String category in socialMediaMap.keys) {
                  newerSocialMediaMap.addAll({category: {}});
                  for (String mediaName in socialMediaMap[category].keys) {
                    if(nameValues[mediaCount]==''){
                      nameValues[mediaCount] = linkValues[mediaCount];
                    }
                    newerSocialMediaMap[category].addAll({nameValues[mediaCount]: linkValues[mediaCount]});
                    print('mediaCount is $mediaCount and $mediaName');
                    mediaCount++;
                  }
                }
                print('New Social Media map is $newerSocialMediaMap');
                print('Original Social Media map is $originalSocialMediaMap');

                //Ok, so using the string equality below, I do get the Maps to be equal. But now they're equal all the time... I leave it at this.
                // if(MapEquality().equals(originalSocialMediaMap, newerSocialMediaMap)){
                if (originalSocialMediaMap.toString() == newerSocialMediaMap.toString()) {
                  print('Maps are equal'); //They are never equal using MapEquality...
                }
                //Check if new map is any different from the old map (otherwise spinner will go on forever, coz no new entry in the stream)
                if (!MapEquality().equals(originalSocialMediaMap, newerSocialMediaMap)) {
                  // if (!(originalSocialMediaMap.toString() == newerSocialMediaMap.toString())) {
                  changed = true;
                  print('Maps are not equal');
                }
                if (changed) {
                  showSpinner = true;
                  MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).update({kFieldSocialMedia: newerSocialMediaMap});
                }
                newerSocialMediaMap = null;
                setState(() {
                  isEditingSocialMedia = false;
                  showSpinner = false;
                });
              },
            ),
          ],
        ),
      );

      return Container(
        decoration: BoxDecoration(
          color: isEditingSocialMedia ? Colors.white10 : Colors.transparent,
          // image: DecorationImage(child: Container())
        ),
        // constraints: BoxConstraints(
        //   minWidth: MediaQuery.of(context).size.width+100,
        // ),
        // margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: _outerPadding, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        // color: isEditingSocialMedia ? Colors.white12 : Colors.transparent,
        width: MediaQuery.of(context).size.width + 100,
        // height: 500,
      );
    } else {
      List<Widget> children = [];
      for (String category in profileData[kFieldSocialMedia].keys) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('$category',
                style: TextStyle(
                    color: category == 'Facebook'
                        ? Colors.lightBlue
                        : category == 'YouTube'
                            ? Colors.red
                            : Colors.amber,
                    fontWeight: FontWeight.bold)),
          ),
        );
        for (String mediaName in profileData[kFieldSocialMedia][category].keys) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name:
                  Expanded(child: Text('$mediaName')),
                  SizedBox(width: 20),
                  //Link:
                  Expanded(
                      child: Text(
                    '${profileData[kFieldSocialMedia][category][mediaName]}',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.lightBlueAccent),
                  )),
                ],
              ),
            ),
          );
        }
      }

      children.add(
        Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            child: Icon(Icons.edit),
            onTap: () {
              setState(() {
                isEditingSocialMedia = true;
              });
            },
          ),
        ),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    }
  }

//End field functions------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [ProfileMenu()],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineText('Profile Picture:', context),
              // Text('Profile Picture:', style: headlineStyle()),
              divider(),
              HeadlineText('Tag line:', context),
              // tagLineField(),
              profileTextField(kFieldTagLine),
              divider(),
              HeadlineText('Location:', context),
              profileTextField(kFieldLocation),
              divider(),
              // HeadlineText('Testing', context),
              // divider(),
              // Text('Presentation:', style: headlineStyle()),
              // divider(),
              HeadlineText('Presentation:', context),
              // presentationField(),
              profileTextField(kFieldPresentation),
              divider(),
              HeadlineText('Social Media:', context),
              socialMediaField(),
              divider(),
              HeadlineText('First Name:', context),
              profileTextField(kFieldFirstName),
              divider(),
              HeadlineText('Last Name:', context),
              profileTextField(kFieldLastName),
              divider(),
              HeadlineText('E-mail address:', context),
              divider(),
              HeadlineText('Password:', context),
              // divider(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.remove_red_eye_outlined,
          size: 27,
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return ViewProfileScreen(userData: Myself.userData);
          }));
        },
      ),
    );
  }
}

class HeadlineText extends Text {
  const HeadlineText(this.text, this.context) : super(text);
  final String text;
  final BuildContext context;

  TextStyle headlineStyle() {
    TextStyle _style = Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.tealAccent, fontSize: 20);
    return _style;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text('$text', style: headlineStyle()),
    );
  }
}
