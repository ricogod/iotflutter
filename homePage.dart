import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'Temperature.dart';
import 'Humidity.dart';
import 'soilmoisture.dart';
import 'autowater.dart';
import 'dart:async';
import 'listalarm.dart';

class TimeMatcher {
  final String hour;
  final String minute;
  final String second;
  final String weekDay;
  
  List<TimeMatcher> topFiveData = [];

  TimeMatcher({
    required this.hour,
    required this.minute,
    required this.second,
    required this.weekDay,
 
  }); //ganti
  dynamic operator [](String key) {
    switch (key) {
      case 'hour':
        return hour;
      case 'minute':
        return minute;
      case 'topFiveData':
        return topFiveData;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);
  
  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> {
  late DatabaseReference booleanRef;
  late DatabaseReference tempRef;
  late DatabaseReference humRef;
  late DatabaseReference soilRef;
  late Timer _timer;
  late String _currentTime ='';
  late String _currentHour ='';
  late String _currentMinute ='';
  late String _currentSecond ='';
  late String _currentDay ='';
  bool booleanValue = false;
  int temperature = 0;
  int humidity = 0;
  int soil = 0;
  final timeNow = DateTime.now();
  final timeFormat = DateFormat('hh:mm');
  final String hourNow = DateFormat('HH').format(DateTime.now());
  final String minuteNow = DateFormat('mm').format(DateTime.now());
  final String secondNow = DateFormat('ss').format(DateTime.now());
  final streamAlarm = FirebaseFirestore.instance
      .collection('alarm')
      .snapshots(includeMetadataChanges: true);
 final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('alarm').snapshots();
  
  @override
  void initState() {
    super.initState();
    booleanRef = FirebaseDatabase.instance.reference().child('test/value');
    tempRef = FirebaseDatabase.instance.reference().child('test/temp');
    humRef = FirebaseDatabase.instance.reference().child('test/hum');
    soilRef = FirebaseDatabase.instance.reference().child('test/soil');
    _startClock();

    booleanRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          booleanValue = event.snapshot.value as bool;
        });
      }
    });
    tempRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temperature = int.parse(event.snapshot.value.toString());
        });
      }
    });
    humRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          humidity = int.parse(event.snapshot.value.toString());
        });
      }
    });

    soilRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          soil = int.parse(event.snapshot.value.toString());
        });
      }
    });
   
   //place here
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      setState(() {
        _currentTime = DateFormat.Hms().format(currentTime);
        _currentDay =  DateFormat('EEEE').format(DateTime.now());
        _currentHour =  DateFormat('HH').format(DateTime.now());
        _currentMinute =  DateFormat('mm').format(DateTime.now());
        _currentSecond =  DateFormat('ss').format(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A2647),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            const Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Padding(
                    //title
                    padding: EdgeInsets.only(left: 20, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 2.5),
                    child: Row(
                      children: [
                        Text(
                          'Frederico Godwyn',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                            color: Color(0xFFEAE3E3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 25),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TemperatureWidget(
                                        temperature: temperature)));
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Temperature',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFEAE3E3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$temperature°C', //pake variabel entar
                                        style: TextStyle(
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFFCFFE7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF144272),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HumidityWidget(
                                  humidity: humidity,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Humidity',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFEAE3E3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$humidity%', //pake variabel entar
                                        style: TextStyle(
                                          fontSize: 55.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFFCFFE7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF144272),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 25),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SoilmoistureWidget(soil: soil),
                                ));
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Soil Moisture',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFEAE3E3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$soil%', //pake variable entar
                                        style: TextStyle(
                                          fontSize: 55.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFFCFFE7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF144272),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listalarm()));
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            child: Column(
                              children: [
                                Padding(
                                  
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Auto Watering',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Color(0xFFEAE3E3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 12),
                                  child: Row(
                                    children: [
                                      StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        stream: streamAlarm,
                                        builder: (context,
                                            AsyncSnapshot<
                                                    QuerySnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          }
                                          if (snapshot.data == null ||
                                              snapshot.data!.docs.isEmpty) {
                                            return Center(
                                                child:
                                                    Text('No data available'));
                                          }

                                          List<TimeMatcher> timeData =
                                              snapshot.data!.docs.map((e) {
                                            return TimeMatcher(
                                              hour: 
                                                  e.data()['hour'].toString(),
                                              minute:
                                                  e.data()['minute'].toString(),
                                              second:
                                                  e.data()['second'].toString(),
                                              weekDay: 
                                                  e.data()['day'].toString(),
                                              
                                            );
                                          }).toList();
                                       
                                          return Column(
                                            children:
                                                timeData.map((timeMatcher) {
                                                // if(timeMatcher.hour == _currentHour&& timeMatcher.minute == _currentMinute && timeMatcher.second == _currentSecond){
                                                //     booleanValue = true;
                                                //     booleanRef
                                                //     .set(booleanValue);
                                                // }
                                                if(timeMatcher.weekDay == 'Day'){
                                                    if(timeMatcher.hour == _currentHour&& timeMatcher.minute == _currentMinute && timeMatcher.second == _currentSecond){
                                                      booleanValue = true;
                                                      booleanRef
                                                      .set(booleanValue);
                                                    } 
                                                }
                                                else{
                                                  if(timeMatcher.weekDay == _currentDay && timeMatcher.hour == _currentHour&& timeMatcher.minute == _currentMinute && timeMatcher.second == _currentSecond){
                                                      booleanValue = true;
                                                      booleanRef
                                                      .set(booleanValue);
                                                    }
                                                }
                                              return Text(
                                                '',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFFFCFFE7),
                                                ),
                                              );
                                              // Text(
                                              //   '${timeMatcher.weekDay},${timeMatcher.hour}:${timeMatcher.minute}:${timeMatcher.second},  $_currentTime',
                                              //   style: TextStyle(
                                              //     fontSize: 10.0,
                                              //     fontWeight: FontWeight.w700,
                                              //     fontFamily: 'Inter',
                                              //     color: Color(0xFFFCFFE7),
                                              //   ),
                                              // );   for debug only
                                            }).toList(),
                                            
                                          );
                                        },
                                      ),
                                       
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF144272),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () => toggleBooleanValue(),
                      child: Container(
                        width: 343,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Center(
                                child: Text(
                                  booleanValue
                                      ? 'The Watering is in Progress'
                                      : 'Start Watering',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: Color(0xFFFCFFE7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: booleanValue ? Colors.red : Color(0xff3484D7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleBooleanValue() {
    setState(() {
      booleanValue = !booleanValue;
    });

    booleanRef
        .set(booleanValue)
        .then((_) => print('Boolean value updated successfully!'))
        .catchError((error) => print('Failed to update boolean value: $error'));
  }
}
