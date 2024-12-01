import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app/var.dart';
import 'package:http/http.dart' as http;

import 'package:app/aboutus.dart';
import 'package:app/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File? _image;
class AlzheimerTestPage extends StatefulWidget {
  @override
  _AlzheimerTestPageState createState() => _AlzheimerTestPageState();
}

class _AlzheimerTestPageState extends State<AlzheimerTestPage> {
  File? _uploadedFile; // To track the uploaded file
    int _selectedIndex = 0;
  Uint8List? _uploadedFileBytes; // For Web support

  // Simulate file upload (replace with actual logic)


  final ImagePicker _picker = ImagePicker();  // Initialize ImagePicker

  // Function to allow the user to upload an image
Future<void> _uploadFile() async {
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes(); // Asynchronous read for Web
      setState(() {
        _uploadedFileBytes = bytes;
        _uploadedFile = null; // Ensure the file object is not used on Web
      });
    } else {
      setState(() {
        _uploadedFile = File(pickedFile.path); // For Mobile/Desktop
        _uploadedFileBytes = null; // Ensure bytes are not used on non-web
      });
    }
  }
}
void showPredictionDialog(BuildContext context, String prediction) {
  // Define styles and messages based on the prediction
  Color backgroundColor;
  String message;
  String buttonText;

  if (prediction == 'Non-Demented') {
    backgroundColor = Colors.green;
    message =
        "Our AI indicates that your condition appears stable, and a doctor's visit may not be necessary at this time.";
    buttonText = "Normal";
  } else if (prediction == 'Moderate Demented' || prediction == 'Mild Demented') {
    backgroundColor = Colors.yellow;
    message =
        "Our AI suggests that you may have mild to moderate signs. It’s recommended to consult with a healthcare provider.";
    buttonText = "Caution";
  } else if (prediction == 'Very Mild Demented') {
    backgroundColor = Colors.red;
    message =
        "Our AI has identified significant signs of concern. A doctor's visit is highly recommended for further evaluation.";
    buttonText = "Urgent";
  } else {
    backgroundColor = Colors.grey; // Fallback color
    message = "Unable to determine the condition. Please try again.";
    buttonText = "Retry";
  }

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          prediction,
          style: TextStyle(
            color: backgroundColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


Future<void> predict(File? file, Uint8List? fileBytes) async {
  print('predicting');
  try {
    if (file == null && fileBytes == null) {
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload an image before prediction.'),
          backgroundColor: Colors.red, // You can change the color based on your preference
        ),
      );
    }

    // Prepare the file data
    final Uint8List data = file != null ? await file.readAsBytes() : fileBytes!;


    final uri = Uri.parse('$ip/alzheimer/Prediction'); 
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image', 
          data,
          filename: file?.path.split('/').last ?? 'uploaded_file.jpg',
        ),
      );
    print('request sent');

    final response = await http.Response.fromStream(await request.send());


    if (response.statusCode == 201) {

      final result = jsonDecode(response.body);
      print(result);
      debugPrint('prediction: $result');
      String prediction = result['prediction'];
      print(prediction);
      showPredictionDialog(context, prediction);
    } else {
      debugPrint('Failed to predict. Status code: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7EFF7), // Light blue background
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
      body: alzheimer(),
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

Container alzheimer() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            "ALZHEIMER TEST",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF519CD7),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Upload your MRI scan to assess your risk.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
         GestureDetector(
  onTap: _uploadFile, // Call the upload function on tap
  child: Container(
    width: 280,
    height: 280,
    decoration: BoxDecoration(
      color: Color(0xFFD7EFF7),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Shadow color with opacity
          blurRadius: 30, // Spread of the blur
          offset: Offset(4, 4), // Offset in X and Y directions
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15), // Ensure the image has rounded corners
      child: Center(
        child: _uploadedFile == null && _uploadedFileBytes == null
            ? Icon(
                Icons.add,
                size: 50,
                color: Colors.black,
              )
            : kIsWeb && _uploadedFileBytes != null
                ? Image.memory(
                    _uploadedFileBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : _uploadedFile != null
                    ? Image.file(
                        _uploadedFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(), // Fallback for other cases
      ),
    ),
  ),
),

          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () async {
              if (_uploadedFile != null || _uploadedFileBytes != null) {
                await predict(_uploadedFile, _uploadedFileBytes); // Replace with your server IP
              } else {
                debugPrint('Please upload a file first!');
                      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload an image before prediction.'),
          backgroundColor: Colors.red, // You can change the color based on your preference
        ),
      );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF519CD7), // Light blue button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            ),
            child: Text(
              "DO THE PREDICTION",
              style: TextStyle(fontSize: 16, color: Colors.white),
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
