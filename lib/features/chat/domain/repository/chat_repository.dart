import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getMyChats();
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId);
    Future<Either<Failure, MessageEntity>> sendMessage(String chatId, String content);
}