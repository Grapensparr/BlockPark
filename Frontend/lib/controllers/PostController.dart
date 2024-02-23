import 'dart:convert';
import 'package:blockpark/providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PostController {
  static const String baseUrl = 'https://lionfish-app-yctot.ondigitalocean.app';

  static Future<void> addParkingSpace({
    required String address,
    required String zipCode,
    required String city,
    required DateTime startDate,
    required DateTime? endDate,
    required double price,
    required String paymentSchedule,
    required bool isGarage,
    required bool isParkingSpace,
    required bool accessibility,
    required bool largeVehicles,
    required Map<String, Map<String, String>> dayTimes,
    required ScaffoldMessengerState scaffoldMessenger,
  }) async {
    try {
      final authProvider = AuthProvider();
      await authProvider.checkLoggedInUser();

      final ownerEmail = authProvider.loggedInUserEmail;

      if (ownerEmail != null) {
        final userId = await getUserIdByEmail(ownerEmail);

        if (userId != null) {
          final response = await http.post(
            Uri.parse('$baseUrl/parking/add'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'address': address,
              'zipCode': zipCode,
              'city': city,
              'startDate': startDate.toIso8601String(),
              'endDate': endDate?.toIso8601String(),
              'price': price,
              'paymentSchedule': paymentSchedule,
              'isGarage': isGarage,
              'isParkingSpace': isParkingSpace,
              'accessibility': accessibility,
              'largeVehicles': largeVehicles,
              'dayTimes': dayTimes,
              'owner': userId,
            }),
          );

          if (response.statusCode == 201) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Parking space added successfully'),
              ),
            );
          } else {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Failed to add parking space: ${response.body}'),
              ),
            );
          }
        }
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error adding parking space: $e'),
        ),
      );
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