import 'dart:convert';
import 'package:blockpark/widgets/chats/ChatData.dart';
import 'package:http/http.dart' as http;
import 'package:blockpark/providers/AuthProvider.dart';

class ChatController {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> createOrFetchChat(String owner, String renter) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/new'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'owner': owner,
          'renter': renter,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final chatData = jsonDecode(response.body);
        return chatData;
      } else {
        throw Exception('Failed to create or fetch chat: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating or fetching chat: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchChatById(String chatId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/fetchById'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chatId': chatId,
        }),
      );

      if (response.statusCode == 200) {
        final chatData = jsonDecode(response.body);
        return chatData;
      } else {
        throw Exception('Failed to fetch chat by ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching chat by ID: $e');
    }
  }

  static Future<List<ChatData>> fetchAllChatsByUser() async {
    try {
      final authProvider = AuthProvider();
      await authProvider.checkLoggedInUser();

      final userEmail = authProvider.loggedInUserEmail;

      if (userEmail != null) {
        final userId = await getUserIdByEmail(userEmail);

        if (userId != null) {
          final response = await http.post(
            Uri.parse('$baseUrl/chat/fetchAllByUser'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'userId': userId,
            }),
          );

          if (response.statusCode == 200) {
            final List<dynamic> chatDataList = jsonDecode(response.body);
            List<ChatData> chatData = chatDataList.map((data) => ChatData.fromJson(data)).toList();
            return chatData;
          } else {
            throw Exception('Failed to fetch chats by user: ${response.body}');
          }
        } else {
          throw Exception('User ID not found');
        }
      } else {
        throw Exception('Owner email not found');
      }
    } catch (e) {
      throw Exception('Error fetching chats by user: $e');
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