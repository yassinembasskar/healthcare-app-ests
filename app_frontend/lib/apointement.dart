import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class doctorlist extends StatelessWidget {
  const doctorlist({super.key});

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
              Tab(text: "Patients"),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            // Patients Tab
            DoctorListScreen()
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
                  color: Colors.lightBlue,
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



