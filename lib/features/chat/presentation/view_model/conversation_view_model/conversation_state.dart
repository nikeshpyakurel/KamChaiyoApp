import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';

enum ConversationStatus { initial, loading, success, failure }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<MessageEntity> messages;
  final String? error;
  final bool isTyping; 

  const ConversationState({
    this.status = ConversationStatus.initial,
    this.messages = const [],
    this.error,
    this.isTyping = false,
  });

  ConversationState copyWith({
    ConversationStatus? status,
    List<MessageEntity>? messages,
    String? error,
    bool? isTyping,
    bool clearError = false,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: clearError ? null : error,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [status, messages, error, isTyping];
}