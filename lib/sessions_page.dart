import 'package:flutter/material.dart';
import 'telemetry_data_page.dart';

class SessionsPage extends StatefulWidget {
  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<Session> sessions = [
    Session(date: 'April 9, 2024', country: 'Austria'),
    Session(date: 'April 8, 2024', country: 'Monza, Italy'),
    Session(date: 'April 7, 2024', country: 'Japan'),
    Session(date: 'April 4, 2024', country: 'Monaco'),
  ];

  void deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return SessionTile(
              session: sessions[index],
              onDelete: () => deleteSession(index),
            );
          },
        ),
      ),
    );
  }
}

class SessionTile extends StatelessWidget {
  final Session session;
  final VoidCallback onDelete;

  SessionTile({required this.session, required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
            Icon(Icons.flag, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
                child: Text('${session.country} - ${session.date}',
                    style: TextStyle(fontSize: 16.0))),
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        children: <Widget>[
          ListTile(
            title: Text('Telemetry Data'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelemetryDataPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('AI Analysis'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkInProgressPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Delete session',
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.close, color: Colors.red),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class Session {
  final String date;
  final String country;

  Session({required this.date, required this.country});
}

class WorkInProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: Text(
          'Work In Progress',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}