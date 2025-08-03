part of 'company_detail_bloc.dart';

enum CompanyDetailStatus { initial, loading, success, failure }

class CompanyDetailState extends Equatable {
  final CompanyDetailStatus status;
  final CompanyDetailEntity? details;
  final List<JobEntity> filteredJobs;
  final String? error;

  const CompanyDetailState({
    this.status = CompanyDetailStatus.initial,
    this.details,
    this.filteredJobs = const [],
    this.error,
  });

  CompanyDetailState copyWith({
    CompanyDetailStatus? status,
    CompanyDetailEntity? details,
    List<JobEntity>? filteredJobs,
    String? error,
  }) {
    return CompanyDetailState(
      status: status ?? this.status,
      details: details ?? this.details,
      filteredJobs: filteredJobs ?? this.filteredJobs,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, details, filteredJobs, error];
}