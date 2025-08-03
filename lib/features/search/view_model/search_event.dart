part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInitialJobsFetched extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String keyword;
  final String location;
  const SearchQueryChanged({required this.keyword, required this.location});

  @override
  List<Object> get props => [keyword, location];
}