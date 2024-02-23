import 'package:blockpark/controllers/FetchController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AuthProvider with ChangeNotifier {
  String? _loggedInUserEmail;
  String? _loggedInUserId;
  late io.Socket socket;

  String? get loggedInUserEmail => _loggedInUserEmail;
  String? get loggedInUserId => _loggedInUserId;

  bool get isLoggedIn => _loggedInUserEmail != null;

  void connect() {
    socket = io.io('https://lionfish-app-yctot.ondigitalocean.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  Future<void> login(String email) async {
    try {
      final userId = await FetchController.getUserIdByEmail(email);
      if (userId != null) {
        _loggedInUserEmail = email;
        _loggedInUserId = userId;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserEmail', email);
        await prefs.setString('loggedInUserId', userId);
        connect();
        socket.emit('authenticate', loggedInUserId);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch user ID');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<void> logout() async {
    _loggedInUserEmail = null;
    _loggedInUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserEmail');
    await prefs.remove('loggedInUserId');
    socket.disconnect();
    notifyListeners();
  }

  Future<void> checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInUserEmail');
    final userId = prefs.getString('loggedInUserId');
    if (email != null && userId != null) {
      _loggedInUserEmail = email;
      _loggedInUserId = userId;
      notifyListeners();
    }
  }
}