import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:kamchaiyo/features/chatbot/domain/use_case/send_chat_query_usecase.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendChatQueryUseCase _sendChatQueryUseCase;

  ChatbotBloc({required SendChatQueryUseCase sendChatQueryUseCase})
      : _sendChatQueryUseCase = sendChatQueryUseCase,
        super(const ChatbotState(
          messages: [
            ChatMessageEntity(
              role: ChatRole.model,
              text: "Namaste! I am KamChaiyo Helper. How can I help you find a job today?",
            ),
          ],
        )) {
    on<ChatbotMessageSent>(_onChatbotMessageSent);
  }

  Future<void> _onChatbotMessageSent(
    ChatbotMessageSent event,
    Emitter<ChatbotState> emit,
  ) async {
    final userMessage =
        ChatMessageEntity(role: ChatRole.user, text: event.message);
    emit(state.copyWith(
      status: ChatbotStatus.loading,
      messages: [...state.messages, userMessage],
    ));

    final history = state.messages.where((m) => m.role != ChatRole.model || m.text.contains("Namaste!") == false).toList();

    final params = SendChatQueryParams(query: event.message, history: history);
    final result = await _sendChatQueryUseCase(params);

    result.fold(
      (failure) {
        final errorMessage = ChatMessageEntity(
            role: ChatRole.model, text: "Sorry, I'm having trouble connecting. Please try again.");
        emit(state.copyWith(
            status: ChatbotStatus.failure,
            error: failure.message,
            messages: [...state.messages, errorMessage]));
      },
      (response) {
        final modelMessage =
            ChatMessageEntity(role: ChatRole.model, text: response);
        emit(state.copyWith(
            status: ChatbotStatus.success,
            messages: [...state.messages, modelMessage]));
      },
    );
  }
}