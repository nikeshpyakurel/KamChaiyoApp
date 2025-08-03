import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class GetJobByIdUseCase implements UseCase<JobEntity, String> {
  final JobRepository repository;
  GetJobByIdUseCase(this.repository);

  @override
  Future<Either<Failure, JobEntity>> call(String jobId) {
    return repository.getJobById(jobId);
  }
}