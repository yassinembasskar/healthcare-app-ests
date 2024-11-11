import 'package:app/navigation.dart';
import 'package:app/profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app/var.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class User {
  int id;
  String email;
  String fullName;

  String Password;
  String birthday;
  String height;
  String weight;
  String gender;

  User({
    required this.id,
    required this.email,
    required this.birthday,
    required this.gender,
    required this.fullName,
    required this.Password,
    required this.height,
    required this.weight,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['idPatient'] as int,
      email: json['email'],
      Password: json['password'],
      fullName: json['fullName'],
      birthday: json['birthday'],
      gender: json['gender'],
      height: json['height'].toString(),
      weight: json['weight'].toString(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

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

class ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;
  bool _showFeedback = false;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  User user = User(
    id: -1,
    email: "",
    fullName: "",
    Password: "",
    birthday: "",
    height: "",
    weight: "",
    gender: "",
  );

  @override
  void initState() {
    super.initState();
    _fetchdata();
    oldPasswordController.text = '';
    newPasswordController.text = '';
  }

  Future<void> _fetchdata() async {
    try {
      await getuser();
      print('------');
      print(user.fullName);
      print(user.email);
      print('------');
      setState(() {});
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  Future<void> signUp() async {
    final url = '$ip/users/update_infos';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idPatient': user.id.toString(),
        'fullName': user.fullName,
        'email': user.email,
        'weight': user.weight,
        'height': user.height,
        'gender': user.gender,
        'birthday': user.birthday,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('infos saved successfully');
      print(response.body);
    } else {
      print('Error saving infos: ${response.statusCode}');
      print('Response body: ${response.body}');
      showAlertDialog(context, "Error saving infos: ${response.body}");
    }
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

  Future<void> comparePasswords(String oldPassword, String newPassword) async {
    final url = '$ip/users/update_password';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idPatient': user.id.toString(),
        'oldPassword': oldPassword,
        'newPassword': newPassword
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('infos saved successfully');
      print(response.body);
    } else {
      print('Error saving infos up: ${response.statusCode}');
    }
  }

  Future<void> getuser() async {
    final url = '$ip/users/user';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id_patient': id_patient.toString()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      setState(() {
        this.user.id = responseBody['idPatient'];
        this.user.fullName = responseBody['fullName'];
        print(user.fullName);
        this.user.email = responseBody['email'];
        print(user.email);
        this.user.Password = responseBody['password'];
        print(user.Password);

        this.user.weight = responseBody['weight'].toString();
        print(user.weight);
        this.user.height = responseBody['height'].toString();
        print(user.height);
        this.user.gender = responseBody['gender'];
        print(user.gender);
        this.user.birthday = responseBody['birthday'];
        print(user.birthday);
      });
      print(user.fullName);
      print(user.email);
      print('seseefully getting user data');
    } else {
      print('Error getting user data in: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7EFF7),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF519CD7),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Profile',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF519CD7))),
        centerTitle: true,
      ),
      body: profile(),
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

  Container profile() {
    if (user.fullName == '') {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFFD7EFF7),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(color: Color(0xFFD7EFF7)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            topprofile(),
            SizedBox(
              height: 400,
              child: Container(
                margin: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      editableInformation(
                        name: 'Full Name',
                        initialValue: user.fullName,
                        updateuser: updateuser,
                      ),
                      editableInformation(
                        name: 'Email',
                        initialValue: user.email,
                        updateuser: updateuser,
                      ),
                      editableInformation(
                        name: 'height',
                        initialValue: user.height,
                        updateuser: updateuser,
                      ),
                      editableInformation(
                        name: 'weight',
                        initialValue: user.weight,
                        updateuser: updateuser,
                      ),
                      editableInformation(
                        name: 'Password',
                        initialValue: '**********',
                        updateuser: updateuser,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          wipeAndInsertLines('var.dart', '', -1);
                          navigateToLogin(context);
                        },
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(Size(300.0, 50)),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Container topprofile() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'images/profile.jpg',
              fit: BoxFit.cover,
              height: 120,
              width: 120,
            ),
          ),
          SizedBox(height: 10),
          Text(user.fullName,
              style: TextStyle(
                  color: Color.fromARGB(255, 45, 63, 77),
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget editableInformation({
    required String name,
    required dynamic initialValue,
    required Function(String name, String value) updateuser,
  }) {
    final TextEditingController textController =
        TextEditingController(text: initialValue);

    String value = initialValue;

    void editValue(BuildContext context) async {
      if (name == 'Password') {
        final result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edit Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: oldPasswordController,
                    decoration:
                        const InputDecoration(hintText: 'Enter old password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration:
                        const InputDecoration(hintText: 'Enter new password'),
                    obscureText: true,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      comparePasswords(oldPasswordController.text,
                          newPasswordController.text);
                      Navigator.of(context).pop(true);
                    }),
              ],
            );
          },
        );

        if (result == true && newPasswordController.text.isNotEmpty) {
          value = newPasswordController.text;
        }
      } else {
        textController.text = value;
        final result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edit Value'),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Enter new value'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('SAVE'),
                  onPressed: () {
                    updateuser(name, textController.text);
                    Navigator.of(context).pop(textController.text);
                  },
                ),
              ],
            );
          },
        );

        if (result != null && result.isNotEmpty) {
          value = result;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              color: Color.fromARGB(255, 45, 63, 77),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Row(
            children: <Widget>[
              Text(
                value,
                style: const TextStyle(
                  color: Color.fromARGB(255, 102, 102, 102),
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
              IconButton(
                icon: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 45, 63, 77)),
                onPressed: () => editValue(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateuser(String name, dynamic value) {
    setState(() {
      switch (name) {
        case 'Full Name':
          user.fullName = value;
          break;
        case 'Email':
          user.email = value;
          break;
        case 'weight':
          user.weight = value;
          break;
        case 'height':
          user.height = value;
          break;
        case 'Password':
          user.Password = value;
          break;
      }
    });
    print('updateuser fonction');
    print(user.id);
    print(user.fullName);

    print(user.email);
    print(user.weight);
    print(user.height);
    signUp();
    setState(() {
      _fetchdata();
    });
  }
}
