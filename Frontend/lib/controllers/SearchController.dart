import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchController {
  static const String baseUrl = 'https://lionfish-app-yctot.ondigitalocean.app';

  static Future<List<Map<String, dynamic>>> searchParking({
    String? city,
    DateTime? endDate,
    double? price,
    bool? isGarage,
    bool? isParkingSpace,
    bool? accessibility,
    bool? largeVehicles,
    List<String>? selectedDays,
    Map<String, Map<String, String>>? dayTimes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parking/search'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'city': city,
          'endDate': endDate?.toIso8601String(),
          'price': price,
          'isGarage': isGarage,
          'isParkingSpace': isParkingSpace,
          'accessibility': accessibility,
          'largeVehicles': largeVehicles,
          'selectedDays': selectedDays,
          'dayTimes': dayTimes,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> parkingSpaces = data.cast<Map<String, dynamic>>();
        return parkingSpaces;
      } else {
        throw Exception('Failed to search parking');
      }
    } catch (e) {
      throw Exception('Error searching parking: $e');
    }
  }
}