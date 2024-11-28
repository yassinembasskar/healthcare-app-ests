import 'package:app/History.dart';
import 'package:app/navigation.dart';
import 'package:app/testresults.dart';

import 'package:app/user_storage.dart';


import 'package:app/var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'dart:html' as html;

import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

File? _image;

class aboutus extends StatefulWidget {
  const aboutus({super.key});

  @override
  State<aboutus> createState() => aboutusState();
}

class aboutusState extends State<aboutus> {
  int _selectedIndex = 0;

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              color: Color(0xFFD7EFF7),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: Text(
                      'ABOUT US',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 22),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(17.0),
                          child: Text(
                            'OUR  SERVICES',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.lightBlue,
                                fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 160,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 15.0),
                                          Text(
                                            'HEART FAILUR PREDICTION',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 2.0),
                                          Image.asset(
                                            'images/hhhpng.png',
                                            width: 70,
                                            height: 70,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 160,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 15.0),
                                          Text(
                                            'BRAIN STROKE PREDICTION',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 2.0),
                                          Image.asset(
                                            'images/hf.png',
                                            width: 70,
                                            height: 70,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 160,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 15.0),
                                    Text(
                                      'LAB TEST RESULTS',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.0),
                                    Image.asset(
                                      'images/test.png',
                                      width: 70,
                                      height: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ]))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(17.0),
                          child: Text(
                            'OUR  VISION',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.lightBlue,
                                fontSize: 22),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'APP Name is created to maintain the stability of your health both now and in the future It is developed to guarantee your safety and make your life easier.',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(17.0),
                          child: Text(
                            'Three AI models to ensure your safety',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 81, 156, 215),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'images/logo.png',
                            width: 130,
                            height: 130,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'OUR  CONTACT',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 22),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(17.0),
                          child: Text(
                            'Lorem ipsum dolor sit amet consectetur. Consectetur enim est massa nibh molestie. Tellus at enim elementum purus.',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 81, 157, 215),
          padding: EdgeInsets.symmetric(vertical: 0),
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
                    onPressed: () => _Importimage(),
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

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do Your Test'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(15),
              height: 500,
              width: 400,
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(
                      _image!,
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                sendImage(context);
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(250.0, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text('Do Your Test',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void sendImage(BuildContext context) async {

    int? id_patient = await UserStorage.getUserId();


    if (_image == null) {
      print('No image selected.');
      return;
    }

    try {
      // final reader = html.FileReader();
      // reader.readAsArrayBuffer(_image as html.Blob);
      // await reader.onLoad.first;

      // Uint8List bytes = reader.result as Uint8List;
      var uri = Uri.parse('$ip/ocr/process');

      var request = http.MultipartRequest('POST', uri);
      request.fields['id_patient'] = id_patient.toString();
      var stream = http.ByteStream(Stream.castFrom(_image!.openRead()));
      var length = await _image!.length();
      var MultipartFile = http.MultipartFile('image', stream, length,
          filename: path.basename(_image!.path));
      request.files.add(MultipartFile);

      // request.files.add(http.MultipartFile.fromBytes(
      //   'image',
      //   bytes,
      //   filename: _image?.path,
      // ));
      print('sending');
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = json.decode(responseString);
        print('fff');
        List<Extraction> extractions = [];
        LabTest? labTest;

        if (jsonResponse['labtest'] != null) {
          print('lllll');
          labTest = LabTest.fromJson(jsonResponse['labtest']);
          print('lllll');
        }

        if (jsonResponse['extractions'] != null) {
          jsonResponse['extractions'].forEach((extractionJson) {
            extractions.add(Extraction.fromJson(extractionJson));
          });
          print('4444');
        }

        print('LabTest: $labTest');
        print('Extractions: $extractions');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TestResults(
                    labTest: labTest!,
                    extractions: extractions,
                  )),
        );

        // Navigate to another screen to display the results if necessary
        // navigateToTestResults(context, extractions, labTest!);
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

// import 'dart:convert';
// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:app/History.dart';
// import 'package:app/testresults.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class aboutus extends StatefulWidget {
//   @override
//   _ImageUploadPageState createState() => _ImageUploadPageState();
// }

// class _ImageUploadPageState extends State<aboutus> {
//   html.File? _imageFile;
//   int id_patient = 1; // Example id, replace with actual patient id

//   void _pickImage() {
//     html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//     uploadInput.accept = 'image/*';
//     uploadInput.click();

//     uploadInput.onChange.listen((e) {
//       final files = uploadInput.files;
//       if (files != null && files.isNotEmpty) {
//         setState(() {
//           _imageFile = files.first;
//         });
//       }
//     });
//   }

//   void _sendImage() async {
//     if (_imageFile == null) {
//       print('No image selected.');
//       return;
//     }

//     try {
//       final reader = html.FileReader();
//       reader.readAsArrayBuffer(_imageFile!);
//       await reader.onLoad.first;

//       Uint8List bytes = reader.result as Uint8List;
//       var uri = Uri.parse('http://localhost:3000/ocr/process');

//       var request = http.MultipartRequest('POST', uri)
//         ..fields['id_patient'] = id_patient.toString()
//         ..files.add(http.MultipartFile.fromBytes(
//           'image',
//           bytes,
//           filename: _imageFile!.name,
//         ));

//       print('Sending request...');
//       var response = await request.send();
//       print('Response status: ${response.statusCode}');
//       if (response.statusCode == 200 ||response.statusCode == 201 ) {
//       var responseData = await response.stream.toBytes();
//       var responseString = String.fromCharCodes(responseData);
//       var jsonResponse = json.decode(responseString);

//       List<Extraction> extractions = [];
//       LabTest? labTest;

//       print('LabTest: $labTest');
//       print('Extractions: $extractions');
//         Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => TestResults(labTest: labTest!, extractions: extractions,)), 
//   );

//       // if (response.statusCode == 200) {
//       //   var responseData = await response.stream.toBytes();
//       //   var responseString = String.fromCharCodes(responseData);
//       //   var jsonResponse = json.decode(responseString);

//       //   // Handle the JSON response here

//       } else {
//         print('Failed to upload image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             _imageFile == null
//                 ? Text('No image selected.')
//                 : Text('Image selected: ${_imageFile!.name}'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Choose Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _sendImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
