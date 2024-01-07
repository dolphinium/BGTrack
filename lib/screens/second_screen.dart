import 'package:flutter/material.dart';
import '/services/blood_glucose_service.dart';

class SecondScreen extends StatelessWidget {
  final BloodGlucoseService _bloodGlucoseService = BloodGlucoseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary Page'),
      ),
      body: FutureBuilder(
        future: _bloodGlucoseService.getStatisticsForLast30Days(),
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
                  'Average Glucose: ${snapshot.data?['avgGlucose']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Standard Deviation: ${snapshot.data?['stdDev']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'TTR:',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'High: ${snapshot.data?['ttrHigh']}%',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                Text(
                  'In Target Range: ${snapshot.data?['ttrInTarget']}%',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                Text(
                  'Low: ${snapshot.data?['ttrLow']}%',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
