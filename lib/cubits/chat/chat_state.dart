import 'package:equatable/equatable.dart';
import '../../models/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatConversation> conversations;

  const ChatLoaded({required this.conversations});

  @override
  List<Object> get props => [conversations];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
