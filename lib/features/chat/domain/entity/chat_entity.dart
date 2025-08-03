import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/entity/user_chat_entity.dart';

class ChatEntity extends Equatable {
  final String id;
  final UserChatEntity otherUser;
  final MessageEntity? latestMessage;
  const ChatEntity({required this.id, required this.otherUser, this.latestMessage});
  @override
  List<Object?> get props => [id, otherUser, latestMessage];
}