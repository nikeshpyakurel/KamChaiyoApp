import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';

class GetJobApplicantsUseCase implements UseCase<List<ApplicationEntity>, String> {
  final ApplicationRepository repository;
  GetJobApplicantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ApplicationEntity>>> call(String jobId) {
    return repository.getJobApplicants(jobId);
  }
}