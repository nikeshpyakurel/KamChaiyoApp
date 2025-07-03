import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart'; 

class GetAllUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  final AdminRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}