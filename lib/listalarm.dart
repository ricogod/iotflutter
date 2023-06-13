import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//make me a statful widget

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        
        slivers: [
          SliverAppBar(
          expandedHeight: 300,
          floating: true,
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            
            background: Container(
              color: Colors.blue,
            )
          ),
          title: Text('Alarm List'),
          
          ),
        ],
      ),

    );
  }
}