part of 'chatbot_bloc.dart';

enum ChatbotStatus { initial, loading, success, failure }

class ChatbotState extends Equatable {
  final ChatbotStatus status;
  final List<ChatMessageEntity> messages;
  final String? error;

  const ChatbotState({
    this.status = ChatbotStatus.initial,
    this.messages = const [],
    this.error,
  });

  ChatbotState copyWith({
    ChatbotStatus? status,
    List<ChatMessageEntity>? messages,
    String? error,
  }) {
    return ChatbotState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, messages, error];
}