import 'package:app/BrainStrokeclass.dart';
import 'package:app/HeartFailureclass.dart';
import 'package:app/HeartFailureclass.dart';
import 'package:app/navigation.dart';
import 'package:app/var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HeartFailurePage extends StatefulWidget {
  final HeartFailure heartfailure;

  const HeartFailurePage({Key? key, required this.heartfailure})
      : super(key: key);

  @override
  State<HeartFailurePage> createState() => HeartFailurePageState();
}

class HeartFailurePageState extends State<HeartFailurePage> {
  int _selectedIndex = 0;
  TextEditingController timecontroller = TextEditingController();

  Future<int> GetPrediction() async {
    final url = Uri.parse('$ip/HeartFailure/Prediction');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(widget.heartfailure.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('BrainStroke Prediction ');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        int prediction = jsonResponse['prediction'];
        print('HeartFailure Prediction : $prediction ');
        return prediction;
      } else {
        print(
            'Failed to save HeartFailure components. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving HeartFailure components: $e');
    }

    return 4444;
  }

  Future<void> saveHeartFailureComponents() async {
    final url = Uri.parse('$ip/HeartFailure/SaveComponents');

    try {
      print(widget.heartfailure.toJson());
      final response = await http.post(
        url,
        body: jsonEncode(widget.heartfailure.toJson()),
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
      body: HeartFailuree(),
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

  Container HeartFailuree() {
    return Container(
      width: double.infinity,
      color: Color(0xFFD7EFF7),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            'HEART FAILURE TEST',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      testitem('anaemia', widget.heartfailure.anaemia, 'scan'),
                      testitem('serum sodium', widget.heartfailure.serum_sodium,
                          'scan'),
                      testitem(
                          'diabetes', widget.heartfailure.diabetes, 'scan'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      testitem(
                          'platelets', widget.heartfailure.platelets, 'scan'),
                      testitem('blood_pressure',
                          widget.heartfailure.high_blood_pressure, 'options'),
                      testitem('time', widget.heartfailure.time, 'input'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      testitem(
                          'smoking', widget.heartfailure.smoking, 'options'),
                      testitem('creatinine',
                          widget.heartfailure.creatinine_phosphokinase, 'scan'),
                      testitem('serum creatinine',
                          widget.heartfailure.serum_creatinine, 'scan'),
                    ],
                  )
                ],
              )),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if (widget.heartfailure.anaemia == null ||
                  widget.heartfailure.diabetes == null ||
                  widget.heartfailure.creatinine_phosphokinase == null ||
                  widget.heartfailure.high_blood_pressure == null ||
                  widget.heartfailure.platelets == null ||
                  widget.heartfailure.serum_creatinine == null ||
                  widget.heartfailure.serum_sodium == null ||
                  widget.heartfailure.smoking == null ||
                  widget.heartfailure.time == null) {
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
              print("Prediction: $prediction");

              if (prediction == 0) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'HEART FAILURE PREDICTION',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Our artificial intelligence program for heart failure prediction, utilizing the data you've provided, has indicated that your condition appears stable, and a doctor's visit may not be necessary at this time.",
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
                        'HEART FAILURE PREDICTION',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Our artificial intelligence program for heart failure prediction, utilizing the data you've provided, has indicated that your condition is critical. We strongly advise you to see a doctor as soon as possible.",
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
              } else {}
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

  Widget testitem(String name, dynamic? value, String type) {
    Widget childWidget;
    if (value != null && value != '') {
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

  void showPopup(String name, String type, BuildContext context) {
    TextEditingController _controller = TextEditingController();
    String? selectedOption;
    List<String> options = [];

    if (name == 'blood_pressure' || name == 'smoking') {
      options = ['Select an option', 'true', 'false'];
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
                          controller: timecontroller,
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

  void update(String name, dynamic value) {
    if (name == 'blood_pressure') {
      if (value == 'true')
        widget.heartfailure.high_blood_pressure = 1;
      else
        widget.heartfailure.high_blood_pressure = 0;

      print('New high blood pressure value is added: $value');
    } else if (name == 'smoking') {
      if (value == 'true')
        widget.heartfailure.smoking = 1;
      else
        widget.heartfailure.smoking = 0;
      print('New smoking value is added: $value');
    } else if (name == 'time') {
      int time = int.parse(timecontroller.text);
      widget.heartfailure.time = time;
      print('New time value is added: $value');
    } else {
      print('Attribute $name not found in HeartFailure');
    }
    saveHeartFailureComponents();
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
}
