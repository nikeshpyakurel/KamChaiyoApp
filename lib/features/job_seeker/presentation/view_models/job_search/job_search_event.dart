part of 'job_search_bloc.dart';

abstract class JobSearchEvent extends Equatable {
  const JobSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchTermChanged extends JobSearchEvent {
  final String searchTerm;
  const SearchTermChanged(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class FiltersApplied extends JobSearchEvent {
  final SearchJobsParams filters;
  const FiltersApplied(this.filters);

  @override
  List<Object> get props => [filters];
}

class SearchSubmitted extends JobSearchEvent {}

class NextPageRequested extends JobSearchEvent {}

class JobApplied extends JobSearchEvent {
  final String jobId;
  const JobApplied(this.jobId);
  @override
  List<Object> get props => [jobId];
}