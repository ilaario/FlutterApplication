import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sessions_page.dart';
import 'last_session_page.dart';
import 'profile_page.dart';
import 'edit_profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _checkProfileData();
  }

  Future<void> _checkProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('firstName') == null ||
        prefs.getString('lastName') == null ||
        prefs.getString('nationality') == null ||
        prefs.getString('raceNumber') == null ||
        prefs.getString('acronym') == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(isFirstTime: true)),
      );
    }
  }

  List<Widget> _pages = [
    SessionsPage(),
    LastSessionPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer, color: Colors.purple),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}