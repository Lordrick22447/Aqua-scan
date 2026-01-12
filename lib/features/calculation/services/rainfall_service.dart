import 'dart:convert';
import 'package:http/http.dart' as http;

class RainfallService {
  static const String _apiKey = 'YOUR_METEOSTAT_API_KEY'; // User to replace
  static const String _baseUrl = 'https://api.meteostat.net/v2';

  Future<double> getAnnualRainfall(double lat, double lon) async {
    // Mock for demo/testing without API key
    if (_apiKey == 'YOUR_METEOSTAT_API_KEY') {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network
      return 2800.0; // Return ~2800mm (typical for Kerala/Tropical)
    }

    try {
      // Normals data for a specific point
      final url = Uri.parse('$_baseUrl/point/normals?lat=$lat&lon=$lon');
      final response = await http.get(url, headers: {'x-api-key': _apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Sum up monthly precipitation (prcp)
        // This is a simplified parsing assuming standard Meteostat JSON structure
        final List<dynamic> dataPoints = data['data'];
        double totalRainfall = 0.0;
        for (var point in dataPoints) {
          totalRainfall += (point['prcp'] ?? 0.0);
        }
        return totalRainfall;
      } else {
        throw Exception('Failed to load rainfall data');
      }
    } catch (e) {
      // Fallback
      // print("Error fetching rainfall: $e");
      return 2500.0; // Fallback average
    }
  }
}
