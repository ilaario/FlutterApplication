import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastSessionPage extends StatefulWidget {
  @override
  _LastSessionPageState createState() => _LastSessionPageState();
}

class _LastSessionPageState extends State<LastSessionPage> {
  List<List<dynamic>> _lapData = [];
  List<int> _laps = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final lapData = await _loadLapData();
    _processLapData(lapData);
  }

  Future<List<List<dynamic>>> _loadLapData() async {
    final rawData = await rootBundle.loadString("assets/data/lapData.csv");
    final csvData = CsvToListConverter().convert(rawData);
    return csvData;
  }

  void _processLapData(List<List<dynamic>> lapData) {
    if (lapData.isEmpty || lapData.length < 2) return; // Ensure there's data and skip the header row

    List<Map<String, dynamic>> lapMaps = [];
    List<String> headers = List<String>.from(lapData.first);

    for (var row in lapData.skip(1)) {
      var map = Map<String, dynamic>.fromIterables(headers, row);
      lapMaps.add(map);
    }

    int currentLap = lapMaps.first['m_currentLapNum'];
    _laps.add(currentLap);

    for (var i = 1; i < lapMaps.length; i++) {
      int lapNum = lapMaps[i]['m_currentLapNum'];
      if (lapNum != currentLap) {
        _laps.add(lapNum);
        currentLap = lapNum;
      }
    }

    setState(() {
      _lapData = lapData;
    });
  }

  String formatTime(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds % 60000) / 1000).toStringAsFixed(3).padLeft(6, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _loadProfileData(),
      builder: (context, profileSnapshot) {
        if (profileSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!profileSnapshot.hasData) {
          return Center(child: Text('No profile data available'));
        }

        var profileData = profileSnapshot.data!;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    '${profileData['firstName']} ${profileData['lastName']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      profileData['raceNumber'] ?? '',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'LAST SESSION',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/austria.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    _laps.isNotEmpty
                        ? formatTime(_lapData.firstWhere((lap) => lap[16] == _laps.first)[4])
                        : '',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  Text(
                    'F1 23 - Red Bull Ring, Austria',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: _laps.map((lap) {
                        var lapData = _lapData.firstWhere((l) => l[16] == lap);
                        return LapTimeTile(
                          lap: lap,
                          time: formatTime(lapData[4]),
                          difference: lap == _laps.first
                              ? '+0.00'
                              : '+${((lapData[4] - _lapData.firstWhere((l) => l[16] == _laps.first)[4]) / 1000).toStringAsFixed(2)}',
                        );
                      }).toList(),
                    ),
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

class LapTimeTile extends StatelessWidget {
  final int lap;
  final String time;
  final String difference;

  LapTimeTile({required this.lap, required this.time, required this.difference});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[400],
          child: Text(
            '$lap',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          time,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        trailing: Text(
          difference,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}