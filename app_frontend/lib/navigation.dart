import 'package:app/BrainStroke.dart';
import 'package:app/BrainStrokeclass.dart';
import 'package:app/HeartFailure.dart';
import 'package:app/HeartFailureclass.dart';
import 'package:app/History.dart';
import 'package:app/aboutus.dart';

import 'package:app/alzheimer.dart';


import 'package:app/home.dart';
import 'package:app/profile.dart';
import 'package:app/usermanagment.dart';
import 'package:app/testresults.dart';

import 'login.dart';
import 'signup.dart';
// import 'dart:convert';

import 'package:flutter/material.dart';


void navigateToLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()), 
  );
}


void navigateToSignup(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignupPage()), 
  );
}

void navigateToBrainstroke(BuildContext context, BrainStroke brainStroke) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BrainStrockPage(brainStroke: brainStroke)), 
  );
}


void navigateToHeartFailure(BuildContext context, HeartFailure heartfailure){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HeartFailurePage(heartfailure: heartfailure)), 
  );
}

void navigateTohome(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}


void navigateTohistory(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => History()),
  );
}


void navigateToprofile(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()), 
  );
}



void navigateToadmin(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => usermanagment()), 
  );
}

void navigateToTestResults(BuildContext context, List<Extraction> extractions,LabTest labtest , ){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TestResults(labTest: labtest, extractions: extractions,)), 
  );
}

void navigateToaboustus(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => aboutus()), 
  );

}

void navigateToalzheimer(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AlzheimerTestPage()), 
  );

}