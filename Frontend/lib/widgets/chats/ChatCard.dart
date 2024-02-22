import 'package:blockpark/routing/UserRouting.dart';
import 'package:blockpark/views/user/ChatDetails.dart';
import 'package:blockpark/widgets/chats/ChatModel.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chatModel;

  const ChatCard({required this.chatModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData renterCheckmark = chatModel.isReadByRenter ? Icons.check_circle_outline_rounded : Icons.radio_button_unchecked;
    IconData ownerCheckmark = chatModel.isReadByOwner ? Icons.check_circle_outline : Icons.radio_button_unchecked;

    return Card(
      child: ListTile(
        leading: Icon(chatModel.icon),
        title: Text('${chatModel.parkingAddress}, ${chatModel.parkingZipCode}, ${chatModel.parkingCity}'),
        subtitle: Row(
          children: [
            Text(chatModel.currentMessage),
            const SizedBox(width: 5),
            Icon(
              ownerCheckmark,
              size: 12,
              color: chatModel.isReadByOwner ? Colors.green : Colors.red,
            ),
            Icon(
              renterCheckmark,
              size: 12,
              color: chatModel.isReadByRenter ? Colors.green : Colors.red,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetails(
                chatId: chatModel.chatId,
                onClose: () {
                  UserRouting.userRoutingKey.currentState?.updateChatId(chatModel.chatId);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}