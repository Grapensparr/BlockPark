import 'package:flutter/material.dart';

class ChatModel {
  final String chatId;
  final String userId;
  final String currentMessage;
  final IconData icon;
  final String time;
  final bool isReadByOwner;
  final bool isReadByRenter;
  final String parkingAddress;
  final String parkingZipCode;
  final String parkingCity;

  ChatModel({
    required this.chatId,
    required this.userId,
    required this.currentMessage,
    required this.icon,
    required this.time,
    required this.isReadByOwner,
    required this.isReadByRenter,
    required this.parkingAddress,
    required this.parkingZipCode,
    required this.parkingCity,
  });
}