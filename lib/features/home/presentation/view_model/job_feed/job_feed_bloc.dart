import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_job_recommendations_usecase.dart';

part 'job_feed_event.dart';
part 'job_feed_state.dart';

class JobFeedBloc extends Bloc<JobFeedEvent, JobFeedState> {
  final GetJobRecommendationsUseCase _getJobRecommendationsUseCase;

  JobFeedBloc({required GetJobRecommendationsUseCase getJobRecommendationsUseCase})
      : _getJobRecommendationsUseCase = getJobRecommendationsUseCase,
        super(const JobFeedState()) {
    on<JobFeedFetched>(_onJobFeedFetched);
  }

  Future<void> _onJobFeedFetched(
    JobFeedFetched event,
    Emitter<JobFeedState> emit,
  ) async {
    emit(state.copyWith(status: JobFeedStatus.loading));
    final result = await _getJobRecommendationsUseCase(NoParams());

    result.fold(
      (failure) => emit(
          state.copyWith(status: JobFeedStatus.failure, error: failure.message)),
      (jobs) => emit(state.copyWith(
          status: JobFeedStatus.success, recommendations: jobs)),
    );
  }
}