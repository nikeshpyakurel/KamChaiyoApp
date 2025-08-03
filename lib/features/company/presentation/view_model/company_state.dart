
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';

enum CompanyStatus { initial, loading, success, failure }

 class CompanyState extends Equatable {
  final CompanyStatus status;
  final List<CompanyEntity> myCompanies; 
  final String? error;
  final String? message;
  final String? deletingCompanyId;

  const CompanyState({
    this.status = CompanyStatus.initial,
    this.myCompanies = const [], 
    this.error,
    this.message,
    this.deletingCompanyId,
  });

  CompanyState copyWith({
    CompanyStatus? status,
    List<CompanyEntity>? myCompanies, 
    String? error,
    String? message,
    String? deletingCompanyId,
    bool clearError = false,
    bool clearMessage = false,
    bool clearDeletingId = false,
  }) {
    return CompanyState(
      status: status ?? this.status,
      myCompanies: myCompanies ?? this.myCompanies,
      error: clearError ? null : error,
      message: clearMessage ? null : message,
      deletingCompanyId:
          clearDeletingId ? null : deletingCompanyId ?? this.deletingCompanyId,
    );
  }

  @override
  List<Object?> get props =>
      [status, myCompanies, error, message, deletingCompanyId];
}