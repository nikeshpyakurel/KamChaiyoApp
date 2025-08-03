import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/user_profile/data/data_source/remote/user_profile_remote_data_source.dart';
import 'package:kamchaiyo/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:kamchaiyo/features/user_profile/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId) async {
    try {
      final result = await remoteDataSource.getUserProfile(userId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}