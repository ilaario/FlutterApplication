import 'package:flutter/material.dart';
import 'setup_info.dart';

class CarSetupDetailPage extends StatelessWidget {
  final Map<String, dynamic> carSetupData;

  CarSetupDetailPage({required this.carSetupData});

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
  };

  String _roundValue(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  Widget _buildCarSetupDetail(BuildContext context, String category, List<String> fields) {
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
            Icon(Icons.settings, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text(category, style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: fields.map((field) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetupInfoPage(
                        columnName: fieldNames[field] ?? field,
                      ),
                    ),
                  );
                },
                child: Text(fieldNames[field] ?? field),
              ),
              trailing: Text(_roundValue(carSetupData[field]).toString()),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Setup Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            _buildCarSetupDetail(context, "Aerodynamics", [
              "m_frontWing",
              "m_rearWing",
            ]),
            _buildCarSetupDetail(context, "Transmission", [
              "m_onThrottle",
              "m_offThrottle",
            ]),
            _buildCarSetupDetail(context, "Suspension Geometry", [
              "m_frontCamber",
              "m_rearCamber",
              "m_frontToe",
              "m_rearToe",
            ]),
            _buildCarSetupDetail(context, "Suspension", [
              "m_frontSuspension",
              "m_rearSuspension",
              "m_frontAntiRollBar",
              "m_rearAntiRollBar",
              "m_frontSuspensionHeight",
              "m_rearSuspensionHeight",
            ]),
            _buildCarSetupDetail(context, "Brakes", [
              "m_brakePressure",
              "m_brakeBias",
            ]),
            _buildCarSetupDetail(context, "Tyres", [
              "m_frontRightTyrePressure",
              "m_frontLeftTyrePressure",
              "m_rearRightTyrePressure",
              "m_rearLeftTyrePressure",
            ]),
            _buildCarSetupDetail(context, "Ballast and Fuel", [
              "m_ballast",
              "m_fuelLoad",
            ]),
          ],
        ),
      ),
    );
  }
}
