part of 'job_detail_bloc.dart';

enum JobDetailStatus { initial, loading, success, failure }
enum JobApplyStatus { initial, loading, success, failure }

class JobDetailState extends Equatable {
  final JobDetailStatus status;
  final JobEntity? job;
  final String? error;

  final JobApplyStatus applyStatus;
  final String? applyError;

  const JobDetailState({
    this.status = JobDetailStatus.initial,
    this.job,
    this.error,
    this.applyStatus = JobApplyStatus.initial,
    this.applyError,
  });

  JobDetailState copyWith({
    JobDetailStatus? status,
    JobEntity? job,
    String? error,
    JobApplyStatus? applyStatus,
    String? applyError,
    bool clearMessages = false,
  }) {
    return JobDetailState(
      status: status ?? this.status,
      job: job ?? this.job,
      error: clearMessages ? null : error ?? this.error,
      applyStatus: applyStatus ?? this.applyStatus,
      applyError: clearMessages ? null : applyError ?? this.applyError,
    );
  }

  @override
  List<Object?> get props => [status, job, error, applyStatus, applyError];
}