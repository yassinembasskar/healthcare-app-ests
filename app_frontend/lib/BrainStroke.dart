import 'package:app/BrainStrokeclass.dart';
import 'package:app/navigation.dart';
import 'package:app/var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/aboutus.dart';
import 'package:app/navigation.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:typed_data';
File? _image;
class BrainStrockPage extends StatefulWidget {
  BrainStroke brainStroke; // Removed `final` to make it mutable

  BrainStrockPage({



    Key? key,
    required this.brainStroke,
  }) : super(key: key);

  @override
  State<BrainStrockPage> createState() => _BrainStrockPageState();
}

class _BrainStrockPageState extends State<BrainStrockPage> {
  TextEditingController heightController = TextEditingController();

  Future<int> GetPrediction() async {
    final url = Uri.parse('$ip/BrainStroke/Prediction');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(widget.brainStroke.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        int prediction = jsonResponse['prediction'];
        print('BrainStroke Prediction : $prediction ');
        return prediction;
      } else {
        print(
            'Failed to save BrainStroke components. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving BrainStroke components: $e');
    }

    return 4444;
  }

  Future<void> saveBrainStrokeComponents() async {
    final url = Uri.parse('$ip/BrainStroke/SaveComponents');

    try {
      print(widget.brainStroke.toJson());
      final response = await http.post(
        url,
        body: jsonEncode(widget.brainStroke.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('BrainStroke components saved successfully.');

        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('response : $responseBody');


        BrainStroke brainStrokeResponse = await BrainStroke.fromJson(responseBody) ;
        print(brainStrokeResponse);

        // navigateToBrainstroke(context, brainStrokeResponse);
        setState(() {
          widget.brainStroke = brainStrokeResponse;
        });


      } else {
        print(
            'Failed to save BrainStroke components. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving BrainStroke components: $e');
    }
  }

  TextEditingController weightcontroller = TextEditingController();
  int _selectedIndex = 0;

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
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
      body: HeartFailure(),
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

  Container HeartFailure() {
    return Container(
      width: double.infinity,
      color: Color(0xFFD7EFF7),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            'BRAIN STROKE TEST',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  testitem('heart_disease', widget.brainStroke.heart_disease,
                      'options'),
                  testitem('avg_glucose_level',
                      widget.brainStroke.avg_glucose_level, 'scan'),
                  testitem('hypertension', widget.brainStroke.hypertension,
                      'options'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  testitem(
                      'work_type', widget.brainStroke.work_type, 'options'),
                  testitem('Residence_type', widget.brainStroke.residence_type,
                      'options'),
                  testitem('ever_married', widget.brainStroke.ever_married,
                      'options'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  testitem('bmi', widget.brainStroke.bmi, 'input'),
                  testitem('smoking_status', widget.brainStroke.smoking_status,
                      'options'),
                ],
              ),
            ],
          )),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if (widget.brainStroke.hypertension == null ||
                  widget.brainStroke.heart_disease == null ||
                  widget.brainStroke.ever_married == null ||
                  widget.brainStroke.work_type == null ||
                  widget.brainStroke.residence_type == null ||
                  widget.brainStroke.avg_glucose_level == null ||
                  widget.brainStroke.bmi == null ||
                  widget.brainStroke.smoking_status == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Missing Information'),
                      content: Text(
                          'In order to get the prediction, please fill in all the information.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              showLoadingDialog(context);

              int prediction = await GetPrediction();
              Navigator.of(context).pop(); // Close the loading dialog

              if (prediction == 0) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'BRAIN STROKE PREDICTION',
                        style: TextStyle(
                            color: Color(0xFF519CD7),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Our artificial intelligence program for brain stroke prediction, utilizing the data you've provided, has indicated that your condition appears stable, and a doctor's visit may not be necessary at this time.",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Normal',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (prediction == 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'BRAIN STROKE PREDICTION',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Our artificial intelligence program for brain stroke prediction, utilizing the data you've provided, has indicated that your condition is critical. We strongly advise you to see a doctor as soon as possible.",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Critical',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(350.0, 50)),
              backgroundColor: MaterialStateProperty.all(Color(0xFF519CD7)),
            ),
            child: Text(
              'DO THE TEST',
              style: TextStyle(color: Color(0xFFD7EFF7), fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container popup() {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
          color: Color(0xFFD7EFF7), borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget testitem(String name, dynamic? value, String type) {
    Widget childWidget;

    print(value);
    if (value != null && value != '' && value != 'null' ) {

      childWidget = Image.asset('images/done.png');
    } else {
      childWidget = Image.asset('images/lock.png');
    }
    return GestureDetector(
      onTap: () {
        showPopup(name, type, context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(5),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF519CD7),
                    Color(0xFF437382),
                  ],
                ),
              ),
              child: Container(
                child: childWidget,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
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

  void showPopup(String name, String type, BuildContext context) {
    TextEditingController _controller = TextEditingController();
    String? selectedOption;
    List<String> options = [];

    // Define options based on the name
    if (name == 'heart_disease' || name == 'hypertension') {
      options = ['Select an option', 'true', 'false'];
    } else if (name == 'work_type') {
      options = [
        'Select an option',
        'Private',
        'Govt_job',
        'children',
        'Self-employed'
      ];
    } else if (name == 'Residence_type') {
      options = ['Select an option', 'Urban', 'Rural'];
    } else if (name == 'smoking_status') {
      options = [
        'Select an option',
        'never smoked',
        'smokes',
        'Unknown',
        'formerly smoked'
      ];
    } else if (name == 'ever_married') {
      options = ['Select an option', 'Yes', 'No'];
    }
    selectedOption = options.isNotEmpty ? options.first : null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF519CD7)),
          ),
          content: type == 'scan'
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'This information needs to be provided by scanning a lab test. Click \'Continue\' to proceed.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(350.0, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF519CD7)),
                      ),
                      child: Text('Continue',
                          style: TextStyle(
                            color: Color(0xFFD7EFF7),
                            fontSize: 20,
                          )),
                    ),
                  ],
                )
              : type == 'input'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Enter the values'),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: heightController,
                          decoration: InputDecoration(
                            hintText: 'Enter your height',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: weightcontroller,
                          decoration: InputDecoration(
                            hintText: 'Enter your weight',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String value = _controller.text;
                            update(name, value);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(350.0, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF519CD7)),
                          ),
                          child: Text('Confirm',
                              style: TextStyle(
                                color: Color(0xFFD7EFF7),
                                fontSize: 20,
                              )),
                        ),
                      ],
                    )
                  : type == 'options'
                      ? SizedBox(
                          height: 50,
                          child: DropdownButton<String>(
                            value: selectedOption,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                update(name, newValue);
                                Navigator.of(context).pop();
                              }
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                          ),
                        )
                      : Text('Invalid type: $type'),
        );
      },
    );
  }

  void update(String name, dynamic value) {
    if (name == 'hypertension') {
      widget.brainStroke.hypertension = value;
      print('new hypertension is added $value ');
    } else if (name == 'heart_disease') {
      widget.brainStroke.heart_disease = value;
      print(name + value.toString());
    } else if (name == 'ever_married') {
      widget.brainStroke.ever_married = value as String;
      print(name + value);
    } else if (name == 'work_type') {
      widget.brainStroke.work_type = value as String;
      print(name + value);
    } else if (name == 'Residence_type') {
      widget.brainStroke.residence_type = value as String;
      print(name + value);
    } else if (name == 'avg_glucose_level') {
      widget.brainStroke.avg_glucose_level = value as double;
      print(name + value.toString());
    } else if (name == 'bmi') {
      double height = double.parse(heightController.text);
      double weight = double.parse(weightcontroller.text);
      double heightInMeters = height / 100;
      widget.brainStroke.bmi =
          (weight / (heightInMeters * heightInMeters)) as int?;
      print(name + (weight / (heightInMeters * heightInMeters)).toString());
    } else if (name == 'smoking_status') {
      widget.brainStroke.smoking_status = value as String;
      print(name + value);
    } else {
      print('Attribute $name not found in BrainStroke');
    }
    saveBrainStrokeComponents();
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