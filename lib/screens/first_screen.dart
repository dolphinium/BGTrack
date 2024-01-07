import 'package:flutter/material.dart';
import 'second_screen.dart';
import '/services/blood_glucose_service.dart';

class FirstScreen extends StatelessWidget {
  final BloodGlucoseService _bloodGlucoseService = BloodGlucoseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose App'),
      ),
      body: FutureBuilder(
        future: _bloodGlucoseService.getCurrentBloodGlucose(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Blood Glucose: ${snapshot.data}',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                  },
                  child: Text('Go to Second Screen'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
