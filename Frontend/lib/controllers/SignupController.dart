import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  static const URL = 'https://lionfish-app-yctot.ondigitalocean.app';

  Future<void> registerUser(ScaffoldMessengerState scaffoldMessenger) async {
    final username = fullName.text.trim();
    final userDateOfBirth = dateOfBirth.text.trim();
    final userEmail = email.text.trim();
    final userPassword = password.text.trim();

    final user = {
      'name': username,
      'dateOfBirth': userDateOfBirth,
      'email': userEmail,
      'password': userPassword,
    };

    try {
      final response = await http.post(
        Uri.parse('$URL/users/add'),
        headers: {
          'Content-Type': 'application/JSON',
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('User with email ${data['email']} has been created!'),
          ),
        );
      } else if (response.statusCode == 400 && response.body.contains('Email already exists')) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('User with this email already exists.'),
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }
}