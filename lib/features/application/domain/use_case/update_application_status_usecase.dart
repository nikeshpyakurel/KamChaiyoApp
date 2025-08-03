import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';

class UpdateApplicationStatusUseCase
    implements UseCase<ApplicationEntity, UpdateApplicationStatusParams> {
  final ApplicationRepository repository;
  UpdateApplicationStatusUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationEntity>> call(UpdateApplicationStatusParams params) {
    return repository.updateApplicationStatus(params.applicationId, params.status);
  }
}

class UpdateApplicationStatusParams extends Equatable {
  final String applicationId;
  final String status;

  const UpdateApplicationStatusParams({required this.applicationId, required this.status});
  @override
  List<Object> get props => [applicationId, status];
}