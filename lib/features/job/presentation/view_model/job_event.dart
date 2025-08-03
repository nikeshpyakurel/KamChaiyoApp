
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();
  @override
  List<Object> get props => [];
}

class MyJobsAndCompaniesFetched extends JobEvent {}

class JobPosted extends JobEvent {
  final PostJobParams params;
  const JobPosted(this.params);
  @override
  List<Object> get props => [params];
}

class JobUpdated extends JobEvent {
  final UpdateJobParams params;
  const JobUpdated(this.params);
  @override
  List<Object> get props => [params];
}

class JobDeleted extends JobEvent {
  final String jobId;
  const JobDeleted(this.jobId);
  @override
  List<Object> get props => [jobId];
}

class ClearMessage extends JobEvent {}
class ClearError extends JobEvent {}