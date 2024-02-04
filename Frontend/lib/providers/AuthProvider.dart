import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _loggedInUserEmail;

  String? get loggedInUserEmail => _loggedInUserEmail;

  bool get isLoggedIn => _loggedInUserEmail != null;

  Future<void> login(String email) async {
    _loggedInUserEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _loggedInUserEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
    notifyListeners();
  }

  Future<void> checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInUser');
    if (email != null) {
      _loggedInUserEmail = email;
      notifyListeners();
    }
  }
}