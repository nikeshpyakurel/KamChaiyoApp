import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository _repository;
  UpdateProfileUseCase(this._repository);
  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async => await _repository.updateProfile(fullName: params.fullName, avatar: params.avatar, resume: params.resume);
}

class UpdateProfileParams extends Equatable {
  final String? fullName;
  final File? avatar;
  final File? resume;
  const UpdateProfileParams({this.fullName, this.avatar, this.resume});
  @override
  List<Object?> get props => [fullName, avatar, resume];
}