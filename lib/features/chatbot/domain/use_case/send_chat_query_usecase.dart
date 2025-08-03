import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:kamchaiyo/features/chatbot/domain/repository/chatbot_repository.dart';

class SendChatQueryUseCase implements UseCase<String, SendChatQueryParams> {
  final ChatbotRepository repository;
  SendChatQueryUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendChatQueryParams params) {
    return repository.sendQuery(query: params.query, history: params.history);
  }
}

class SendChatQueryParams extends Equatable {
  final String query;
  final List<ChatMessageEntity> history;

  const SendChatQueryParams({required this.query, required this.history});

  @override
  List<Object?> get props => [query, history];
}