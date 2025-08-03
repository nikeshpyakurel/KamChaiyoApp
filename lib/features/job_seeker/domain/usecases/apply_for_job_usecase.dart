import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class ApplyForJobUseCase implements UseCase<void, ApplyForJobParams> {
  final JobSeekerRepository repository;
  ApplyForJobUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ApplyForJobParams params) {
    return repository.applyForJob(params);
  }
}

class ApplyForJobParams extends Equatable {
  final String jobId;

  const ApplyForJobParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}