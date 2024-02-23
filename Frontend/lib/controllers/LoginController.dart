import 'dart:convert';
import 'package:blockpark/providers/AuthProvider.dart';
import 'package:blockpark/routing/UserRouting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  static const URL = 'https://lionfish-app-yctot.ondigitalocean.app';

  Future<void> loginUser(ScaffoldMessengerState scaffoldMessenger, BuildContext context) async {
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

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.login(userEmail);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserRouting(),
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