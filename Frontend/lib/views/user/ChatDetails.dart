import 'package:blockpark/providers/AuthProvider.dart';
import 'package:blockpark/widgets/chats/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:blockpark/controllers/ChatController.dart';
import 'package:intl/intl.dart';

class ChatDetails extends StatefulWidget {
  final String chatId;
  final VoidCallback onClose;

  const ChatDetails({Key? key, required this.chatId, required this.onClose}) : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageModel> _messages = [];
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    initCurrentUser();
  }

  void initCurrentUser() async {
    final authProvider = AuthProvider();
    await authProvider.checkLoggedInUser();
    currentUserId = authProvider.loggedInUserId!;
    updateMessageReadStatus();
  }

  void updateMessageReadStatus() async {
    try {
      await ChatController.updateMessageReadStatus(widget.chatId, currentUserId);
    } catch (e) {
      print('Error updating message read status: $e');
    }
  }

  void fetchMessages() async {
    try {
      List<MessageModel> messages = await ChatController.fetchMessagesByChatId(widget.chatId);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String messageText) async {
    try {
      final newMessage = MessageModel(
        senderId: currentUserId,
        text: messageText,
        timestamp: DateTime.now(),
      );
      await ChatController.saveMessage(widget.chatId, newMessage, currentUserId);
      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Details'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index]; 
                final isCurrentUser = message.senderId == currentUserId;
                if (index == _messages.length - 1) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            message.text,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(message.timestamp),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(message.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(message.timestamp),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String messageText = _messageController.text;
                    if (messageText.isNotEmpty) {
                      sendMessage(messageText);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}