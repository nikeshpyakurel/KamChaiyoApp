import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/chatbot/data/data_source/remote/chatbot_remote_data_source.dart';
import 'package:kamchaiyo/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:kamchaiyo/features/chatbot/domain/repository/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;
  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> sendQuery({
    required String query,
    required List<ChatMessageEntity> history,
  }) async {
    try {
      final historyForApi = history
          .map((msg) =>
              {'role': msg.role.name, 'text': msg.text})
          .toList();

      final result =
          await remoteDataSource.sendQuery(query: query, history: historyForApi);
      return Right(result.response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}