import 'package:flutter/material.dart';

class SetupInfoPage extends StatelessWidget {
  final String columnName;

  SetupInfoPage({required this.columnName});

  final Map<String, String> fieldDescriptionNames = {
    "Front Wing Aero": "The front wing aero setting adjusts the angle and positioning of the front wing flaps. These components play a crucial role in creating aerodynamic downforce, which pushes the car towards the track surface. By modifying the front wing aero, you can significantly influence the car’s handling characteristics, particularly in high-speed corners.",
    "Rear Wing Aero": "",
    "Differential Adjustment On Throttle": "",
    "Differential Adjustment Off Throttle": "",
    "Front Camber": "",
    "Rear Camber": "",
    "Front Toe-Out": "",
    "Rear Toe-In": "",
    "Front Suspension": "",
    "Rear Suspension": "",
    "Front Anti-Roll Bar": "",
    "Rear Anti-Roll Bar": "",
    "Front Ride Height": "",
    "Rear Ride Height": "",
    "Brake Pressure": "",
    "Front Brake Bias": "",
    "Front Right Tyre Pressure": "",
    "Front Left Tyre Pressure": "",
    "Rear Right Tyre Pressure": "",
    "Rear Left Tyre Pressure": "",
    "Ballast": "",
    "Fuel Load": "",
  };

  final Map<String, String> fieldImpactNames = {
    "Front Wing Aero": "\nIncreasing the front wing angle results in higher downforce at the front of the car, which enhances front-end grip, especially during cornering. This allows the driver to take corners at higher speeds with more precision and stability. However, this increase in downforce also generates more aerodynamic drag, which can reduce top speed on straights. Conversely, decreasing the front wing angle reduces downforce, leading to less grip in corners but decreasing drag, thus improving straight-line speed. Finding the right balance is key to optimizing both cornering performance and top speed.",
    "Rear Wing Aero": "",
    "Differential Adjustment On Throttle": "",
    "Differential Adjustment Off Throttle": "",
    "Front Camber": "",
    "Rear Camber": "",
    "Front Toe-Out": "",
    "Rear Toe-In": "",
    "Front Suspension": "",
    "Rear Suspension": "",
    "Front Anti-Roll Bar": "",
    "Rear Anti-Roll Bar": "",
    "Front Ride Height": "",
    "Rear Ride Height": "",
    "Brake Pressure": "",
    "Front Brake Bias": "",
    "Front Right Tyre Pressure": "",
    "Front Left Tyre Pressure": "",
    "Rear Right Tyre Pressure": "",
    "Rear Left Tyre Pressure": "",
    "Ballast": "",
    "Fuel Load": "",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Info'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              columnName,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${fieldDescriptionNames[columnName] ?? 'No data available'}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              '${fieldImpactNames[columnName] ?? 'No data available'}',
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }
}