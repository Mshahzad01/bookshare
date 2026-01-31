import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? bookId;
  final String? bookTitle;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.bookId,
    this.bookTitle,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderName,
        senderAvatar,
        receiverId,
        message,
        timestamp,
        isRead,
        bookId,
        bookTitle,
      ];
}

class ChatConversation extends Equatable {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? bookId;
  final String? bookTitle;

  const ChatConversation({
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.bookId,
    this.bookTitle,
  });

  @override
  List<Object?> get props => [
        conversationId,
        otherUserId,
        otherUserName,
        otherUserAvatar,
        lastMessage,
        lastMessageTime,
        unreadCount,
        bookId,
        bookTitle,
      ];
}
