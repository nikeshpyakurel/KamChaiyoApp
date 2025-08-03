import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/search_jobs_usecase.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchJobsUseCase _searchJobsUseCase;

  SearchBloc({required SearchJobsUseCase searchJobsUseCase})
      : _searchJobsUseCase = searchJobsUseCase,
        super(const SearchState()) {
    on<SearchInitialJobsFetched>(_onSearchInitialJobsFetched);
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: debounce(_duration));
  }

  Future<void> _onSearchInitialJobsFetched(
    SearchInitialJobsFetched event,
    Emitter<SearchState> emit,
  ) async {
    if (state.status == SearchStatus.initial) {
      emit(state.copyWith(status: SearchStatus.loading));
    }

    const params = SearchJobsParams(keyword: '', location: '');
    final result = await _searchJobsUseCase(params);

    result.fold(
      (failure) => emit(
          state.copyWith(status: SearchStatus.failure, error: failure.message)),
      (jobs) => emit(state.copyWith(status: SearchStatus.success, jobs: jobs)),
    );
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.keyword.isEmpty && event.location.isEmpty) {
      add(SearchInitialJobsFetched());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    final params = SearchJobsParams(keyword: event.keyword, location: event.location);
    final result = await _searchJobsUseCase(params);

    result.fold(
      (failure) => emit(
          state.copyWith(status: SearchStatus.failure, error: failure.message)),
      (jobs) => emit(state.copyWith(status: SearchStatus.success, jobs: jobs)),
    );
  }
}