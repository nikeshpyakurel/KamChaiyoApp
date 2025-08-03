import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class GetMyPostedJobsUseCase implements UseCase<List<JobEntity>, NoParams> {
  final JobRepository repository;
  GetMyPostedJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<JobEntity>>> call(NoParams params) {
    return repository.getMyPostedJobs();
  }
}