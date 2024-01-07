import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class BloodGlucoseService {
  final String lastBG = 'https://nightscout-web-trial.azurewebsites.net/api/v1/entries/sgv?count=1';
  final String monthlyBG = 'https://nightscout-web-trial.azurewebsites.net/api/v1/entries/sgv?count=8640';
  final String lastDayBG = 'https://nightscout-web-trial.azurewebsites.net/api/v1/entries/sgv?count=288';

  Future<int> getCurrentBloodGlucose() async {
    try {
      final response = await http.get(Uri.parse(lastBG), headers: {'accept': 'application/json'});

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
    try {
      final response = await http.get(Uri.parse(monthlyBG), headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final List<int> glucoseValues = data.map<int>((entry) => entry['sgv']).toList();

          final double avgGlucose = glucoseValues.reduce((a, b) => a + b) / glucoseValues.length;
          final double stdDev = _calculateStandardDeviation(glucoseValues);
          final int ttrHigh = glucoseValues.where((value) => value > 200).length;
          final int ttrInTarget = glucoseValues.where((value) => value >= 60 && value <= 200).length;
          final int ttrLow = glucoseValues.where((value) => value < 60).length;

          return {
            'avgGlucose': avgGlucose,
            'stdDev': stdDev,
            'ttrHigh': (ttrHigh / glucoseValues.length * 100).round(),
            'ttrInTarget': (ttrInTarget / glucoseValues.length * 100).round(),
            'ttrLow': (ttrLow / glucoseValues.length * 100).round(),
          };
        } else {
          throw Exception('No data available for the last 30 days');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<int> getHighestValueLast24Hours() async {
    try {
      final response = await http.get(Uri.parse(lastDayBG), headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final highestValue = data.map((entry) => entry['sgv'] as int).reduce((a, b) => a > b ? a : b);
          return highestValue;
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

  Future<int> getLowestValueLast24Hours() async {
    try {
      final response = await http.get(Uri.parse(lastDayBG), headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lowestValue = data.map((entry) => entry['sgv'] as int).reduce((a, b) => a < b ? a : b);
          return lowestValue;
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
}
  double _calculateStandardDeviation(List<int> values) {
    final double mean = values.reduce((a, b) => a + b) / values.length;
    final double variance = values.map((value) => (value - mean) * (value - mean)).reduce((a, b) => a + b) / values.length;
    return variance > 0 ? sqrt(variance) : 0;
  }

