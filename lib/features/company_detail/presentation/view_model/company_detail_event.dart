part of 'company_detail_bloc.dart';

abstract class CompanyDetailEvent extends Equatable {
  const CompanyDetailEvent();
  @override
  List<Object> get props => [];
}

class CompanyDetailFetched extends CompanyDetailEvent {
  final String companyId;
  const CompanyDetailFetched(this.companyId);
  @override
  List<Object> get props => [companyId];
}

class CompanyJobsSearchQueryChanged extends CompanyDetailEvent {
  final String query;
  const CompanyJobsSearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}