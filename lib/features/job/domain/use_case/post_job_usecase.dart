import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class PostJobUseCase implements UseCase<JobEntity, PostJobParams> {
  final JobRepository repository;
  PostJobUseCase(this.repository);

  @override
  Future<Either<Failure, JobEntity>> call(PostJobParams params) {
    return repository.postJob(params);
  }
}

class PostJobParams extends Equatable {
  final String title;
  final String description;
  final List<String> requirements;
  final int salary;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String companyId;

  const PostJobParams({
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