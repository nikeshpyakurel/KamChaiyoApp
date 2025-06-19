import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> signup(UserEntity user, String password) async {
    try {
      final hiveModel = AuthHiveModel(fullName: user.fullName, email: user.email, phone: user.phone, password: password);
      await localDataSource.signup(hiveModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final hiveModel = await localDataSource.login(email, password);
      return Right(hiveModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity?>> checkAuthStatus() async {
    try {
      final hiveModel = await localDataSource.getCachedUser();
      return Right(hiveModel?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.logout();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}