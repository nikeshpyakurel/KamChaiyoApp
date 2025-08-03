import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/apply_for_job_usecase.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/search_jobs_usecase.dart';
import 'package:stream_transform/stream_transform.dart';

part 'job_search_event.dart';
part 'job_search_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class JobSearchBloc extends Bloc<JobSearchEvent, JobSearchState> {
  final SearchJobsUseCase _searchJobsUseCase;
  final ApplyForJobUseCase _applyForJobUseCase;

  JobSearchBloc({
    required SearchJobsUseCase searchJobsUseCase,
    required ApplyForJobUseCase applyForJobUseCase,
  })  : _searchJobsUseCase = searchJobsUseCase,
        _applyForJobUseCase = applyForJobUseCase,
        super(const JobSearchState()) {
    on<SearchTermChanged>(_onSearchTermChanged, transformer: debounce(_duration));
    on<SearchSubmitted>(_onSearchSubmitted);
    on<NextPageRequested>(_onNextPageRequested);
    on<JobApplied>(_onJobApplied);
  }

  Future<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<JobSearchState> emit,
  ) async {
    final newParams = state.searchParams.copyWith(keyword: event.searchTerm, page: 1);
    await _performSearch(newParams, emit, isNewSearch: true);
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<JobSearchState> emit,
  ) async {
    final newParams = state.searchParams.copyWith(page: 1);
    await _performSearch(newParams, emit, isNewSearch: true);
  }

  Future<void> _onNextPageRequested(
    NextPageRequested event,
    Emitter<JobSearchState> emit,
  ) async {
    if (state.hasReachedMax || state.status == JobSearchStatus.loading) return;
    final newParams = state.searchParams.copyWith(page: state.searchParams.page + 1);
    await _performSearch(newParams, emit);
  }
  
  Future<void> _onJobApplied(JobApplied event, Emitter<JobSearchState> emit) async {
    emit(state.copyWith(status: JobSearchStatus.applying, applyingJobId: event.jobId, clearMessages: true));
    
    final result = await _applyForJobUseCase(ApplyForJobParams(jobId: event.jobId));
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: JobSearchStatus.applyFailure,
        errorMessage: failure.message,
        applyingJobId: null,
      )),
      (_) {
        
        final updatedAppliedIds = List<String>.from(state.appliedJobIds)..add(event.jobId);

        emit(state.copyWith(
          status: JobSearchStatus.applySuccess,
          successMessage: 'Successfully applied!',
          applyingJobId: null,
          appliedJobIds: updatedAppliedIds, 
        ));
      }
    );
  }

  Future<void> _performSearch(
    SearchJobsParams params,
    Emitter<JobSearchState> emit, {
    bool isNewSearch = false,
  }) async {
    final initialStatus = state.jobs.isNotEmpty && !isNewSearch 
      ? state.status 
      : JobSearchStatus.loading;
      
    emit(state.copyWith(
        status: initialStatus,
        searchParams: params,
        clearMessages: true));

    final result = await _searchJobsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
          status: JobSearchStatus.failure, errorMessage: failure.message)),
      (response) {
        emit(state.copyWith(
          status: JobSearchStatus.success,
          jobs: isNewSearch ? response.jobs : (List.of(state.jobs)..addAll(response.jobs)),
          hasReachedMax: response.jobs.isEmpty || response.jobs.length < (params.toMap()['limit'] ?? 10),
        ));
      },
    );
  }
}