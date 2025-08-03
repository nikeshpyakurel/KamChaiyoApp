import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';
import 'package:kamchaiyo/features/chat/domain/repository/chat_repository.dart';

class GetMyChatsUseCase implements UseCase<List<ChatEntity>, NoParams> {
  final ChatRepository repository;
  GetMyChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(NoParams params) {
    return repository.getMyChats();
  }
}
