import 'dart:convert';
import 'package:app/var.dart';
import 'package:http/http.dart' as http;
import 'package:app/navigation.dart';
import 'package:flutter/material.dart';

import 'user_storage.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  int selectedRadio = 1;
  int gendervalue = 0;
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

  List<int> days = List.generate(31, (index) => index + 1);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> years = List.generate(100, (index) => DateTime.now().year - index);

  DateTime? selectedDate;

  Future<void> signUp(String email, String password, String fullname,
      String height, String weight) async {
    try {
      final url = '$ip/users/signup';
      String gender;
      selectedDate = DateTime(selectedYear!, selectedMonth!, selectedDay!);
      if (gendervalue == 1) {
        gender = "Male";
      } else
        gender = "Female";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "password": password,
          "fullName": fullname,
          "birthday": selectedDate?.toIso8601String(),
          "gender": gender,
          "height": height,
          "weight": weight
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Signed up successfully');
        print(response.body);
        showAlertDialog(context, "Signed up successfully");
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(response.body);

        print(responseBody['idPatient']);
        await UserStorage.saveUserId(responseBody['idPatient']);
        int? userId = await UserStorage.getUserId();
        print('User ID saved: $userId');
        // id_patient = responseBody['idPatient'];
        // role = 'user';

        navigateTohome(context);
      } else {
        print('Error signing up: ${response.statusCode}');
        print('Response body: ${response.body}');
        showAlertDialog(context, "Error signing up: ${response.body}");
      }
    } catch (e, stackTrace) {
      print('Exception occurred: $e');
      print(stackTrace);
      showAlertDialog(context, "Exception occurred: $e");
    }
  }

  bool areFieldsEmpty() {
    return emailController.text.isEmpty ||
        fullnameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        selectedDay == null ||
        selectedMonth == null ||
        selectedYear == null;
  }

  void showEmptyFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all fields."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void passwordsNotIdentical(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("The Passwords Are not Identical"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void passwordSmall(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please Write a password with more than 8 letters"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Sign Up Status",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: determineSignupScreen(),
    );
  }

  Widget determineSignupScreen() {
    if (selectedRadio == 2) {
      return signup2();
    } else {
      return signup1();
    }
  }

  void handleRadioValueChanged(int? value) {
    setState(() {
      selectedRadio = value!;
    });

    Widget signupScreen = determineSignupScreen();

    updateUI(signupScreen);
  }

  void updateUI(Widget newScreen) {
    setState(() {});
  }

  Container signup2() {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 70.0),
              child: Center(
                  child: Image.asset(
                'images/logo.png',
                width: 120,
                height: 120,
              ))),
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: 60.0),
              Text('SIGN UP',
                  style: TextStyle(
                    fontSize: 30.0,
                  )),
              SizedBox(height: 30.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 30.0),
                  child: Text('DATE OF BIRTH'),
                ),
              ),
              SizedBox(height: 10.0),
              birthday(),
              SizedBox(height: 30.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 30.0),
                  child: Text('GENDER'),
                ),
              ),
              SizedBox(height: 10.0),
              gender(),
              SizedBox(height: 30.0),
              Row(
                children: [
                  HW('HEIGHT', 'CM', heightController),
                  SizedBox(width: 30.0),
                  HW('WEIGHT', 'KG', weightController)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(height: 30.0),
              radiorow(),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text.length < 8) {
                    passwordSmall(context);
                  } else if (passwordConfirmationController.text !=
                      passwordController.text) {
                    passwordsNotIdentical(context);
                  } else if (areFieldsEmpty()) {
                    showEmptyFieldsDialog(context);
                  } else {
                    signUp(
                        emailController.text,
                        passwordController.text,
                        fullnameController.text,
                        heightController.text,
                        weightController.text);
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(250.0, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('SIGN UP',
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
                    Text("already have an account ?"),
                    TextButton(
                      onPressed: () {
                        navigateToLogin(context);
                      },
                      child: Text('login',
                          style: TextStyle(color: Color(0xFF519CD7))),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ]));
  }

  Container HW(String text1, String text2, TextEditingController Controller) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(15.0),
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: Controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                )),
                Text(text2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container gender() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('   MALE'),
                Radio(
                  value: 1,
                  groupValue: gendervalue,
                  onChanged: genderradiochanger,
                  activeColor: Colors.blue,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          SizedBox(width: 30.0),
          Container(
              padding: EdgeInsets.all(5.0),
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('   FEMALE'),
                  Radio(
                    value: 2,
                    groupValue: gendervalue,
                    onChanged: genderradiochanger,
                    activeColor: Colors.blue,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Container birthday() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: DropdownButton<int?>(
                        value: selectedDay,
                        hint: Text('Day'),
                        underline: Container(),
                        elevation: 0,
                        style: TextStyle(
                          backgroundColor: Colors.white,
                        ),
                        items: [null, ...days].map((day) {
                          return DropdownMenuItem<int?>(
                            value: day,
                            child: Text(day != null ? day.toString() : 'DAY'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDay = value;
                          });
                        },
                      ),
                    )),
                SizedBox(width: 16),
                Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: DropdownButton<int?>(
                        value: selectedMonth,
                        hint: Text('Month'),
                        underline: Container(),
                        elevation: 0,
                        style: TextStyle(
                          backgroundColor: Colors.white,
                        ),
                        items: [null, ...months].map((month) {
                          return DropdownMenuItem<int?>(
                            value: month,
                            child: Text(
                                month != null ? month.toString() : 'MONTH'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        },
                      ),
                    )),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                      child: DropdownButton<int?>(
                    value: selectedYear,
                    hint: Text('Year'),
                    underline: Container(),
                    elevation: 0,
                    items: [null, ...years].map((year) {
                      return DropdownMenuItem<int?>(
                        value: year,
                        child: Text(year != null ? year.toString() : 'YEAR'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container signup1() {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 70.0),
              child: Center(
                  child: Image.asset(
                'images/logo.png',
                width: 120,
                height: 120,
              ))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              SizedBox(height: 60.0),
              Text('SIGN UP',
                  style: TextStyle(
                    fontSize: 30.0,
                  )),
              SizedBox(height: 40.0),
              input('ENTER YOUR EMAIL', emailController),
              SizedBox(height: 30.0),
              input('ENTER YOUR FULL NAME', fullnameController),
              SizedBox(height: 30.0),
              input('ENTER YOUR PASSWORD ', passwordController,
                  obscureText: true),
              SizedBox(height: 30.0),
              input('CONFIRM YOUR PASSWORD', passwordConfirmationController,
                  obscureText: true),
              SizedBox(height: 25.0),
              radiorow(),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  handleRadioValueChanged(2);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(250.0, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('NEXT',
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
                    Text("already have an account ?"),
                    TextButton(
                      onPressed: () {
                        navigateToLogin(context);
                      },
                      child: Text('login',
                          style: TextStyle(color: Color(0xFF519CD7))),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ]));
  }

  void genderradiochanger(int? value) {
    setState(() {
      gendervalue = value!;
    });
  }

  Container radiorow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
              scale: 1.5,
              child: Radio(
                value: 1,
                groupValue: selectedRadio,
                onChanged: handleRadioValueChanged,
                activeColor: Colors.blue,
                visualDensity: VisualDensity.compact,
              )),
          SizedBox(width: 30.0),
          Transform.scale(
              scale: 1.5,
              child: Radio(
                value: 2,
                groupValue: selectedRadio,
                onChanged: handleRadioValueChanged,
                activeColor: Colors.blue,
                visualDensity: VisualDensity.compact,
              )),
        ],
      ),
    );
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
