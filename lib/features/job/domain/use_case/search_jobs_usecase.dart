import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';

class SearchJobsUseCase implements UseCase<List<JobEntity>, SearchJobsParams> {
  final JobRepository repository;
  SearchJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<JobEntity>>> call(SearchJobsParams params) {
    return repository.searchJobs(
        keyword: params.keyword, location: params.location);
  }
}

class SearchJobsParams extends Equatable {
  final String? keyword;
  final String? location;

  const SearchJobsParams({this.keyword, this.location});

  @override
  List<Object?> get props => [keyword, location];
}