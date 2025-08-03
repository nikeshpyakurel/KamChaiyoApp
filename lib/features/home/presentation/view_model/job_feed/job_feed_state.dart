part of 'job_feed_bloc.dart';

enum JobFeedStatus { initial, loading, success, failure }

class JobFeedState extends Equatable {
  final JobFeedStatus status;
  final List<JobEntity> recommendations;
  final String? error;

  const JobFeedState({
    this.status = JobFeedStatus.initial,
    this.recommendations = const [],
    this.error,
  });

  JobFeedState copyWith({
    JobFeedStatus? status,
    List<JobEntity>? recommendations,
    String? error,
    bool clearError = false,
  }) {
    return JobFeedState(
      status: status ?? this.status,
      recommendations: recommendations ?? this.recommendations,
      error: clearError ? null : error,
    );
  }

  @override
  List<Object?> get props => [status, recommendations, error];
}