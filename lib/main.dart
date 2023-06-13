import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iotflutterfixparah/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,  
        home: homePage(),
      );
    
  }
}