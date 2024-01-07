import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      body: FutureBuilder<List>(
        future: Future.wait([
          _bloodGlucoseService.getCurrentBloodGlucose(),
          _bloodGlucoseService.getHighestValueLast24Hours(),
          _bloodGlucoseService.getLowestValueLast24Hours(),
          _bloodGlucoseService.getLast10BloodGlucoseWithTimestamp(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int bloodGlucose = (snapshot.data?[0] as int?) ?? 0;
            bloodGlucose = 31;
            int highestValue = (snapshot.data?[1] as int?) ?? 0;
            int lowestValue = (snapshot.data?[2] as int?) ?? 0;
            List<Map<String, dynamic>> last10BloodGlucose =
                (snapshot.data?[3] as List?)?.cast<Map<String, dynamic>>() ?? [];

            Color containerColor;
            String emoji = '';

            if (bloodGlucose > 200) {
              containerColor = Colors.orange;
              emoji = '🫣';
            } else if (bloodGlucose >= 80 && bloodGlucose <= 200) {
              containerColor = Colors.green;
              emoji = '😍';
            } else {
              containerColor = Colors.red;
              emoji = '☠️';
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
                        child: RichText(
                          text: TextSpan(
                            text: bloodGlucose.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: '\n$emoji', style: TextStyle(fontSize: _getEmojiSize(context))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Highest Value: $highestValue'),
                Text('Lowest Value: $lowestValue'),
                SizedBox(height: 20),
                Text('Last 10 Values:'),
                Expanded(
                  child: ListView.builder(
                    itemCount: last10BloodGlucose.length,
                    itemBuilder: (context, index) {
                      String timestamp = last10BloodGlucose[index]['timestamp'];
                      int sgv = last10BloodGlucose[index]['sgv'];
                      String emoji = _getEmojiForBloodGlucose(sgv);

                      return ListTile(
                        title: Text('$sgv $emoji'),
                        subtitle: Text('Time: ${DateFormat.Hm().format(DateTime.parse(timestamp))}'),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                  },
                  child: Text('Go to Summary Screen'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String _getEmojiForBloodGlucose(int bloodGlucose) {
    if (bloodGlucose > 200) {
      return '🫣';
    } else if (bloodGlucose >= 80 && bloodGlucose <= 200) {
      return '😍';
    } else {
      return '☠️';
    }
  }

  double _getEmojiSize(BuildContext context) {
    // Adjust the emoji size based on the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600 ? 32.0 : 24.0;
  }
}
