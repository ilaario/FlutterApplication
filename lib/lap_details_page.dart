import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'car_setup_detail_page.dart';

class LapDetailsPage extends StatefulWidget {
  final Map<String, dynamic> firstEntry;
  final Map<String, dynamic> lastEntry;

  LapDetailsPage({required this.firstEntry, required this.lastEntry});

  @override
  _LapDetailsPageState createState() => _LapDetailsPageState();
}

class _LapDetailsPageState extends State<LapDetailsPage> {
  List<Map<String, dynamic>> _carSetups = [];
  List<Map<String, dynamic>> _carStatus = [];
  List<Map<String, dynamic>> _carTelemetry = [];
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _motion = [];
  Map<String, dynamic>? _carSetupData;

  final Map<String, String> fieldNames = {
    "m_frontWing": "Front Wing Aero",
    "m_rearWing": "Rear Wing Aero",
    "m_onThrottle": "Differential Adjustment On Throttle",
    "m_offThrottle": "Differential Adjustment Off Throttle",
    "m_frontCamber": "Front Camber",
    "m_rearCamber": "Rear Camber",
    "m_frontToe": "Front Toe-Out",
    "m_rearToe": "Rear Toe-In",
    "m_frontSuspension": "Front Suspension",
    "m_rearSuspension": "Rear Suspension",
    "m_frontAntiRollBar": "Front Anti-Roll Bar",
    "m_rearAntiRollBar": "Rear Anti-Roll Bar",
    "m_frontSuspensionHeight": "Front Ride Height",
    "m_rearSuspensionHeight": "Rear Ride Height",
    "m_brakePressure": "Brake Pressure",
    "m_brakeBias": "Front Brake Bias",
    "m_frontRightTyrePressure": "Front Right Tyre Pressure",
    "m_frontLeftTyrePressure": "Front Left Tyre Pressure",
    "m_rearRightTyrePressure": "Rear Right Tyre Pressure",
    "m_rearLeftTyrePressure": "Rear Left Tyre Pressure",
    "m_speed": "Speed",
    "m_throttle": "Throttle",
    "m_steer": "Steer",
    "m_brake": "Brake",
    "m_gear": "Gear",
    "m_engineRPM": "Engine RPM",
    "m_drs": "DRS",
    "m_brakesTemperature": "Brakes Temperature",
    "m_tyresSurfaceTemperature": "Tyres Surface Temperature",
    "m_tyresInnerTemperature": "Tyres Inner Temperature",
    "m_engineTemperature": "Engine Temperature",
    "m_tyresPressure": "Tyres Pressure",
    "m_surfaceType": "Surface Type",
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCSV("assets/data/carSetups.csv", (data) {
      setState(() {
        _carSetups = data;
      });
    });
    await _loadCSV("assets/data/carStatus.csv", (data) {
      setState(() {
        _carStatus = data;
      });
    });
    await _loadCSV("assets/data/carTelemetry.csv", (data) {
      setState(() {
        _carTelemetry = data;
      });
    });
    await _loadCSV("assets/data/events.csv", (data) {
      setState(() {
        _events = data;
      });
    });
    await _loadCSV("assets/data/motion.csv", (data) {
      setState(() {
        _motion = data;
      });
    });
    _processCarSetupData();
  }

  Future<void> _loadCSV(String path, Function(List<Map<String, dynamic>>) onLoad) async {
    final rawData = await rootBundle.loadString(path);
    List<List<dynamic>> listData = CsvToListConverter().convert(rawData);

    // Assuming the first row contains headers
    List<String> headers = List<String>.from(listData.first);
    List<Map<String, dynamic>> data = listData.skip(1).map((row) {
      return Map<String, dynamic>.fromIterables(headers, row);
    }).toList();

    onLoad(data);
  }

  void _processCarSetupData() {
    int startFrame = widget.firstEntry['m_frameIdentifier'];
    int endFrame = widget.lastEntry['m_frameIdentifier'];

    var filteredCarSetups = _carSetups.where((row) {
      int frameIdentifier = row['m_frameIdentifier'];
      return frameIdentifier >= startFrame && frameIdentifier <= endFrame;
    }).toList();

    if (filteredCarSetups.isNotEmpty) {
      // Assuming all car setup data for a lap is the same, we take the first entry
      _carSetupData = filteredCarSetups.first;
    }
  }

  Widget _buildCarSetupSection() {
    if (_carSetupData == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        title: Row(
          children: <Widget>[
            Icon(Icons.settings, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text("Car Setup", style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarSetupDetailPage(carSetupData: _carSetupData!),
            ),
          );
        },
      ),
    );
  }

  String _roundValue(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data, int startFrame, int endFrame) {
    return data.where((row) {
      int frameIdentifier = row['m_frameIdentifier'];
      return frameIdentifier >= startFrame && frameIdentifier <= endFrame;
    }).toList();
  }

  List<FlSpot> _generateSpots(List<Map<String, dynamic>> data, String field) {
    return data.map((row) {
      double x = double.tryParse(row['m_sessionTime'].toString()) ?? 0;
      double y;
      if (row[field] is String && row[field].startsWith('[')) {
        y = double.tryParse(row[field].toString().replaceAll('[', '').replaceAll(']', '').split(',')[0]) ?? 0;
      } else {
        y = double.tryParse(row[field].toString()) ?? 0;
      }
      return FlSpot(x, y);
    }).toList();
  }

  Widget _buildLineChart(List<FlSpot> spots, String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 200,
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarTelemetrySection(List<Map<String, dynamic>> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        title: Row(
          children: <Widget>[
            Icon(Icons.show_chart, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text("Car Telemetry", style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: [
          _buildLineChart(_generateSpots(data, "m_speed"), "Speed"),
          _buildLineChart(_generateSpots(data, "m_throttle"), "Throttle"),
          _buildLineChart(_generateSpots(data, "m_steer"), "Steer"),
          _buildLineChart(_generateSpots(data, "m_brake"), "Brake"),
          _buildLineChart(_generateSpots(data, "m_gear"), "Gear"),
          _buildLineChart(_generateSpots(data, "m_engineRPM"), "Engine RPM"),
          _buildLineChart(_generateSpots(data, "m_drs"), "DRS"),
          _buildLineChart(_generateSpots(data, "m_brakesTemperature"), "Brakes Temperature"),
          _buildLineChart(_generateSpots(data, "m_tyresSurfaceTemperature"), "Tyres Surface Temperature"),
          _buildLineChart(_generateSpots(data, "m_tyresInnerTemperature"), "Tyres Inner Temperature"),
          _buildLineChart(_generateSpots(data, "m_engineTemperature"), "Engine Temperature"),
          _buildLineChart(_generateSpots(data, "m_tyresPressure"), "Tyres Pressure"),
          _buildLineChart(_generateSpots(data, "m_surfaceType"), "Surface Type"),
        ],
      ),
    );
  }
  Widget _buildEventsSection(List<Map<String, dynamic>> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        title: Row(
          children: <Widget>[
            Icon(Icons.event, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
                child: Text('Events',
                    style: TextStyle(fontSize: 16.0))),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: data.map((row) {
          String eventStringCode = row['m_eventStringCode'];
          if (eventStringCode == "BUTN") return Container();

          String description = _getEventDescription(eventStringCode);
          String eventDetails = _getEventDetails(row);

          return ListTile(
            title: Text(description),
            subtitle: Text(eventDetails),
          );
        }).toList(),
      ),
    );
  }

  String _getEventDescription(String eventStringCode) {
    switch (eventStringCode) {
      case "SSTA":
        return "Session Started";
      case "SEND":
        return "Session Ended";
      case "FTLP":
        return "Fastest Lap";
      case "RTMT":
        return "Retirement";
      case "DRSE":
        return "DRS enabled";
      case "DRSD":
        return "DRS disabled";
      case "TMPT":
        return "Team mate in pits";
      case "CHQF":
        return "Chequered flag";
      case "RCWN":
        return "Race Winner";
      case "PENA":
        return "Penalty Issued";
      case "SPTP":
        return "Speed Trap Triggered";
      case "STLG":
        return "Start lights";
      case "LGOT":
        return "Lights out";
      case "DTSV":
        return "Drive through served";
      case "SGSV":
        return "Stop go served";
      case "FLBK":
        return "Flashback";
      case "RDFL":
        return "Red Flag";
      case "OVTK":
        return "Overtake";
      default:
        return "Unknown Event";
    }
  }

  String _getEventDetails(Map<String, dynamic> row) {
    String eventCode = row['m_eventStringCode'];
    switch (eventCode) {
      case "FTLP":
        return "Vehicle Index: ${row['vehicleIdx']}, Lap Time: ${row['lapTime']} s";
      case "RTMT":
        return "Vehicle Index: ${row['vehicleIdx']}";
      case "TMPT":
        return "Vehicle Index: ${row['vehicleIdx']}";
      case "RCWN":
        return "Vehicle Index: ${row['vehicleIdx']}";
      case "PENA":
        return "Penalty Type: ${row['penaltyType']}, Infringement Type: ${row['infringementType']}, Vehicle Index: ${row['vehicleIdx']}, Other Vehicle Index: ${row['otherVehicleIdx']}, Time: ${row['time']} s, Lap: ${row['lapNum']}, Places Gained: ${row['placesGained']}";
      case "SPTP":
        return "Vehicle Index: ${row['vehicleIdx']}, Speed: ${row['speed']} km/h, Overall Fastest: ${row['isOverallFastestInSession'] == 1}, Driver Fastest: ${row['isDriverFastestInSession'] == 1}, Fastest Vehicle Index: ${row['fastestVehicleIdxInSession']}, Fastest Speed: ${row['fastestSpeedInSession']} km/h";
      case "STLG":
        return "Number of Lights: ${row['numLights']}";
      case "DTSV":
        return "Vehicle Index: ${row['vehicleIdx']}";
      case "SGSV":
        return "Vehicle Index: ${row['vehicleIdx']}";
      case "FLBK":
        return "Flashback Frame Identifier: ${row['flashbackFrameIdentifier']}, Flashback Session Time: ${row['flashbackSessionTime']}";
      case "OVTK":
        return "Overtaking Vehicle Index: ${row['overtakingVehicleIdx']}, Being Overtaken Vehicle Index: ${row['beingOvertakenVehicleIdx']}";
      default:
        return "";
    }
  }

  Widget _buildCarStatusSection(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return Container();

    Map<String, dynamic> lastRow = data.last;
    Map<String, dynamic> averages = {};

    for (String key in lastRow.keys) {
      if (key == 'm_tractionControl' || key == 'm_antiLockBrakes' || key == 'm_tyresAgeLaps') {
        averages[key] = lastRow[key];
      } else {
        averages[key] = data.map((row) => row[key] as num).reduce((a, b) => a + b) / data.length;
      }
    }

    final fieldNames = {
      "m_tractionControl": "Traction Control",
      "m_antiLockBrakes": "Anti-Lock Brakes",
      "m_fuelMix": "Fuel Mix",
      "m_frontBrakeBias": "Front Brake Bias",
      "m_fuelInTank": "Fuel Level",
      "m_fuelRemainingLaps": "Fuel Remaining in Laps",
      "m_tyresAgeLaps": "Tire Wear",
      "m_ersStoreEnergy": "ERS Store Energy",
      "m_ersDeployMode": "ERS Deploy Mode",
      "m_ersHarvestedThisLapMGUK": "ERS Harvested This Lap MGUK",
      "m_ersHarvestedThisLapMGUH": "ERS Harvested This Lap MGUH",
      "m_ersDeployedThisLap": "ERS Deployed This Lap",
    };

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        title: Row(
          children: <Widget>[
            Icon(Icons.car_repair, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
                child: Text('Car Status',
                    style: TextStyle(fontSize: 16.0))),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: averages.keys.map((key) {
          if (fieldNames[key] == null) return Container();
          String displayName = fieldNames[key] ?? key;
          return ListTile(
            title: Text(displayName),
            trailing: Text(_roundValue(averages[key]).toString()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMotionSection(List<Map<String, dynamic>> data) {
    List<FlSpot> spots = data.map((row) {
      double x = double.tryParse(row['m_worldPositionX'].toString()) ?? 0;
      double y = double.tryParse(row['m_worldPositionY'].toString()) ?? 0;
      return FlSpot(x, y);
    }).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        title: Row(
          children: <Widget>[
            Icon(Icons.motion_photos_on, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
                child: Text('Motion',
                    style: TextStyle(fontSize: 16.0))),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int startFrame = widget.firstEntry['m_frameIdentifier'];
    int endFrame = widget.lastEntry['m_frameIdentifier'];

    var filteredCarStatus = _filterData(_carStatus, startFrame, endFrame);
    var filteredCarTelemetry = _filterData(_carTelemetry, startFrame, endFrame);
    var filteredEvents = _filterData(_events, startFrame, endFrame);
    var filteredMotion = _filterData(_motion, startFrame, endFrame);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lap Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCarSetupSection(),
            _buildCarStatusSection(filteredCarStatus),
            _buildCarTelemetrySection(filteredCarTelemetry),
            _buildEventsSection(filteredEvents),
            _buildMotionSection(filteredMotion),
          ],
        ),
      ),
    );
  }
}