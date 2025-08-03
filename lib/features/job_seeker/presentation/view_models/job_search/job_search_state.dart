part of 'job_search_bloc.dart';

enum JobSearchStatus { initial, loading, success, failure, applying, applySuccess, applyFailure }

class JobSearchState extends Equatable {
  final JobSearchStatus status;
  final List<JobEntity> jobs;
  final SearchJobsParams searchParams;
  final bool hasReachedMax;
  final String? errorMessage;
  final String? successMessage;
  final String? applyingJobId;
  final List<String> appliedJobIds; 

  const JobSearchState({
    this.status = JobSearchStatus.initial,
    this.jobs = const [],
    this.searchParams = const SearchJobsParams(),
    this.hasReachedMax = false,
    this.errorMessage,
    this.successMessage,
    this.applyingJobId,
    this.appliedJobIds = const [], 
  });

  JobSearchState copyWith({
    JobSearchStatus? status,
    List<JobEntity>? jobs,
    SearchJobsParams? searchParams,
    bool? hasReachedMax,
    String? errorMessage,
    String? successMessage,
    String? applyingJobId,
    List<String>? appliedJobIds, 
    bool clearMessages = false,
    bool clearApplyingJobId = false,
  }) {
    return JobSearchState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      searchParams: searchParams ?? this.searchParams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: clearMessages ? null : errorMessage,
      successMessage: clearMessages ? null : successMessage,
      applyingJobId: clearApplyingJobId ? null : applyingJobId ?? this.applyingJobId,
      appliedJobIds: appliedJobIds ?? this.appliedJobIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        jobs,
        searchParams,
        hasReachedMax,
        errorMessage,
        successMessage,
        applyingJobId,
        appliedJobIds, 
      ];
}