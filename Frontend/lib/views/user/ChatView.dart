import 'package:blockpark/controllers/ChatController.dart';
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/widgets/chats/ChatCard.dart';
import 'package:blockpark/widgets/chats/ChatData.dart';
import 'package:blockpark/widgets/chats/ChatModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late io.Socket socket;

  List<ChatModel> chats = [];

  @override
  void initState() {
    super.initState();
    connect();
    fetchChatsFromDatabase();
  }

  void connect() {
    socket = io.io('http://localhost:3000', <String, dynamic> {
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => print('Connected to server'));
  }

  void fetchChatsFromDatabase() async {
    try {
      final List<ChatData> chatData = await ChatController.fetchAllChatsByUser();
      setState(() {
        chats = chatData.map((data) => ChatModel(
          chatId: data.chatId,
          userId: data.otherUserId,
          currentMessage: data.latestMessageContent,
          icon: Icons.person,
          time: data.latestMessageCreatedAt.toString(),
          status: data.isReadByBoth
        )).toList();
      });
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: ListView.builder(
        itemBuilder: (context, index) => ChatCard(
          chatModel: chats[index]
        ),
        itemCount: chats.length,
      )
    );
  }
}