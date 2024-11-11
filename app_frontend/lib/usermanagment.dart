import 'package:app/navigation.dart';
import 'package:app/profile.dart';
import 'package:app/var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class usermanagment extends StatefulWidget {
  const usermanagment({super.key});

  @override
  State<usermanagment> createState() => _usermanagmentState();
}

class _usermanagmentState extends State<usermanagment> {
  List<User> users = [];

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getusers();
  }

  Future<void> getusers() async {
    final response = await http.get(Uri.parse('$ip/users/getusers'));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        users = [];
        users = data.map((json) => User.fromJson(json)).toList();
      });
      print(users[0].fullName);
    } else {
      print('Failed to load lab test history');
    }
  }

  Future<void> deleteuser(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users/delete'),
      body: jsonEncode({"id_patient": id}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        getusers();
      });
    } else {
      print('Failed to load lab test history');
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
      body: page(),
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

  Container page() {
    return Container(
      color: Color(0xFFD7EFF7),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Users ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 570,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return usercard(user.fullName, user.email, index);
                    },
                  ),
                ],
              )))
        ],
      ),
    );
  }

  Container usercard(String fullname, String email, int i) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(20, 12, 20, 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                height: 70,
                'images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullname,
                style: TextStyle(
                    color: Color(0xFF519CD7),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Text(email),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 40,
            ),
            onPressed: () => deleteuser(this.users[i].id),
          ),
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
        break;
      case 3:
        break;
      case 4:
        navigateToprofile(context);
        break;
      default:
    }
  }
}
