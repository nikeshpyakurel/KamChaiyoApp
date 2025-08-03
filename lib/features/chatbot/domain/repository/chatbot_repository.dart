import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chatbot/domain/entity/chat_message_entity.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, String>> sendQuery({
    required String query,
    required List<ChatMessageEntity> history,
  });
}