import 'package:app/user_storage.dart';
import 'package:app/var.dart';
import 'package:app/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LabTest {
  final int? testId;
  final int? patientId;
  final String? testName;
  final String? testDate;
  final String? testTime;

  LabTest({
    required this.testId,
    required this.patientId,
    required this.testName,
    required this.testDate,
    required this.testTime,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['test_date']);
    String testDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    String testTime = "${dateTime.hour}:${dateTime.minute}";

    return LabTest(
      testId: json['test_id'],
      patientId: json['id_patient'],
      testName: json['test_name'],
      testDate: testDate,
      testTime: testTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test_id': testId,
      'id_patient': patientId,
      'test_name': testName,
      'test_date': testDate,
      'test_time': testTime,
    };
  }
}

class Extraction {
  final int? id_extractions;
  final int? test_id;
  final String? name_substance;
  final String? value_substance;
  final String? mesure_substance;
  final String? interpretation;

  Extraction({
    required this.test_id,
    required this.id_extractions,
    required this.name_substance,
    required this.value_substance,
    required this.mesure_substance,
    required this.interpretation,
  });

  factory Extraction.fromJson(Map<String, dynamic> json) {
    return Extraction(
      id_extractions: json['id_extractions'],
      test_id: json['test_id'],
      name_substance: json['name_substance'],
      value_substance: json['value_substance'],
      mesure_substance: json['mesure_substance'],
      interpretation: json['interpretation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_extractions': id_extractions,
      'test_id': test_id,
      'name_substance': name_substance,
      'value_substance': value_substance,
      'mesure_substance': mesure_substance,
      'interpretation': interpretation,
    };
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 1;

  bool isSelected = false;
  List<LabTest> _labTests = [];
  @override
  void initState() {
    super.initState();
    getLabTestHistory();
  }

  Future<void> getLabTestHistory() async {
    int? id_patient = await UserStorage.getUserId();
    final response = await http.post(
      Uri.parse('$ip/ocr/get'),
      body: jsonEncode({"id_patient": id_patient}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      setState(() {
        _labTests = data.map((json) => LabTest.fromJson(json)).toList();
      });

      print(_labTests[0].testName);
    } else {
      throw Exception('Failed to load lab test history');
    }
  }

  Future<void> getextractions(LabTest labtest) async {
    List<Extraction> extractions = [];
    print(labtest);
    final response = await http.post(
      Uri.parse('$ip/ocr/getextractions'),
      body: jsonEncode({"test_id": labtest.testId}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        extractions = data.map((json) => Extraction.fromJson(json)).toList();
      });
      print(extractions[0].name_substance);
      navigateToTestResults(context, extractions, labtest);
    } else {
      throw Exception('Failed to load lab test history');
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
                    height: (AppBar().preferredSize.height + 40.0) * 0.8,
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: History(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        color: Color(0xFFD7EFF7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
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
                  borderRadius: BorderRadius.circular(40),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 34,
                  ),
                  onPressed: () => _onItemTapped(2),
                  color: Colors.black,
                ),
              ),
            ),
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

  Container History() {
    return Container(
      width: double.infinity,
      color: Color(0xFFD7EFF7),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text('TESTS HISTORY',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
          SizedBox(height: 25),
          SizedBox(
            height: 570,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _labTests.length,
                    itemBuilder: (context, index) {
                      final labTest = _labTests[index];
                      return GestureDetector(
                        onTap: () {
                          print("Brain Stroke tapped!");
                          getextractions(_labTests[index]);
                          // navigateToTestResults(context, _labTests[index] );
                        },
                        child: TestCard(labTest.testName!, 'TEST TYPE',
                            labTest.testTime!, labTest.testDate!, index),
                      );
                      //
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container TestCard(
      String testname, String discription, String time, String date, int i) {
    return Container(
        width: 350,
        height: 130,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
        child: Row(
          children: [
            Container(
              height: 100,
              width: 130,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          height: 90,
                          'images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              height: 100,
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 65,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromARGB(255, 0, 0, 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ]),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          testname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF519CD7)),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(date,
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 168, 166, 172)))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
              width: 50,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 30,
                ),
                onPressed: () => _onItemTapped(1),
              ),
            )
          ],
        ));
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
