part of 'companies_bloc.dart';

enum CompaniesStatus { initial, loading, success, failure }

class CompaniesState extends Equatable {
  final CompaniesStatus status;
  final List<CompanyEntity> allCompanies;
  final List<CompanyEntity> filteredCompanies;
  final String? error;

  const CompaniesState({
    this.status = CompaniesStatus.initial,
    this.allCompanies = const [],
    this.filteredCompanies = const [],
    this.error,
  });

  CompaniesState copyWith({
    CompaniesStatus? status,
    List<CompanyEntity>? allCompanies,
    List<CompanyEntity>? filteredCompanies,
    String? error,
  }) {
    return CompaniesState(
      status: status ?? this.status,
      allCompanies: allCompanies ?? this.allCompanies,
      filteredCompanies: filteredCompanies ?? this.filteredCompanies,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, allCompanies, filteredCompanies, error];
}