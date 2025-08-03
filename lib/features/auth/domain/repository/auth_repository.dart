import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  });
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
    String role,
  );
  Future<Either<Failure, UserEntity?>> checkAuthStatus();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    File? avatar,
    File? resume,
    String? bio,
    List<String>? skills,
  });
}
