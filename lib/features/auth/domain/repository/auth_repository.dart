import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signup(UserEntity user, String password);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity?>> checkAuthStatus();
  Future<Either<Failure, void>> logout();
}