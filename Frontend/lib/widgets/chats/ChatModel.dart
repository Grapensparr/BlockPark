import 'package:flutter/material.dart';

class ChatModel {
  String chatId;
  String userId;
  String currentMessage;
  IconData icon;
  String time;
  bool status;

  ChatModel({
    required this.chatId,
    required this.userId,
    required this.currentMessage,
    required this.icon,
    required this.time,
    required this.status,
  });
}