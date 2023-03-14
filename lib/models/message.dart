import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_pet/resources/chat_methods.dart';

enum MessageType { text, sticker, image }

class Message {
  final MessageType messageType;
  final String message;
  final String senderID;
  final String receiverID;
  final DateTime timestamp;
  get token {
    return ChatMethods.getToken(senderID, receiverID);
  }

  Message({
    required this.senderID,
    required this.receiverID,
    required this.timestamp,
    required this.message,
    required this.messageType,
  });

  factory Message.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? snapshotOptions) {
    final data = snapshot.data()!;
    return Message(
        message: data["message"]!,
        timestamp: data["timestamp"]!,
        senderID: data["senderID"]!,
        receiverID: data["receiverID"]!,
        messageType: data["messageType"]!);
  }
  Map<String, dynamic> toFireStore() {
    return {
      'messageType': messageType,
      'message': message,
      'senderID': senderID,
      'receiverID': receiverID,
      'timestamp': timestamp,
    };
  }
}
