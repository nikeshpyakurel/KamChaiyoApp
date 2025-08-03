part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<JobEntity> jobs;
  final String? error;

  const SearchState({
    this.status = SearchStatus.initial,
    this.jobs = const [],
    this.error,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<JobEntity>? jobs,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, jobs, error];
}