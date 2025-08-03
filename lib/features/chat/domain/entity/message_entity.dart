import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/user_chat_entity.dart';

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final DateTime createdAt;
  final UserChatEntity sender;
  final String chatId; 

  const MessageEntity({required this.id, required this.content, required this.createdAt, required this.sender,    required this.chatId,});
  @override
  List<Object> get props => [id,chatId, content, createdAt, sender];
}