import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:iotflutterfixparah/homePage.dart';

class TimeMatcher{
   bool? booleanValue;
  static Timer? globalTimer;
  static void startMatching(){
    globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm').format(now);
      List<String>timeParts=formattedDate.split(":");
      String hourNow=(timeParts[0]);
      String minuteNow=(timeParts[1]);
    });
  } 
}