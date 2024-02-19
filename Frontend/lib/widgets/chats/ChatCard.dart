import 'package:blockpark/widgets/chats/ChatModel.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chatModel;

  const ChatCard({required this.chatModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(chatModel.icon),
        title: Text(chatModel.userId),
        subtitle: Text(chatModel.currentMessage),
        onTap: () {

        },
      ),
    );
  }
}