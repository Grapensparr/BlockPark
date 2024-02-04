import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  static const URL = 'http://localhost:3000';

  Future<void> loginUser(ScaffoldMessengerState scaffoldMessenger) async {
    final userEmail = email.text.trim();
    final userPassword = password.text.trim();

    final user = {
      'email': userEmail,
      'password': userPassword,
    };

    try {
      final response = await http.post(
        Uri.parse('$URL/users/login'),
        headers: {
          'Content-Type': 'application/JSON',
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
          ),
        );
      } else {
        final message = jsonDecode(response.body)['msg'];
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Login failed: $message'),
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