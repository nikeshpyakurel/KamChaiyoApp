import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object> get props => [];
}

class ConversationOpened extends ConversationEvent {
  final String chatId;
  const ConversationOpened(this.chatId);
  @override
  List<Object> get props => [chatId];
}

class MessageSent extends ConversationEvent {
  final String content;
  const MessageSent(this.content);
  @override
  List<Object> get props => [content];
}

class MessageReceived extends ConversationEvent {
  final MessageEntity message;
  const MessageReceived(this.message);
  @override
  List<Object> get props => [message];
}

class TypingStarted extends ConversationEvent {}
class TypingStopped extends ConversationEvent {}

class TypingStatusReceived extends ConversationEvent {
  final bool isTyping;
  const TypingStatusReceived(this.isTyping);
  @override
  List<Object> get props => [isTyping];
}