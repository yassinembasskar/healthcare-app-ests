
import 'package:app/BrainStroke.dart';
import 'package:app/BrainStrokeclass.dart';
import 'package:app/HeartFailure.dart';
import 'package:app/HeartFailureclass.dart';
import 'package:app/alzheimer.dart';
import 'package:app/apointement.dart';

import 'package:app/login.dart';
import 'package:app/profile.dart';
import 'package:app/usermanagment.dart';
import 'package:flutter/material.dart';
import 'var.dart';
import 'home.dart';
import 'signup.dart';
import 'History.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 77, 105, 230)),
        useMaterial3: true,
      ),

      home: doctorlist()

    );
  }
}







