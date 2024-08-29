import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _loadProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No profile data available'));
        }
        var profileData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      profileData['raceNumber'] ?? '',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: ${profileData['firstName']} ${profileData['lastName']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nationality: ${profileData['nationality']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Race Number: ${profileData['raceNumber']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(isFirstTime: false),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'nationality': prefs.getString('nationality') ?? '',
      'raceNumber': prefs.getString('raceNumber') ?? '',
      'acronym': prefs.getString('acronym') ?? '',
    };
  }
}