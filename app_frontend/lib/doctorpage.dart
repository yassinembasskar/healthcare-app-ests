import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_storage.dart';  // Import the UserStorage class


class Doctorpage extends StatelessWidget {
  const Doctorpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentsPage(),
    );
  }
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Appointments and Patients
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade50,
          elevation: 0,
          title: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.lightBlue,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Appointments"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Appointments Tab
            AppointmentsTab(),
          ],
        ),
        backgroundColor: Colors.lightBlue.shade50,
      ),
    );
  }
}







// Doctor Model
class Doctor {
  final int id;
  final String fullname;
  final String? speciality;
  final String? profilePic;
  final String? cabinet_add;
  final String? phone_number;

  Doctor({
    required this.id,
    required this.fullname,
    this.speciality,
    this.profilePic,
    this.cabinet_add,
    this.phone_number,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id_doc'],
      fullname: json['fullname_doc'],
      speciality: json['speciality'],
      profilePic: json['profilpic_doc'],
      cabinet_add: json['cabinet_add'],
      phone_number: json['phone_number'],
    );
  }
}

// Fetch Doctors
Future<List<Doctor>> fetchDoctors({String? speciality}) async {
  final String url = speciality != null
      ? '$ip/doctors/filter-by-speciality?speciality=$speciality'
      : '$ip/doctors';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch doctors');
  }
}
 
class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> _allDoctors = [];  // List to store all doctors
  List<Doctor> _filteredDoctors = [];  // List to store filtered doctors based on search/query
  String _searchQuery = '';
  String? _selectedSpeciality;

  @override
  void initState() {
    super.initState();
    _selectedSpeciality = 'None';  // Set default speciality to 'None'
    _fetchAndSetDoctors();  // Fetch all doctors without any filter (on page load)
  }

  // Fetch doctors without any speciality filter, this will load all doctors
  Future<void> _fetchAndSetDoctors({String? speciality}) async {
    print("Fetching all doctors");

    try {
      // Fetch doctors without applying any speciality filter
      final doctors = await fetchDoctors(speciality: speciality);
      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = doctors;  // Initially show all doctors
      });
    } catch (e) {
      print("Error fetching doctors: $e");

      // In case of error, set empty lists to stop the loading spinner
      setState(() {
        _allDoctors = [];
        _filteredDoctors = [];
      });
    }
  }

  // Filter doctors based on search query
  void _filterDoctors(String query) {
    setState(() {
      _searchQuery = query;

      if (_searchQuery.isEmpty) {
        _filteredDoctors = _allDoctors;
      } else {
        _filteredDoctors = _allDoctors.where((doctor) {
          final name = doctor.fullname.toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower);
        }).toList();
      }
    });
  }

  // Show speciality filter options
  void _showSpecialityFilter() async {
    final List<String> specialities = [
      'None', // Default option to show all doctors
      'Cardiology',
      'Dermatology',
      'Neurology',
      'Pediatrics',
      'Radiology',
    ]; // Example specialities

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView(
          children: specialities.map((speciality) {
            return ListTile(
              title: Text(speciality),
              onTap: () {
                Navigator.pop(context, speciality);
              },
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedSpeciality = selected;
      });
      // Fetch doctors based on selected speciality. If "None", fetch all doctors
      _fetchAndSetDoctors(speciality: selected == 'None' ? null : selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4F5FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Filter Icon
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: _filterDoctors,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: _showSpecialityFilter, // Open speciality filter
                  ),
                ],
              ),
            ),
            // Doctor List
            Expanded(
              child: _allDoctors.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show loading if no doctors are loaded
                  : _filteredDoctors.isEmpty
                      ? const Center(child: Text('No doctors found.'))
                      : ListView.builder(
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = _filteredDoctors[index];
                            return buildDoctorCard(doctor: doctor, isSelected: false);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for each doctor
  Widget buildDoctorCard({
  required Doctor doctor,
  required bool isSelected,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: doctor.profilePic != null
              ? NetworkImage(doctor.profilePic!)
              : const NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.fullname,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                doctor.speciality ?? 'Speciality not available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doctor.phone_number ?? 'Phone number not available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.cabinet_add ?? 'Address not available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}







class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}



Future<void> sendScheduleToBackend(List<Map<String, String>> finalschedule) async {
   int? id_doc = await UserStorage.getUserId();
  // Map time to 24-hour format and format the data for the backend
  List<Map<String, dynamic>> formattedSchedules = finalschedule.map((schedule) {
    // Convert "time" to 24-hour format
    String time = schedule['time']!;  // Ensure time is not null
    String period = time.split(' ').last; // AM or PM
    List<String> timeParts = time.split(' ').first.split(':'); // [hour, minute]
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Convert to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    int time24 = hour * 100 + minute; // Time as integer in 24-hour format

    return {
      'day': schedule['day'],
      'time': time24,
    };
  }).toList();

  const String url = 'http://localhost:3000/schedules/bulk'; // Replace with your backend URL

  final payload = {
    'id_doc': id_doc,
    'schedules': formattedSchedules, // Assuming this variable already holds the schedule data
  };
 

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Schedules successfully sent: ${response.body}');
    } else {
      print('Failed to send schedules. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (error) {
    print('Error sending schedules: $error');
  }
}



class _AppointmentsTabState extends State<AppointmentsTab> {
      List<Map<String, String>> finalschedule=[];
      Map<String, List<String>> schedule = {
      'Mon': [],
      'Tue': [],
      'Wed': [],
      'Thu': [],
      'Fri': [],
      'Sat': [],
      'Sun': [],
    };

    // List of available hours
    final List<String> hours = [
      '8:00 AM',
      '9:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '1:00 PM',
      '2:00 PM',
      '3:00 PM',
      '4:00 PM',
      '5:00 PM',
      '6:00 PM',
      '7:00 PM',
      
    ];

    // Function to show the popup
    void _showSchedulePopup() async {
      String currentDay = 'Mon'; // Start with Monday
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  height: 350,
                  
                  child: Column(
                    children: [
                      // Days navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: schedule.keys.map((day) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentDay = day;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),  
                              decoration: BoxDecoration(
                                color: currentDay == day
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: currentDay == day
                                      ? Colors.white
                                      : Colors.black,fontSize: 11,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      // Hours grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: hours.length,
                          itemBuilder: (context, index) {
                            String hour = hours[index];
                            bool isSelected =
                                schedule[currentDay]?.contains(hour) ?? false;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    schedule[currentDay]?.remove(hour);
                                  } else {
                                    schedule[currentDay]?.add(hour);
                                  }
                                });
                              },
                              child: Container(
                                height: 15,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  hour,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // Confirm and Cancel buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                                convertScheduleToJson(schedule); // Convert the schedule to JSON
                                await sendScheduleToBackend(finalschedule); // Send it to the backend
                                Navigator.of(context).pop(); // Close the popup
                              },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    List<Map<String, String>> convertScheduleToJson(Map<String, List<String>> schedule) {
    // Map to convert abbreviated day names to full names
    Map<String, String> dayMapping = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };

    List<Map<String, String>> result = [];

    schedule.forEach((day, times) {
      for (String time in times) {
        result.add({
          'day': dayMapping[day] ?? day, // Convert to full name or use the original if no match
          'time': time,
        });
      }
    });
    setState(() {
      finalschedule = result ;
    });
    print(finalschedule);
    return result;
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _showSchedulePopup  ,
            
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            child: const Text('SET SCHEDULE',
                style: TextStyle(
                          color: Colors.white,
                              ),
                            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 400, // Set the desired width
            height: 50, // Set the desired height
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.transparent, // Transparent border color
                    width: 1.0,               // Adjust thickness as needed
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.transparent, // Transparent border color
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.transparent, // Transparent border color
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),


          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Number of cards
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/ahmed.jpg'),
                              radius: 30,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dr. Olivia Turner, M.D.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue
                                  ),
                                ),
                                Text(
                                  'Dermato-Endocrinology',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16),
                            SizedBox(width: 8),
                            Text('Sunday, 12 June'),
                            Spacer(),
                            Icon(Icons.access_time, size: 16),
                            SizedBox(width: 8),
                            Text('9:30 AM - 10:00 AM'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Elevated Button
                            SizedBox(
                              width: 200, // Set the desired width
                              height: 30, // Set the desired height
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            // Status Box
                            SizedBox(
                              width: 100, // Set the desired width
                              height: 30, // Set the desired height
                              child: Container(
                                alignment: Alignment.center, // Center the text
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Background color for the status box
                                  borderRadius: BorderRadius.circular(18.0), // Rounded corners
                                ),
                                child: const Text(
                                  'Active', // Status text
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  void _showScheduleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Schedule",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              // Day selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Column(
                    children: [
                      Text(
                        "${22 + index}",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              index == 2 ? Colors.white : Colors.lightBlue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                            [index],
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              index == 2 ? Colors.white : Colors.lightBlue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      CircleAvatar(
                        backgroundColor: index == 2
                            ? Colors.lightBlue
                            : Colors.lightBlue[100],
                        radius: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Time selector
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  "9:00 AM",
                  "10:00 AM",
                  "11:00 AM",
                  "1:00 PM",
                  "2:00 PM",
                  "3:00 PM",
                  "4:00 PM",
                  "5:00 PM",
                  "9:00 PM"
                ].map((time) {
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(color: Colors.lightBlue[800]),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Confirm button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}


class PatientsTab extends StatelessWidget {
  final List<Map<String, String>> patients = List.generate(
    5,
    (index) => {
      "name": "Lucas Rodriguez",
      "email": "jacobwest@gmail.com",
    },
  );

  PatientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
         TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.transparent, // Transparent border color
                  width: 1.0,               // Adjust thickness as needed
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.transparent, // Transparent border color
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.transparent, // Transparent border color
                  width: 1.0,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),


          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    title: Text(
                      patient["name"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      patient["email"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        // Action for delete
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


