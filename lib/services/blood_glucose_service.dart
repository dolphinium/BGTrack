import 'dart:convert';
import 'package:http/http.dart' as http;


class BloodGlucoseService {
  final String apiUrl = 'https://nightscout-web-trial.azurewebsites.net/api/v1/entries/sgv?count=1';

  Future<int> getCurrentBloodGlucose() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final glucoseEntry = data[0];
          final int currentBloodGlucose = glucoseEntry['sgv'];
          return currentBloodGlucose;
        } else {
          throw Exception('No data available');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getStatisticsForLast30Days() async {
    // Implement API call to get statistics for the last 90 days
    // Return a map containing avgGlucose, stdDev, ttrHigh, ttrInTarget, and ttrLow
    return {
      'avgGlucose': 140,
      'stdDev': 20,
      'ttrHigh': 15,
      'ttrInTarget': 70,
      'ttrLow': 15,
    };
  }
}
