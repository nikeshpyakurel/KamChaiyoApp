import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';

class NoParams {}

class CheckAuthStatusUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;
  CheckAuthStatusUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await _repository.checkAuthStatus();
  }
}