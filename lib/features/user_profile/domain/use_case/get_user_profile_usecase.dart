import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:kamchaiyo/features/user_profile/domain/repository/user_profile_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfileEntity, String> {
  final UserProfileRepository repository;
  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}