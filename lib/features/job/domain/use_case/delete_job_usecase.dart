import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class DeleteJobUseCase implements UseCase<void, String> {
  final JobRepository repository;
  DeleteJobUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String jobId) {
    return repository.deleteJob(jobId);
  }
}