
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

enum JobStatus { initial, loading, success, failure }

class JobState extends Equatable {
  final JobStatus status;
  final List<JobEntity> jobs;
  final List<CompanyEntity> myCompanies; 
  final String? error;
  final String? message;

  const JobState({
    this.status = JobStatus.initial,
    this.jobs = const [],
    this.myCompanies = const [],
    this.error,
    this.message,
  });

  JobState copyWith({
    JobStatus? status,
    List<JobEntity>? jobs,
    List<CompanyEntity>? myCompanies,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return JobState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      myCompanies: myCompanies ?? this.myCompanies,
      error: clearError ? null : error,
      message: clearMessage ? null : message,
    );
  }

  @override
  List<Object?> get props => [status, jobs, myCompanies, error, message];
}