import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';
import '../../data/dummy_data.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatLoading());

  void loadConversations() async {
    emit(ChatLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(ChatLoaded(conversations: DummyData.conversations));
  }
}
