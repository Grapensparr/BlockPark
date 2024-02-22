import 'dart:convert';
import 'package:blockpark/widgets/chats/ChatData.dart';
import 'package:blockpark/widgets/chats/MessageModel.dart';
import 'package:http/http.dart' as http;
import 'package:blockpark/providers/AuthProvider.dart';

class ChatController {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> createOrFetchChat(String owner, String parkingSpaceId) async {
    try {
      final authProvider = AuthProvider();
      await authProvider.checkLoggedInUser();

      final userId = authProvider.loggedInUserId;

      if (userId != null) {
        final renter = userId;

        final response = await http.post(
          Uri.parse('$baseUrl/chat/new'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'owner': owner,
            'renter': renter,
            'parkingSpaceId': parkingSpaceId,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final chatData = jsonDecode(response.body);
          return chatData;
        } else {
          throw Exception('Failed to create or fetch chat: ${response.body}');
        }
      } else {
        throw Exception('User ID not found');
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

      final userId = authProvider.loggedInUserId;

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
    } catch (e) {
      throw Exception('Error fetching chats by user: $e');
    }
  }

  static Future<List<MessageModel>> fetchMessagesByChatId(String chatId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/fetchMessages'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chatId': chatId,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> messagesData = jsonDecode(response.body);
        List<MessageModel> messages = messagesData.map((data) => MessageModel.fromJson(data)).toList();
        return messages;
      } else {
        throw Exception('Failed to fetch messages by chat ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching messages by chat ID: $e');
    }
  }

  static Future<void> saveMessage(String chatId, MessageModel message, String senderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/saveMessage'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chatId': chatId,
          'message': message.toJson(),
          'senderId': senderId,
        }),
      );

      if (response.statusCode == 201) {
        print('Message saved successfully');
      } else {
        print('Failed to save message: ${response.body}');
      }
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  static Future<void> updateMessageReadStatus(String chatId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/updateMessageReadStatus'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chatId': chatId,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Message read status updated successfully');
      } else {
        print('Failed to update message read status: ${response.body}');
      }
    } catch (e) {
      print('Error updating message read status: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchChatDataById(String chatId) async {
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
        throw Exception('Failed to fetch chat data by ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching chat data by ID: $e');
    }
  }
}