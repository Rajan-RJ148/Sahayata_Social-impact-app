import 'user.dart';

/// Chat Message Model
class ChatMessage {
  final String id;
  final String text;
  final bool isSent; // true if sent by current user
  final DateTime timestamp;
  final bool hasReaction;
  final String? reaction;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.hasReaction = false,
    this.reaction,
  });
}

/// Chat Conversation Model
class ChatConversation {
  final String id;
  final User otherUser;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String category; // 'food help', 'medical help', etc.

  ChatConversation({
    required this.id,
    required this.otherUser,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.category,
  });
}
