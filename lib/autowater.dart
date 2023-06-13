import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class autoWaterWidget extends StatefulWidget {
  @override
  State<autoWaterWidget> createState() => _autoWaterWidgetState();
}

class _autoWaterWidgetState extends State<autoWaterWidget> {
  var hour = 0;
  var minute = 0;
  var second = 0;
  var hourFinal=0;
  var format = '';
  String formattedTime='';
  String timeFormat='AM';
  bool ampm = false;
  String weekDay='Day';
 
  Color _containerColor = Color(0xFF144272);
  Color _textColor = Color(0xFFFCFFE7).withOpacity(0.4); 
  Color _textColor1 = Color(0xFFFCFFE7);  
  final DayHourMinSec=DateFormat('EEE HH:mm:ss');

  bool sunday= false;
  bool monday= false;
  bool tuesday= false;
  bool wednesday= false;
  bool thursday= false;
  bool friday= false;
  bool saturday=false;
  
  bool everyDay=true;

  int activeBoxIndex=7;

  void tapHandle(int index){
    setState(() {
      activeBoxIndex=index;
    });
  }
  


void convert() {
    
    
    //untuk setiap hari
  


     // Write the data to Firestore
  FirebaseFirestore.instance
      .collection('alarm') // Replace with your collection name // Replace with your document ID
      .add({
        'day': weekDay.toString(),
        'hour': hourFinal.toString().padLeft(2,'0'),
        'minute': minute.toString().padLeft(2,'0'), 
        'second': '00',
        // Replace 'formattedTime' with your field name
      })
      .then((value) => print('Data written successfully'))
      .catchError((error) => print('Failed to write data: $error'));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A2647),
        body: Column(
          children: [
            Center(
              child: Padding(padding: EdgeInsets.only(
                top: 50.0,
                bottom: 0,
                left: 60,
                right: 10
                ),
                child: Row(
                  children: [
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 12, 
                      value: hour, 
                      zeroPad: false,
                      infiniteLoop: true,
                      itemWidth: 80,
                      itemHeight: 80,
                      onChanged: (value){
                        setState(() {
                          hour = value;
                          if (ampm==true){
                           hourFinal=hour+12;
                          }
                           else{
                            hourFinal=hour;
                          }
                        });
                       },
                       textStyle:  TextStyle(
                         color:  Color(0xFFFCFFE7).withOpacity(0.4),
                         fontSize: 48,
                         fontWeight: FontWeight.w200,
                              fontFamily: 'Inter',
                       ),
                       selectedTextStyle: TextStyle(
                         color:  Color(0xFFFCFFE7),
                         fontSize: 48,
                          fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                       ),
                      ),
                      Text(':',
                      style: TextStyle(
                         color:  Color(0xFFFCFFE7),
                         fontSize: 48,
                          fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
            
                       ),),
                    NumberPicker(
                      minValue: 0, 
                      maxValue: 59, 
                      value: minute, 
                      zeroPad: true,
                      infiniteLoop: true,
                      itemWidth: 80,
                      itemHeight: 80,
                      onChanged: (value){
                        setState(() {
                          minute = value;
                        });
                       },
                       textStyle:  TextStyle(
                         color:  Color(0xFFFCFFE7).withOpacity(0.4),
                         fontSize: 48,
                         fontWeight: FontWeight.w200,
                              fontFamily: 'Inter',
                       ),
                       selectedTextStyle: TextStyle(
                         color:  Color(0xFFFFFFFF),
                         fontSize: 48,
                          fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
            
                       ),
                      ),
                  Padding(padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                                _textColor=_textColor== Color(0xFFFCFFE7)?Color(0xFFFCFFE7).withOpacity(0.4):Color(0xFFFCFFE7).withOpacity(0.4);
                                _containerColor=_textColor== Color(0xFFFCFFE7)?Color(0xFF144272):Color(0xFF144272);
                                _textColor1=_textColor== Color(0xFFFCFFE7).withOpacity(0.4)?Color(0xFFFCFFE7):Color(0xFFFCFFE7);
                              format='AM'; 
                              ampm=false;
                               if (ampm==true){
                           hourFinal=hour+12;
                          }
                           else{
                            hourFinal=hour;
                          }
                              });

                          },
                          child: Center(
                                child: Text('AM',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w200,
                                  color: _textColor1,
                        
                                ),
                                )
                              ),
                        ),
                         Padding(
                           padding: const EdgeInsets.only(top: 10,bottom: 0,right: 0,left: 0),
                           child: SizedBox(
                            height: 15,
                            width: 10,
                            ),
                         ),
                         GestureDetector(
                            onTap: (){
                              setState(() {
                                _containerColor=_containerColor==Color(0xFF144272)?Color(0xFFFCFFE7):Color(0xFFFCFFE7);
                                _textColor1=_textColor== Color(0xFFFCFFE7)?Color(0xFFFCFFE7).withOpacity(0.4):Color(0xFFFCFFE7).withOpacity(0.4);
                                _textColor=_textColor== Color(0xFFFCFFE7).withOpacity(0.4)?Color(0xFFFCFFE7):Color(0xFFFCFFE7);
                                format='PM';
                                ampm=true;
                                 if (ampm==true){
                                    hourFinal=hour+12;
                                   }
                                  else{
                                    hourFinal=hour;
                                  }
                              });
                            },
                           child: Text('PM',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w200,
                                  color: _textColor,
                         
                                ),
                                )
                         ),
                      ],
                    ),
                    )
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 10,
              right: 0
            ),
            ),
           Padding(padding: EdgeInsets.only(
            left: 0,
            top: 0,
            right: 0,
            bottom : 0
            ),
             child: Column(
              children: [
                Container(
                  width: 366,
                  height: 316,
                  decoration: BoxDecoration(
                    color: Color(0xff144272),
                    borderRadius: BorderRadius.circular(16),

                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only( left: 20,top: 15,right: 0,bottom : 0),
                      
                      child: Row(
                        children: [
                          Text(
                            'Every $weekDay',style: 
                            TextStyle(
                                color: Color(0xFFFCFFE7),
                                fontFamily: 'Inter',
                                fontSize: 21,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      ),
                      Padding(padding: EdgeInsets.only( left: 5,top: 15,),
                        child: Row(
                             children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Sunday';  
                                  tapHandle(0);
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),
                                        color: activeBoxIndex == 0 ? Color(0xffD9D9D9) : Color(0xff144272),
                                      // color: Color(0xff144272), 
                                    ),
                                    child: Center(
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xffFF5E59),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Monday'; 
                                  tapHandle(1); 
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 1 ? Color(0xffD9D9D9) : Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'M',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 1 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Tuesday'; 
                                  tapHandle(2) ;
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 2 ? Color(0xffD9D9D9) : Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'T',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 2 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Wednesday';  
                                  tapHandle(3);
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 3 ? Color(0xffD9D9D9) : Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'W',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 3 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Thursday';  
                                  tapHandle(4);
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 4 ? Color(0xffD9D9D9) : Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'T',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 4 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Friday';  
                                  tapHandle(5);
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 5 ? Color(0xffD9D9D9) : Color(0xff144272),
                                      // Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'F',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 5 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  weekDay='Saturday';  
                                  tapHandle(6);
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 6 ? Color(0xffD9D9D9) : Color(0xff144272),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: activeBoxIndex == 6 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                             ],
                          
                        ),
                      ),
                      
                      Padding(
                                
                                padding: const EdgeInsets.all(12.0),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  everyDay=true;
                                  weekDay='Day';
                                  tapHandle(7);
                                  

                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 110,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      
                                      border: Border.all(
                                        color: Color(0xffD9D9D9)
                                      ),

                                      color: activeBoxIndex == 7 ? Color(0xffD9D9D9) : Color(0xff144272),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Every Day',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: activeBoxIndex == 7 ? Color(0xff144272) : Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                              ),
                      Padding(padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                
                             Padding(
                                
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                 Navigator.pop(context);
                                 
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 85,
                                    height: 35,
                                   
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 23,
                                          color:  Color(0xffD9D9D9) ,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                                        
                              ),
                              Padding(
                                
                                padding: const EdgeInsets.only(left: 140),
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                 convert();
                                  Navigator.pop(context);
                                 
                                  });
                                  
                                },
                                 child:
                                   Container(
                                    width: 85,
                                    height: 35,
                                   
                                    child: Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 23,
                                          color:  Color(0xffD9D9D9) ,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                                          ),
                                                  
                                                           ),
                                        
                              ),
                                
                              ],
                              
                          ),
                      
                      ),
                    ],
                    
                    ),
                ),
                
                Text('hour= $hourFinal minute= $minute format= $format formattedTime= $formattedTime',),
                Text('fix format: $timeFormat',style: 
                TextStyle(
                  color: Color(0xFFFCFFE7),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
                ),
                Text('bool value: $ampm',style:
                TextStyle(
                  color: Color(0xFFFCFFE7),
                ),),
              ],
             ),
            ),
          ],
        ),
      ), 
    );
  }
}