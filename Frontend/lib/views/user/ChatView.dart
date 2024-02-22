import 'package:blockpark/controllers/ChatController.dart';
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/widgets/chats/ChatCard.dart';
import 'package:blockpark/widgets/chats/ChatData.dart';
import 'package:blockpark/widgets/chats/ChatModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late io.Socket socket;

  List<ChatModel> chats = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    connect();
    fetchChatsFromDatabase();
  }

  void connect() {
    socket = io.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => print('Connected to server'));
  }

  void fetchChatsFromDatabase() async {
    try {
      final List<ChatData> chatData = await ChatController.fetchAllChatsByUser();

      chatData.sort((a, b) => b.latestMessageCreatedAt.compareTo(a.latestMessageCreatedAt));

      setState(() {
        chats = chatData.map((data) => ChatModel(
          chatId: data.chatId,
          userId: data.otherUserId,
          currentMessage: data.latestMessageContent,
          icon: Icons.person,
          time: data.latestMessageCreatedAt.toString(),
          isReadByOwner: data.isReadByOwner,
          isReadByRenter: data.isReadByRenter,
          parkingAddress: data.parkingAddress,
          parkingZipCode: data.parkingZipCode,
          parkingCity: data.parkingCity,
        )).toList();
        loading = false;
      });
    } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : chats.isEmpty
          ? const Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have any chat history.\nBegin your parking rental journey by either:",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Posting an advertisement"),
                    SizedBox(width: 5),
                    Icon(Icons.add_box),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "or",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Responding to an available advertisement"),
                    SizedBox(width: 5),
                    Icon(Icons.reply),
                  ],
                ),
              ],
            ),
          )
          : ListView.builder(
            itemBuilder: (context, index) => ChatCard(chatModel: chats[index]),
            itemCount: chats.length,
          ),
    );
  }
}