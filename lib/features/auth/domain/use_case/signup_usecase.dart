import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository _repository;
  SignupUseCase(this._repository);
  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) async => await _repository.register(fullName: params.fullName, email: params.email, phone: params.phone, password: params.password, role: params.role);
}

class SignupParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String role;
  const SignupParams({required this.fullName, required this.email, required this.phone, required this.password, required this.role});
  @override
  List<Object?> get props => [fullName, email, phone, password, role];
}