import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UpdateController {
  static const String baseUrl = 'http://localhost:3000';

  static Future<void> updateParkingStatus(String parkingId, String status, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parking/updateStatus'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'parkingId': parkingId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status updated successfully'),
          ),
        );
      } else {
        throw Exception('Failed to update listing');
      }
    } catch (e) {
      throw Exception('Error updating listing: $e');
    }
  }

  static Future<void> removeEntry(String parkingId, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parking/delete'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'parkingId': parkingId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your listing was successfully removed'),
          ),
        );
      } else {
        throw Exception('Failed to remove listing');
      }
    } catch (e) {
      throw Exception('Error removing listing: $e');
    }
  }

  static Future<void> createBooking(String parkingId, String status, String renterId, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parking/createBooking'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'parkingId': parkingId,
          'status': status,
          'renterId': renterId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking created successfully'),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Renter ID is required when updating status to "rented"'),
          ),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing not found'),
          ),
        );
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }
}