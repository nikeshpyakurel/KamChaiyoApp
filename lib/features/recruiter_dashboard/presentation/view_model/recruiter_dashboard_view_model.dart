import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/use_case/get_recruiter_stats_usecase.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_event.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_state.dart';


class RecruiterDashboardViewModel
    extends Bloc<RecruiterDashboardEvent, RecruiterDashboardState> {
  final GetRecruiterStatsUseCase _getRecruiterStatsUseCase;
  final JobRepository _jobRepository;
  final ApplicationRepository _applicationRepository;

  RecruiterDashboardViewModel({
    required GetRecruiterStatsUseCase getRecruiterStatsUseCase,
    required JobRepository jobRepository,
    required ApplicationRepository applicationRepository,
  })  : _getRecruiterStatsUseCase = getRecruiterStatsUseCase,
        _jobRepository = jobRepository,
        _applicationRepository = applicationRepository,
        super(const RecruiterDashboardState()) {
    on<RecruiterStatsFetched>(_onRecruiterStatsFetched);
  }

  Future<void> _onRecruiterStatsFetched(
    RecruiterStatsFetched event,
    Emitter<RecruiterDashboardState> emit,
  ) async {
    emit(state.copyWith(status: RecruiterDashboardStatus.loading));

    final results = await Future.wait([
      _getRecruiterStatsUseCase(NoParams()),
      _jobRepository.getMyPostedJobs(),
    ]);

    final statsResult = results[0] as Either<Failure, RecruiterStatsEntity>;
    final jobsResult = results[1] as Either<Failure, List<JobEntity>>;

    if (statsResult.isLeft() || jobsResult.isLeft()) {
      emit(state.copyWith(
          status: RecruiterDashboardStatus.failure,
          error: 'Failed to load dashboard data.'));
      return;
    }

    final stats = (statsResult as Right).value;
    final allJobs = (jobsResult as Right).value as List<JobEntity>;
    
    allJobs.sort((a,b) => b.createdAt.compareTo(a.createdAt));

    List<ApplicationEntity> recentApplicants = [];
    if (allJobs.isNotEmpty) {
      final recentJobIds = allJobs.take(5).map((j) => j.id).toList();
      for (var jobId in recentJobIds) {
        final applicantsResult = await _applicationRepository.getJobApplicants(jobId);
        applicantsResult.fold(
          (l) => null,
          (applicants) => recentApplicants.addAll(applicants),
        );
      }
      recentApplicants.sort((a,b) => b.createdAt.compareTo(a.createdAt));
    }

    emit(state.copyWith(
      status: RecruiterDashboardStatus.success,
      stats: stats,
      recentJobs: allJobs, 
      recentApplicants: recentApplicants,
    ));
  }
}