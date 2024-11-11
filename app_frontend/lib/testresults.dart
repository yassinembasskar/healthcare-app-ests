// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app/var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'History.dart';
// class Extraction {
//   final int id_extractions;
//   final int test_id;
//   final String  name_substance;
//   final String value_substance;
//   final String mesure_substance;
//   final String interpretation ;

//   Extraction({
//     required this.test_id,
//     required this.id_extractions,
//   required this.name_substance,
//   required this.value_substance,
//   required this.mesure_substance,
//   required this.interpretation ,

//   });

//   factory Extraction.fromJson(Map<String, dynamic> json) {

//     return Extraction(
//       id_extractions:  json['id_extractions'],
//       test_id: json['test_id'],
//       name_substance:  json['name_substance'],
//       value_substance: json['value_substance'],
//       mesure_substance :json['mesure_substance'],
//       interpretation :  json['interpretation'],

//     );
//   }
// }
class TestResults extends StatefulWidget {
  LabTest labTest;
  List<Extraction> extractions;
  TestResults({
    Key? key,
    required this.labTest,
    required this.extractions,
  }) : super(key: key);

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {
  int _selectedIndex = 0;

  bool isSelected = false;

  List<Extraction> extractions = [];
  @override
  void initState() {
    super.initState();
    // getextractions();
    print(widget.labTest.patientId);
  }

  Future<void> sendLabTestData() async {
    final url = Uri.parse('$ip/ocr/save');

    final Map<String, dynamic> body = {
      'labtest': widget.labTest.toJson(),
      'extractions':
          widget.extractions.map((extraction) => extraction.toJson()).toList(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data saved successfully.');
    } else {
      print('Failed to save data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 60.0),
        child: Container(
          color: Color.fromARGB(255, 81, 156, 215),
          child: Padding(
            padding: EdgeInsets.only(top: 36.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: SizedBox(
                height: AppBar().preferredSize.height +
                    30.0, // Adjust logo's size and space
                child: Center(
                  child: Image.asset(
                    'images/logo.png', // Replace with your logo image asset
                    height: (AppBar().preferredSize.height + 40.0) *
                        0.8, // Adjust logo size as needed
                  ),
                ),
              ),
              elevation: 0, // Remove elevation
              backgroundColor: Colors.transparent, // Make app bar transparent
            ),
          ),
        ),
      ),
      body: Testresults(),
    );
  }

  Container Testresults() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFD7EFF7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text('TESTS RESULTS',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 25,
          ),
          Container(
            height: 500,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'VALUE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 22),
                              child: Text(
                                'STATUS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...widget.extractions.map((extraction) {
                        return myrow(
                          extraction.name_substance!,
                          extraction.value_substance!,
                          extraction.interpretation!,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if (widget.extractions[0].test_id == -1)
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Sure you want to save?"),
                      content: Text("Are you sure you want to save this data?"),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.black, width: 1)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(120.0, 40)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text('No, cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  )),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                print('confirm');
                                sendLabTestData();
                              },
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(120.0, 40)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.lightBlue),
                              ),
                              child: Text('Yes, Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(250.0, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text('SAVE TEST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
            ),
          SizedBox(
            height: 20,
          ),
          if (widget.labTest.patientId != -1)
            Container(
              child: Text("",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  )),
            )
        ],
      ),
    );
  }

  TableRow myrow(String Name, String Value, String Status) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1.0,
                color: Colors.grey), // Add a border at the bottom of the row
          ),
        ),
        children: [
          TableCell(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(Name),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(Value),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
            child: Container(
              height: 22,
              width: 50,
              decoration: BoxDecoration(
                  color: () {
                    switch (Status) {
                      case 'normal':
                        return Colors.green;
                      case 'high':
                        return Colors.red;
                      case 'low':
                        return Colors.red;
                      case 'unknown':
                        return Colors.grey;
                      default:
                    }
                  }(),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                Text(
                  Status,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )
              ]),
            ),
          ))
        ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
