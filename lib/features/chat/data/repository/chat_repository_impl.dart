import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/chat/data/data_source/remote/chat_remote_data_source.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final AuthViewModel authViewModel; 

  ChatRepositoryImpl({required this.remoteDataSource, required this.authViewModel});

  @override
  Future<Either<Failure, List<ChatEntity>>> getMyChats() async {
    try {
      final UserEntity? currentUser = authViewModel.state.user;
      if (currentUser == null) {
        return Left(ServerFailure(message: 'User not logged in.'));
      }
      final result = await remoteDataSource.getMyChats();
      return Right(result.map((dto) => dto.toEntity(currentUser.id)).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId) async {
    try {
      final result = await remoteDataSource.getMessages(chatId);
      return Right(result.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String chatId, String content) async {
    try {
      final result = await remoteDataSource.sendMessage(chatId, content);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}