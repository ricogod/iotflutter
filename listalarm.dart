import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iotflutterfixparah/autowater.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//make me a statful widget
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
class listalarm extends StatefulWidget {
  const listalarm({Key? key}) : super(key: key);

  @override
  _listalarmState createState() => _listalarmState();
}

//make me the class 
class _listalarmState extends State<listalarm> {
  //make me a variable
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('alarm').snapshots();
      late DatabaseReference booleanRef;
      late String _currentTime ='';
  late String _currentHour ='';
  late String _currentMinute ='';
  late String _currentSecond ='';
  late String _currentDay ='';
  late Timer _timer;
  final streamAlarm = FirebaseFirestore.instance
      .collection('alarm')
      .snapshots(includeMetadataChanges: true);

  @override

  void initState() {
    super.initState();
    booleanRef = FirebaseDatabase.instance.reference().child('test/value');
   _startClock();
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2647),
      body: CustomScrollView(

        slivers: [
          SliverAppBar(
          expandedHeight: 220,
          floating: true,
          pinned: false,
          title: Text('',
            style: TextStyle(
             color: Color(0xFFEAE3E3),

              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'inter'
            ),
            ),
          backgroundColor: const Color(0xFF0A2647),
          flexibleSpace: FlexibleSpaceBar(
            
            background: Container(
              color: const Color(0xFF0A2647),
            ),
            centerTitle: true,
            title: Text('Auto Watering',
            style: TextStyle(
             color: Color(0xFFEAE3E3),

              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'inter'

            ),
            ),
            ),
          ),
        
          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(right: 20,left:20),
              child: Column(
               children:[ 
                Align(
                  alignment: Alignment.centerRight,
                 child: Column(
                   children: [
                     Padding(
                        padding: const EdgeInsets.only(top:25,right: 15),
                        child:
                         IconButton(
                          icon: Icon(
                            Icons.add,
                            color: const Color(0xffFCFFE7),
                            size: 45,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  autoWaterWidget()),
                            );
                          },
                                   ),
                       
                     ),
                   ],
                 ),
                ),
              //make stream builder for listview alarm and can be scrolled
              StreamBuilder<QuerySnapshot>(
                  stream: _usersStream, //ganti
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                            String day =  data['day'].toString();
                            String hour = data['hour'].toString().padRight(2,'0');
                            String minute = data['minute'].toString();
                        return Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8,bottom:15),
                          child: Container(
                            width: 322,
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff144272),
                            ),
                            child: Column(
                                children: [
                                  Padding(padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(left:10,top: 8,),
                                            child: Text(
                                                'Every $day',
                                                style: TextStyle(
                                                  color: const Color(0xffFCFFE7),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'inter'
                                                ),
                                                                               ),
                                                                               
                                           ),
                                ]
                                  ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:0,left:12,bottom: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10,top: 10),
                                        child: Text(
                                          '$hour:$minute',
                                          style: TextStyle(
                                            color: const Color(0xffFCFFE7),
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'inter'
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 150),
                                       child: Column(
                                        children: [
                                          Center(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: const Color(0xffFF5E59),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('alarm')
                                                  .doc(document.id)
                                                  .delete();
                                            },
                                          ),
                                          ),
                                        ],
                                       ),

                                      ),
                                    ],
                                  ),
                                  ),
                                ],
                                
                              // trailing: IconButton(
                              //   icon: Icon(
                              //     Icons.delete,
                              //     color: const Color(0xffFF5E59),
                              //   ),
                              //   onPressed: () {
                              //     FirebaseFirestore.instance
                              //         .collection('alarm')
                              //         .doc(document.id)
                              //         .delete();
                              //   },
                              // ),
                              
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
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
                                                      booleanRef
                                                      .set(true);
                                                    } 
                                                }
                                                else{
                                                  if(timeMatcher.weekDay == _currentDay && timeMatcher.hour == _currentHour&& timeMatcher.minute == _currentMinute && timeMatcher.second == _currentSecond){
                                                      
                                                      booleanRef
                                                      .set(true);
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
                                      )
               ],
              ),
             ),
            ],
          ),
            ),
          ),
        ],
      ),
      
    );
  }
}