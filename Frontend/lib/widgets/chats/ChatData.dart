class ChatData {
  final String chatId;
  final String otherUserId;
  final String latestMessageContent;
  final String latestMessageSender;
  final DateTime latestMessageCreatedAt;
  final bool isReadByOwner;
  final bool isReadByRenter;
  final String parkingAddress;
  final String parkingZipCode;
  final String parkingCity;

  ChatData({
    required this.chatId,
    required this.otherUserId,
    required this.latestMessageContent,
    required this.latestMessageSender,
    required this.latestMessageCreatedAt,
    required this.isReadByOwner,
    required this.isReadByRenter,
    required this.parkingAddress,
    required this.parkingZipCode,
    required this.parkingCity,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatId: json['chatId'],
      otherUserId: json['otherUserId'],
      latestMessageContent: json['latestMessage']['content'],
      latestMessageSender: json['latestMessage']['sender'],
      latestMessageCreatedAt: DateTime.parse(json['latestMessage']['createdAt']),
      isReadByOwner: json['isReadByOwner'],
      isReadByRenter: json['isReadByRenter'],
      parkingAddress: json['parkingSpace']['address'],
      parkingZipCode: json['parkingSpace']['zipCode'],
      parkingCity: json['parkingSpace']['city'],
    );
  }
}