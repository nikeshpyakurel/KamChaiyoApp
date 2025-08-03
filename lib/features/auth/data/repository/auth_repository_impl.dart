import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:kamchaiyo/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final loginResponseDto = await remoteDataSource.login(
        email,
        password,
        role,
      );
      await localDataSource.saveToken(loginResponseDto.accessToken);
      await localDataSource.cacheUser(loginResponseDto.user.toHiveModel());
      return Right(loginResponseDto.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final userDto = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      return Right(userDto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> checkAuthStatus() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      final token = await localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }
      final userDto = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userDto.toHiveModel());
      return Right(userDto.toEntity());
    } on ServerException {
      await localDataSource.clearToken();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Local storage error.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear local data.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    File? avatar,
    File? resume,
    String? bio,
    List<String>? skills,
  }) async {
    try {
      final userDto = await remoteDataSource.updateProfile(
        fullName: fullName,
        avatar: avatar,
        resume: resume,
        bio: bio,
        skills: skills,
      );
      await localDataSource.cacheUser(userDto.toHiveModel());
      return Right(userDto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
