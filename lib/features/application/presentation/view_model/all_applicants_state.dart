import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

enum AllApplicantsStatus { initial, loading, success, failure }

class AllApplicantsState extends Equatable {
  final AllApplicantsStatus status;
  final List<JobEntity> jobs;
  final Map<String, int> applicantCounts;
  final String? error;

  const AllApplicantsState({
    this.status = AllApplicantsStatus.initial,
    this.jobs = const [],
    this.applicantCounts = const {},
    this.error,
  });

  AllApplicantsState copyWith({
    AllApplicantsStatus? status,
    List<JobEntity>? jobs,
    Map<String, int>? applicantCounts,
    String? error,
  }) {
    return AllApplicantsState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      applicantCounts: applicantCounts ?? this.applicantCounts,
      error: error, 
    );
  }

  @override
  List<Object?> get props => [status, jobs, applicantCounts, error];
}