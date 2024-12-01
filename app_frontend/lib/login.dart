// import 'dart:convert';
import 'package:app/navigation.dart';
import 'package:app/user_storage.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'var.dart';
import 'dart:io';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Login Status",
          style: TextStyle(color: Color(0xFF003C43)),
        ),
        content: Text(
          message,
          style: TextStyle(color: Color(0xFF003C43)),
        ),
        backgroundColor: Color(0xFFE3FEF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: TextStyle(color: Color(0xFF003C43)),
            ),
          ),
        ],
      );
    },
  );
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> wipeAndInsertLines(String filePath, String role, int id) async {
    final newContent = '''
  role = '$role';
  idPatient = '$id';
  ''';

    try {
      final file = File(filePath);

      if (!(await file.exists())) {
        print('File does not exist. Creating new file.');
        await file.create(recursive: true);
      }

      await file.writeAsString(newContent);
      print('File content updated successfully.');
    } catch (e) {
      print('An error occurred while writing to the file: $e');
    }
  }

  Future<void> login(String email, String password) async {
    final url = '$ip/auth/login';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // String username = responseBody['fullname'];
      // String email = responseBody['email'];
      // role = responseBody['role'];
      print(responseBody);
      await UserStorage.saveUserId(responseBody['userId']);
      int? id_patient = await UserStorage.getUserId();
      await UserStorage.saveUserRole(responseBody['role']);
      String? userRole = await UserStorage.getUserRole();

      print('User ID saved: $id_patient');
      print('User role saved: $userRole');
      
      if (userRole == 'Doctor') {
        print('the Doctor  have been looged in seccesfully');
          if (rememberMe) {
            await wipeAndInsertLines('var.dart', 'user', id_patient ?? 0);
          }
        navigateTodoctor(context);
      } else {

        if (userRole == 'patient') {
          
          print('the user  have been looged in seccesfully');
          if (rememberMe) {
            await wipeAndInsertLines('var.dart', 'user', id_patient ?? 0);

          }
          navigateTohome(context);
        } else {
          print('no user or admin have been found');
        }
      }
    } else {
      print('Error signing IN: ${response.statusCode}');
      print('Response body: ${response.body}');
      showAlertDialog(context, "Error signing in: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Container body() {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Center(
                    child: Image.asset(
                  'images/logo.png',
                  width: 120,
                  height: 120,
                ))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 80.0),
                    Text('LOGIN',
                        style: TextStyle(
                          fontSize: 30.0,
                        )),
                    SizedBox(height: 40.0),
                    input(' ENTER YOUR EMAIL', emailController),
                    SizedBox(height: 25.0),
                    input(' ENTER YOUR PASSWORD', passwordController,
                        obscureText: true),
                    SizedBox(height: 16.0),
                    row1(),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        login(emailController.text, passwordController.text);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(250.0, 50)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ?"),
                          TextButton(
                            onPressed: () {
                              navigateToSignup(context);
                            },
                            child: Text('signup',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 97, 114, 126))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    or(),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(500.0, 50)),
                      ),
                      icon: Icon(Icons.g_mobiledata_sharp),
                      label: Text(
                        'LOGIN WITH GOOGLE',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        )));
  }

  Container or() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: '--------------------------------------     ',
            style: TextStyle(
              fontFamily: 'MonospaceFont',
              letterSpacing: -1.0,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
        Text('OR'),
        RichText(
          text: TextSpan(
            text: '     --------------------------------------',
            style: TextStyle(
              fontFamily: 'MonospaceFont',
              letterSpacing: -1.0,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ));
  }

  Container row1() {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: rememberMe,
            onChanged: onRememberMeChanged,
          ),
          Text('Remember me', style: TextStyle(color: Colors.blue)),
          Spacer(),
          TextButton(
            onPressed: () {},
            child:
                Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void onRememberMeChanged(bool? newValue) {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  Container input(String text, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
