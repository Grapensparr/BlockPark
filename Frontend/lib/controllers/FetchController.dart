import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blockpark/providers/AuthProvider.dart';

class FetchController {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<dynamic>> fetchParkingSpacesByOwner() async {
    try {
      final authProvider = AuthProvider();
      await authProvider.checkLoggedInUser();

      final ownerEmail = authProvider.loggedInUserEmail;

      if (ownerEmail != null) {
        final userId = await getUserIdByEmail(ownerEmail);

        if (userId != null) {
          final response = await http.post(
            Uri.parse('$baseUrl/parking/fetchByOwner'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'ownerId': userId,
            }),
          );

          if (response.statusCode == 200) {
            List<dynamic> parkingSpaces = jsonDecode(response.body);

            return parkingSpaces;
          } else {
            throw Exception('Failed to fetch parking spaces');
          }
        } else {
          throw Exception('User ID not found');
        }
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Error fetching parking spaces: $e');
    }
  }

  static Future<String?> getUserIdByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/idByEmail'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        return user['_id'];
      } else {
        print('Failed to fetch user: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}