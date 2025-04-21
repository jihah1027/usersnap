//NURUL NAJIHAH BINTI HUSAIN 302039

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final user = await UserService.fetchRandomUser();
      setState(() {
        userData = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('User Snap'),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 83, 144, 190),
      centerTitle: true,
    ),
    body: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 193, 190, 190),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color.fromARGB(255, 245, 247, 248),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : error != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: $error',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: fetchUser,
                                child: Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 83, 144, 190),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  textStyle: TextStyle(fontSize: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : UserCard(userData: userData!),
              ),
            ),
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: fetchUser,
      backgroundColor: const Color.fromARGB(255, 83, 144, 190),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Icon(Icons.refresh),
      tooltip: 'Load Another User',
    ),
  );
}
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserCard({required this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData['name'];
    final picture = userData['picture'];
    final location = userData['location'];
    final dob = userData['dob'];
    final login = userData['login'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile picture centered at top
        Center(
          child: CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(picture['large']),
          ),
        ),
        SizedBox(height: 16),

        Center(
          child: Text(
            '${name['title']} ${name['first']} ${name['last']}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 83, 144, 190),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),

        _buildDetailRow('Username:', login['username']),
        SizedBox(height: 12),
        _buildDetailRow('Email:', userData['email']),
        SizedBox(height: 12),
        _buildDetailRow('Phone:', userData['phone']),
        SizedBox(height: 12),
        _buildDetailRow('Gender:', userData['gender']),
        SizedBox(height: 12),
        _buildDetailRow(
          'Date of Birth:',
          '${DateTime.parse(dob['date']).toLocal().toString().split(' ')[0]} (${dob['age']} years)',
        ),
        SizedBox(height: 12),
        _buildDetailRow(
          'Address:',
          '${location['street']['number']} ${location['street']['name']}, ${location['city']}, ${location['state']}, ${location['country']}',
        ),
        SizedBox(height: 12),
        _buildDetailRow('Nationality:', userData['nat']),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: '$label ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class UserService {
  static Future<Map<String, dynamic>> fetchRandomUser() async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'][0];
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
