import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';
import 'package:uuid/uuid.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) async {
    final userEntity = UserEntity(id: const Uuid().v4(), fullName: params.fullName, email: params.email, phone: params.phone);
    return await _repository.signup(userEntity, params.password);
  }
}

class SignupParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  const SignupParams({required this.fullName, required this.email, required this.phone, required this.password});
  @override
  List<Object?> get props => [fullName, email, phone, password];
}