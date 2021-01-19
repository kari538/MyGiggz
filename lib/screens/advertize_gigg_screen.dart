import 'package:my_giggz/my_types_and_functions.dart';
import 'package:my_giggz/units/giggz_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:my_giggz/myself.dart';
import 'dart:async';
import 'package:my_giggz/firebase_labels.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'preview_gigg_screen.dart';
import 'package:my_giggz/profile_menu.dart';
import 'package:flutter/material.dart';

const double _outerPadding = 20;

class AdvertizeGiggScreen extends StatefulWidget {
  @override
  _AdvertizeGiggScreenState createState() {
    michaelTracker('${this.runtimeType}');
    return _AdvertizeGiggScreenState();
  }
}

class _AdvertizeGiggScreenState extends State<AdvertizeGiggScreen> {
  @override
  void initState() {
    super.initState();
    gigId = findOrCreateDraft();
    giggChangeStream();
  }

  @override
  void dispose() {
    super.dispose();
    giggListener.cancel();
  }

  bool showSpinner = false;
  Map<String, dynamic> giggData;
  StreamSubscription giggListener;
  String myUid = Myself.userData[kFieldUid];
  Future<String> gigId;

  //I use the length of the below list to decide how many controllers and editings I need:
  List<String> giggTextFields = [
    kFieldTitle,
    kFieldLocation,
    kFieldDescription,
    kFieldArtistRequirements,
  ];
  String timeDate = 'timeDate';

  Map<String, bool> editing = {};
  Map<String, TextEditingController> controller = {};

  Future<String> findOrCreateDraft() async {
    String _gigId;
    QuerySnapshot draft;
    try {
      draft = await MyFirebase.storeObject
          .collection(kCollectionGiggz)
          .where(kFieldPoster, isEqualTo: myUid)
          .where(kFieldPublished, isEqualTo: false)
          .get();
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
      FirebaseErrorPopup(context: context, e: e).show();
    }
    if (draft.docs.isNotEmpty) {
      print("Previous draft found");
      _gigId = draft.docs[0].id;
      print(draft);
      return _gigId;
    }
    print("No previous draft found");
    // DocumentReference newDraft = await MyFirebase.storeObject.collection(kCollectionGiggz).doc().;
    try {
      await MyFirebase.storeObject.collection(kCollectionGiggz).doc().set({
        kFieldPoster: myUid,
        kFieldPublished: false,
      });
    } catch (e) {
      GiggzPopup(
        context: context,
        title: e.code,
        desc: e.toString(),
      ).show();
    }
    try {
      draft = await MyFirebase.storeObject
          .collection(kCollectionGiggz)
          .where(kFieldPoster, isEqualTo: myUid)
          .where(kFieldPublished, isEqualTo: false)
          .get();
    } catch (e) {
      GiggzPopup(
        context: context,
        title: e.code,
        desc: e.toString(),
      ).show();
    }
    if (draft.docs.isNotEmpty) {
      _gigId = draft.docs[0].id;
      return _gigId;
    }
    return _gigId;
  }

  void giggChangeStream() async {
    giggListener = MyFirebase.storeObject.collection(kCollectionGiggz).doc(await gigId).snapshots().listen((event) {
      giggData = event.data();
      // presentation = profileData[kFieldPresentation];
      // presentationController.text = '$presentation';
      // tagLineController.text = '${profileData[kFieldTagLine]}';
      // location = profileData[kFieldLocation];
      // locationController.text = '${profileData[kFieldLocation]}';
      for (String field in giggTextFields) {
        controller.addAll({
          field: TextEditingController(text: giggData[field]),
        });
        // String x = 3;
        // print('Key is $key');
        // controller[key].text = profileData[key].toString();
        editing.addAll({
          field: false,
        });
      }
      //   for(String key in profileData.keys)  {
      //     controller.addAll({
      //       key: TextEditingController(),
      //     });
      //     // String x = 3;
      //     // print('Key is $key');
      //   controller[key].text = profileData[key].toString();
      //   // controller[kFieldLocation].text = profileData[kFieldLocation];
      // }
      // print('controller is $controller');

      showSpinner = false;

      setState(() {
        //Build again with new values
        showSpinner = false;
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

  Widget giggTextField(String key) {
    String newValue;
    // return editing[key]
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
                            // MyFirebase.storeObject.collection(kCollectionUserInfo).doc(myUid).update({key: newValue});
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
                  '${giggData != null ? giggData[key] : ''}',
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

  // TextEditingController _timeController = TextEditingController();

  Widget timeDateField() {
    DateTime newValue;
    TimeOfDay newTime;
    DateTime newDate;
    // String newTime;
    // String newDate;
    // double _height = MediaQuery.of(context).size.height;
    // double _width = MediaQuery.of(context).size.width;
    // String _setTime, _setDate;
    // String _hour, _minute, _time;
    // String dateTime;
    // TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 0);

    // Future<Null> _selectTime(BuildContext context) async {
    //   final TimeOfDay picked = await showTimePicker(
    //     context: context,
    //     initialTime: selectedTime,
    //   );
    //   if (picked != null) {
    //     print('Picked time was not null');
    //     setState(() {
    //       selectedTime = picked;
    //       _hour = selectedTime.hour.toString();
    //       _minute = selectedTime.minute.toString();
    //       _time = _hour + ':' + _minute;
    //       _timeController.text = _time;
    //       print('_timeController.text is ${_timeController.text}');
    //       // _timeController.text = 'selectedTime.hour, selectedTime.minute)';
    //     });
    //   } else {
    //     print('Picked time was null');
    //   }
    // }

    return (editing[timeDate] ?? false)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: _outerPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Text('Year'),
                    // DropdownButton(items: null, onChanged: null),
                    // Text('Date'),
                    // DropdownButton(items: null, onChanged: null),
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        // width: 120,
                        child: CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day + 1),
                          onDateChanged: (value) {
                            // newValue = value;
                            newDate = value;
                            print(newValue);
                          },
                        ),
                      ),
                    ),
                    // Text('Time'),
                    // DropdownButton(items: null, onChanged: null),
                  ],
                ),
                TimePicker(
                    context: context,
                    onChanged: (value) {
                      newTime = value;
                      print('newTime in TimePicker onChanged argument is $newTime');
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            newTime = null;
                            newDate = null;
                            editing[timeDate] = false;
                          });
                        }),
                    RaisedButton(
                        child: Text('Save Changes'),
                        onPressed: () async {
                          //If either time or date has changed:
                          if (newTime != null || newDate != null) {
                            // if (newValue != null) {
                            if (newDate == null) {
                              newDate = giggData[kFieldDate];
                            }
                            if (newTime == null) {
                              newTime = giggData[kFieldTime];
                            }
                            newValue = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await MyFirebase.storeObject.collection(kCollectionGiggz).doc(await gigId).update({
                                // MyFirebase.storeObject.collection(kCollectionGiggz).doc('4M3Oz8YFoVMBgpMe1yML').update({
                                kFieldDate: newValue
                              });
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $e');
                              FirebaseErrorPopup(context: context, e: e).show();
                            }
                            newTime = null;
                            newDate = null;
                            newValue = null;
                          }
                          setState(() {
                            editing[timeDate] = false;
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
                  '${giggData != null ? formatTimestamp(giggData[kFieldDate]) : ''}',
                  style: TextStyle(color: Colors.blueGrey.shade100),
                )),
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    setState(() {
                      editing[timeDate] = true;
                    });
                  },
                ),
              ],
            ),
          );
  }

//End field functions------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertize Gigg'),
        actions: [ProfileMenu()],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineText('Title:', context),
              // tagLineField(),
              giggTextField(kFieldTitle),
              divider(),
              HeadlineText('Location:', context),
              giggTextField(kFieldLocation),
              divider(),
              HeadlineText('Time and Date:', context),
              // giggTextField(kFieldTime),
              timeDateField(),
              divider(),
              // HeadlineText('Testing', context),
              // divider(),
              // Text('Presentation:', style: headlineStyle()),
              // divider(),
              HeadlineText('Description:', context),
              // presentationField(),
              giggTextField(kFieldDescription),
              divider(),
              HeadlineText('Artist Requirements:', context),
              giggTextField(kFieldArtistRequirements),
              divider(),
              HeadlineText('Pay Range:', context),
              divider(),
              // HeadlineText('Password:', context),
              // // divider(),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PreviewGiggScreen();
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

class TimePicker extends StatefulWidget {
  TimePicker({@required this.context, this.onChanged});

  final BuildContext context;
  final Function onChanged;

  @override
  _TimePickerState createState() => _TimePickerState(context, onChanged);
}

class _TimePickerState extends State<TimePicker> {
  _TimePickerState(this.context, this.onChanged) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
  }

  final BuildContext context;
  final Function onChanged;
  TextEditingController _timeController = TextEditingController(text: '00:00');
  double _height;
  double _width;
  String _setTime;
  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 0);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      print('Picked time was not null');
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = (_hour == '0' ? '00' : _hour) + ':' + (_minute == '0' ? '00' : _minute);
        _timeController.text = _time;
        print('_timeController.text is ${_timeController.text}');
      });
      onChanged(selectedTime);
    } else {
      print('Picked time was null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Text(
        //   'Choose Time',
        //   style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        // ),
        InkWell(
          onTap: () {
            _selectTime(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: _width / 3,
            height: _height / 11,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              // border: ,
              // borderRadius:
            ),
            child: Text(
              '${_timeController.text}',
              style: TextStyle(fontSize: 40, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            // child: TextFormField(
            //   style: TextStyle(fontSize: 30, color: Colors.black),
            //   textAlign: TextAlign.center,
            //   // onSaved: (String val) {
            //   onChanged: (String val) {
            //     print('Saved time!!');
            //     _setTime = val;
            //   },
            //   enabled: false,
            //   keyboardType: TextInputType.text,
            //   controller: _timeController,
            //   decoration: InputDecoration(
            //       disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            //       // labelText: 'Time',
            //       contentPadding: EdgeInsets.all(5)),
            // ),
          ),
        ),
      ],
    );
  }
}
