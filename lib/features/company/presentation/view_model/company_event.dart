
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
  @override
  List<Object> get props => [];
}

class MyCompaniesFetched extends CompanyEvent {}

class CompanyCreated extends CompanyEvent {
  final CreateCompanyParams params;
  const CompanyCreated(this.params);
  @override
  List<Object> get props => [params];
}

class CompanyUpdated extends CompanyEvent {
  final UpdateCompanyParams params;
  const CompanyUpdated(this.params);
  @override
  List<Object> get props => [params];
}

class CompanyDeleted extends CompanyEvent {
  final String companyId;
  const CompanyDeleted(this.companyId);
  @override
  List<Object> get props => [companyId];
}