import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job_seeker/domain/entities/job_search_response_entity.dart';
import 'package:kamchaiyo/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class SearchJobsUseCase
    implements UseCase<JobSearchResponseEntity, SearchJobsParams> {
  final JobSeekerRepository repository;
  SearchJobsUseCase(this.repository);

  @override
  Future<Either<Failure, JobSearchResponseEntity>> call(
      SearchJobsParams params) {
    return repository.searchJobs(params);
  }
}

class SearchJobsParams extends Equatable {
  final String? keyword;
  final String? location;
  final String? jobType;
  final int page;

  const SearchJobsParams({
    this.keyword,
    this.location,
    this.jobType,
    this.page = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword,
      if (location != null && location!.isNotEmpty) 'location': location,
      if (jobType != null && jobType!.isNotEmpty) 'jobType': jobType,
      'page': page.toString(),
    };
  }

  SearchJobsParams copyWith({
    String? keyword,
    String? location,
    String? jobType,
    int? page,
  }) {
    return SearchJobsParams(
      keyword: keyword ?? this.keyword,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [keyword, location, jobType, page];
}