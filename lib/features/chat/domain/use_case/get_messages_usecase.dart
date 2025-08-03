import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<MessageEntity>, String> {
  final ChatRepository repository;
  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}