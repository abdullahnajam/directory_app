
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
// ignore: constant_identifier_names

const secondaryColor=Color(0xff583ba9);
const primaryColor=Color(0xff7f56da);

DateFormat birthDayFormat = DateFormat('MM/dd/yyyy');
DateFormat timeFormat = DateFormat('hh:mm a');
DateFormat timeFormat1 = DateFormat('HH:mm');
DateFormat dateFormatDetail = DateFormat('MMMM d, yyyy');
DateFormat reportDateTimeFormat = DateFormat('MM/dd/yy hh:mm');
DateFormat reportDateFormat = DateFormat('d MMM');
DateFormat reportTimeFormat = DateFormat('hh:mm');
final graphDateFormat = new DateFormat('dd MMM');
final exerciseFormat = new DateFormat('dd/MM/yy, HH:mm');


String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
const placeholder = 'https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png';
const placeholderEvent = 'https://www.northland.edu/wp-content/uploads/2015/09/event_placeholder1-800x500.png';





final dfampm = new DateFormat('E, MMM dd HH:mm');
final df = new DateFormat('dd-mm-yyyy');
final tf = new DateFormat('HH:mm');

