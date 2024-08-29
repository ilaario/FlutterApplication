import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'lap_details_page.dart';

class TelemetryDataPage extends StatefulWidget {
  @override
  _TelemetryDataPageState createState() => _TelemetryDataPageState();
}

class _TelemetryDataPageState extends State<TelemetryDataPage> {
  List<Map<String, dynamic>> _lapData = [];
  Map<int, Map<String, dynamic>> _firstEntries = {};
  Map<int, Map<String, dynamic>> _lastEntries = {};

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/data/lapData.csv");
    List<List<dynamic>> listData = CsvToListConverter().convert(rawData);

    // Assuming the first row contains headers
    List<String> headers = List<String>.from(listData.first);
    List<Map<String, dynamic>> data = listData.skip(1).map((row) {
      return Map<String, dynamic>.fromIterables(headers, row);
    }).toList();

    // Process data to get the first and last entry for each lap
    for (var row in data) {
      int lapNum = row['m_currentLapNum'];
      if (!_firstEntries.containsKey(lapNum)) {
        _firstEntries[lapNum] = row;
      }
      _lastEntries[lapNum] = row;
    }

    setState(() {
      _lapData = _lastEntries.values.toList();
    });
  }

  String _formatTime(int milliseconds) {
    int minutes = (milliseconds ~/ 60000);
    int seconds = ((milliseconds % 60000) ~/ 1000);
    int millis = (milliseconds % 1000);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(3, '0')}';
  }

  String _formatSector(int milliseconds) {
    int seconds = (milliseconds ~/ 1000);
    int millis = (milliseconds % 1000);
    return '${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telemetry Data'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      body: _lapData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _lapData.length,
        itemBuilder: (context, index) {
          var lap = _lapData[index];
          return ListTile(
            title: Text('Lap ${lap['m_currentLapNum']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Time: ${_formatTime(lap['m_lastLapTimeInMS'])}'),
                Text('Sector 1: ${_formatSector(lap['m_sector1TimeInMS'])} ms'),
                Text('Sector 2: ${_formatSector(lap['m_sector2TimeInMS'])} ms'),
                Text('Sector 3: ${_formatSector(lap['m_lastLapTimeInMS'] - lap['m_sector1TimeInMS'] - lap['m_sector2TimeInMS'])} ms'),
                // Add more fields as necessary
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lap['m_currentLapInvalid'] == 1) Icon(Icons.warning, color: Colors.red),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              var firstEntry = _firstEntries[lap['m_currentLapNum']];
              var lastEntry = _lastEntries[lap['m_currentLapNum']];
              if (firstEntry != null && lastEntry != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LapDetailsPage(
                      firstEntry: firstEntry,
                      lastEntry: lastEntry,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}