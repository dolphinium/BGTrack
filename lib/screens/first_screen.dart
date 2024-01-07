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
        future: Future.wait([
          _bloodGlucoseService.getCurrentBloodGlucose(),
          _bloodGlucoseService.getHighestValueLast24Hours(),
          _bloodGlucoseService.getLowestValueLast24Hours(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int bloodGlucose = snapshot.data?[0] ?? 0; // Current blood glucose
            int highestValue = snapshot.data?[1] ?? 0;
            int lowestValue = snapshot.data?[2] ?? 0;

            Color containerColor;

            if (bloodGlucose > 200) {
              containerColor = Colors.orange;
            } else if (bloodGlucose < 80) {
              containerColor = Colors.red;
            } else {
              containerColor = Colors.green;
            }

            return Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 16.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: containerColor,
                      ),
                      child: Center(
                        child: Text(
                          bloodGlucose.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Highest Value: $highestValue'),
                Text('Lowest Value: $lowestValue'),
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
