import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';

class ApplyForJobUseCase implements UseCase<void, String> {
  final ApplicationRepository repository;
  ApplyForJobUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String jobId) {
    return repository.applyForJob(jobId);
  }
}