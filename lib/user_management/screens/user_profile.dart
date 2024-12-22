import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:depokrasa_mobile/shared/left_drawer.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';
import 'package:depokrasa_mobile/models/user.dart'; // Import the User class

class UserProfileScreen extends StatefulWidget {
  final User user; // Add this line to define the user parameter

  const UserProfileScreen({Key? key, required this.user}) : super(key: key); // Update the constructor

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();

  String username = '';
  String email = '';
  String profilePictureUrl = '';

  Future<void> fetchUserProfile() async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000';
    String apiUrl = '$baseUrl/get-profile/';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        username = data['username'];
        email = data['email'];
        profilePictureUrl = data['profile_picture'];
        usernameController.text = username;
        emailController.text = email;
        profilePictureController.text = profilePictureUrl;
      });
    } else {
      // Handle error
    }
  }

  Future<void> updateUserProfile(String email, String profilePicture) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000';
    String apiurl = '$baseUrl/update-profile/';

    final response = await http.post(
      Uri.parse(apiurl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'profile_picture': profilePicture,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Profile updated successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Return to previous screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update profile. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Stay on current screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      bottomNavigationBar: BottomNavBar(user: widget.user), // Pass the user parameter here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: profilePictureController,
              decoration: InputDecoration(labelText: 'Profile Picture URL'),
              onChanged: (value) {
                setState(() {
                  profilePictureUrl = value;
                });
              },
            ),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePictureUrl.isNotEmpty
                  ? NetworkImage(profilePictureUrl)
                  : AssetImage('images/image1.jpg') as ImageProvider,
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.of(context).pop();
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
