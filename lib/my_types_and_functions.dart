import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_labels.dart';

enum UserType {
  artist,
  artistHirer,
  artistServices
}

const String kArtist = 'Artist';
const String kArtistHirer = 'Client';
const String kArtistServices = 'Artist Services';

Map<String, Color> socialMediaTagColor = {
  kSubFieldYouTube : Colors.red,
  kSubFieldFacebook: Colors.lightBlue,
};

String capitalizeFirst(String string) {
  if(string == null || string == '') return '';
  return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
}

String userDisplay(UserType userType) {
  ///These must never change! If they change, the entire database must be updated accordingly.
  String displayText;
  switch (userType) {
    case UserType.artist:
      displayText = kArtist;
      break;
    case UserType.artistHirer:
      displayText = kArtistHirer;
      break;
    case UserType.artistServices:
      displayText = kArtistServices;
      break;
  }
  return displayText;
}

String formatTimestamp(Timestamp _timeStamp){
  String formattedTimestamp = '';
  if (_timeStamp != null) {
    int dayDate = _timeStamp.toDate().day;
    int weekDay = _timeStamp.toDate().weekday;
    int month = _timeStamp.toDate().month;
    String date = _timeStamp.toDate().toString();
    String clockStroke = date.substring(11, 16);
    String year = date.substring(0,4);
    String thisYear = DateTime.now().toString().substring(0,4);
    year = year == thisYear ? '' : ' $year';

    Map<int, String> dayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7 : 'Sun',
    };
    Map<int, String> monthNames = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7 : 'Jul',
      8 : 'Aug',
      9 : 'Sep',
      10 : 'Oct',
      11 : 'Nov',
      12 : 'Dec',
    };

    // formattedTimestamp = "${dayNames[weekDay]} $dayDate/$month $b:$z";
    formattedTimestamp = "${dayNames[weekDay]} $dayDate ${monthNames[month]}$year, $clockStroke";
  }
  // print("Attempt at format: $formattedTimestamp");
  return formattedTimestamp;
}
