import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class UpdateJobUseCase implements UseCase<JobEntity, UpdateJobParams> {
  final JobRepository repository;
  UpdateJobUseCase(this.repository);

  @override
  Future<Either<Failure, JobEntity>> call(UpdateJobParams params) {
    return repository.updateJob(params);
  }
}

class UpdateJobParams extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> requirements;
  final int salary;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String companyId;

  const UpdateJobParams({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.salary,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.companyId,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'requirements': requirements,
        'salary': salary,
        'location': location,
        'jobType': jobType,
        'experienceLevel': experienceLevel,
        'companyId': companyId,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        requirements,
        salary,
        location,
        jobType,
        experienceLevel,
        companyId
      ];
}