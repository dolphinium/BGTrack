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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bloodGlucoseService.getStatisticsForLast30Days(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int averageGlucose = (snapshot.data?['avgGlucose'] as num).toInt();
            int stdDev = (snapshot.data?['stdDev'] as num).toInt();
            double ttrHigh = (snapshot.data?['ttrHigh'] as num).toDouble();
            double ttrInTarget = (snapshot.data?['ttrInTarget'] as num).toDouble();
            double ttrLow = (snapshot.data?['ttrLow'] as num).toDouble();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Summary of Last 30 Days',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Circle for Average Glucose
                  Column(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // You can change the color
                        ),
                        child: Center(
                          child: Text(
                            averageGlucose.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Average Glucose',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Circle for Standard Deviation
                  Column(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // You can change the color
                        ),
                        child: Center(
                          child: Text(
                            stdDev.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Standard Deviation',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // TTR Boxes
                  Column(
                    children: [
                      _buildTTRBox('High', ttrHigh, Colors.orange),
                      SizedBox(height: 8),
                      _buildTTRBox('In Target', ttrInTarget, Colors.green),
                      SizedBox(height: 8),
                      _buildTTRBox('Low', ttrLow, Colors.red),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTTRBox(String label, double percentage, Color color) {
    return Container(
      width: 120.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          '$label: ${percentage.toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
