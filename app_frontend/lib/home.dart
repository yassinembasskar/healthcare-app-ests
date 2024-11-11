import 'dart:io';

import 'package:app/aboutus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'var.dart';
import 'BrainStrokeclass.dart';
import 'HeartFailureclass.dart';
import 'navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

File? _image;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  bool isSelected = false;

  Future<void> getBrainStrokeComponents() async {
    final url = Uri.parse('$ip/BrainStroke/GetComponent');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"id_patient": id_patient}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('BrainStroke components saved successfully.');

        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('response : $responseBody');

        BrainStroke brainStrokeResponse = BrainStroke.fromJson(responseBody);
        print(brainStrokeResponse);

        navigateToBrainstroke(context, brainStrokeResponse);
      } else {
        print(
            'Failed to save BrainStroke components. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving BrainStroke components: $e');
    }
  }

  Future<void> getHeartFailureComponents() async {
    final url = Uri.parse('$ip/HeartFailure/GetComponent');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"id_patient": id_patient}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('heartfailure components saved successfully.');

        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('response : $responseBody');

        HeartFailure heartfailureresppp = HeartFailure.fromJson(responseBody);

        navigateToHeartFailure(context, heartfailureresppp);
      } else {
        print(
            'Failed to save heartfailure components. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving heartfailure components: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 16.0),
        child: Container(
          color: Color(0xFFD7EFF7),
          child: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: SizedBox(
                height: AppBar().preferredSize.height + 30.0,
                child: Center(
                  child: Image.asset(
                    'images/logo.png',
                    height: (AppBar().preferredSize.height + 30.0) * 0.8,
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Home(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        color: Color(0xFFD7EFF7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(14),
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  size: 36,
                ),
                onPressed: () => _onItemTapped(0),
                color: _selectedIndex == 0 ? Color(0xFF519CD7) : Colors.black,
              ),
            ),
            Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(14),
                color: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.history,
                    size: 36,
                  ),
                  onPressed: () => _onItemTapped(1),
                  color: _selectedIndex == 1 ? Color(0xFF519CD7) : Colors.black,
                )),
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Color(0xFF519CD7),
                      borderRadius: BorderRadius.circular(40)),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 34,
                    ),
                    onPressed: () => _onItemTapped(2),
                    color: Colors.black,
                  ),
                )),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(14),
              child: IconButton(
                icon: Icon(
                  Icons.support_agent_outlined,
                  size: 36,
                ),
                onPressed: () => _onItemTapped(3),
                color: _selectedIndex == 3 ? Color(0xFF519CD7) : Colors.black,
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(14),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  size: 36,
                ),
                onPressed: () => _onItemTapped(4),
                color: _selectedIndex == 4 ? Color(0xFF519CD7) : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container Home() {
    return Container(
      width: double.infinity,
      color: Color(0xFFD7EFF7),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              print("heart fialure tapped!");
              getHeartFailureComponents();
            },
            child: TestCard('HEART FAILURE TEST',
                'Assess your risk of heart failure with our AI-powered tool. Get personalized insights and recommendations based on your health data.'),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              print("Brain Stroke tapped!");
              getBrainStrokeComponents();
            },
            child: TestCard('BRAIN STROKE TEST',
                'Evaluate your risk of experiencing a brain stroke using our advanced AI model. Receive tailored advice to help you manage and mitigate potential risks.'),
          ),
        ],
      ),
    );
  }

  Container TestCard(String testname, String discription) {
    return Container(
      width: 350,
      // height: 250,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            testname,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF519CD7)),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            discription,
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 91, 112, 128)),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        navigateTohome(context);
        break;
      case 1:
        navigateTohistory(context);
        break;
      case 2:
        _Importimage();
        break;
      case 3:
        navigateToaboustus(context);
        break;
      case 4:
        navigateToprofile(context);
        break;
      default:
    }
  }

  void _Importimage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Choose your picture ",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue,
                    ),
                    child: Image.asset(
                      'images/camera.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue,
                    ),
                    child: Image.asset(
                      'images/file.jpg',
                      width: 50,
                      height: 50,
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmPage()),
      );
    }
  }
}
