part of 'companies_bloc.dart';

abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();
  @override
  List<Object> get props => [];
}

class CompaniesFetched extends CompaniesEvent {}
class CompaniesSearchQueryChanged extends CompaniesEvent {
  final String query;
  const CompaniesSearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}