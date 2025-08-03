import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/repository/chat_repository.dart';

class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(params.chatId, params.content);
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String content;
  const SendMessageParams({required this.chatId, required this.content});
  @override
  List<Object> get props => [chatId, content];
}