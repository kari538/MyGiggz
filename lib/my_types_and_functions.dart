// import 'package:flutter/material.dart';

enum UserType {
  artist,
  artistHirer,
  artistServices
}

const String kArtist = 'Artist';
const String kArtistHirer = 'Client';
const String kArtistServices = 'Artist Services';

String capitalizeFirst(String string) {
  if(string == null || string == '') return '';
  return "${string[0].toUpperCase()}${string.substring(1)}";
}

String userDisplay(UserType userType) {
  ///These must never change! If they change, the entire database must be updated accordingly.
  String displayText;
  switch (userType) {
    case UserType.artist:
      displayText = 'Artist';
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
