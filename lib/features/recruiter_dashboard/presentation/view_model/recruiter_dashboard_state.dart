import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';

enum RecruiterDashboardStatus { initial, loading, success, failure }

class RecruiterDashboardState extends Equatable {
  final RecruiterDashboardStatus status;
  final RecruiterStatsEntity? stats;
  final List<JobEntity> recentJobs;
  final List<ApplicationEntity> recentApplicants;
  final String? error;

  const RecruiterDashboardState({
    this.status = RecruiterDashboardStatus.initial,
    this.stats,
    this.recentJobs = const [],
    this.recentApplicants = const [],
    this.error,
  });

  RecruiterDashboardState copyWith({
    RecruiterDashboardStatus? status,
    RecruiterStatsEntity? stats,
    List<JobEntity>? recentJobs,
    List<ApplicationEntity>? recentApplicants,
    String? error,
  }) {
    return RecruiterDashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      recentJobs: recentJobs ?? this.recentJobs,
      recentApplicants: recentApplicants ?? this.recentApplicants,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, stats, recentJobs, recentApplicants, error];
}