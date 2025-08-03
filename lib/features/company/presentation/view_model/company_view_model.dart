import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/create_company_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/delete_company_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_event.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_state.dart';


class CompanyViewModel extends Bloc<CompanyEvent, CompanyState> {
  final GetMyCompaniesUseCase _getMyCompaniesUseCase;
  final CreateCompanyUseCase _createCompanyUseCase;
  final UpdateCompanyUseCase _updateCompanyUseCase;
  final DeleteCompanyUseCase _deleteCompanyUseCase;

  CompanyViewModel({
    required GetMyCompaniesUseCase getMyCompaniesUseCase,
    required CreateCompanyUseCase createCompanyUseCase,
    required UpdateCompanyUseCase updateCompanyUseCase,
    required DeleteCompanyUseCase deleteCompanyUseCase,
  })  : _getMyCompaniesUseCase = getMyCompaniesUseCase,
        _createCompanyUseCase = createCompanyUseCase,
        _updateCompanyUseCase = updateCompanyUseCase,
        _deleteCompanyUseCase = deleteCompanyUseCase,
        super(const CompanyState()) {
    on<MyCompaniesFetched>(_onMyCompaniesFetched);
    on<CompanyCreated>(_onCompanyCreated);
    on<CompanyUpdated>(_onCompanyUpdated);
    on<CompanyDeleted>(_onCompanyDeleted);
  }

  Future<void> _onMyCompaniesFetched(
      MyCompaniesFetched event, Emitter<CompanyState> emit) async {
    emit(state.copyWith(status: CompanyStatus.loading, clearError: true, clearMessage: true));
    final result = await _getMyCompaniesUseCase(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CompanyStatus.failure, error: failure.message)),
      (companies) =>
          emit(state.copyWith(status: CompanyStatus.success, myCompanies: companies)),
    );
  }

  Future<void> _onCompanyCreated(
      CompanyCreated event, Emitter<CompanyState> emit) async {
    emit(state.copyWith(status: CompanyStatus.loading, clearError: true, clearMessage: true));
    final result = await _createCompanyUseCase(event.params);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CompanyStatus.failure, error: failure.message)),
      (company) {
        emit(state.copyWith(
            status: CompanyStatus.success,
            message: 'Company "${company.name}" created.'));
        add(MyCompaniesFetched());
      },
    );
  }

  Future<void> _onCompanyUpdated(
      CompanyUpdated event, Emitter<CompanyState> emit) async {
    emit(state.copyWith(status: CompanyStatus.loading, clearError: true, clearMessage: true));
    final result = await _updateCompanyUseCase(event.params);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CompanyStatus.failure, error: failure.message)),
      (company) {
        emit(state.copyWith(
            status: CompanyStatus.success,
            message: 'Company "${company.name}" updated.'));
        add(MyCompaniesFetched());
      },
    );
  }

  Future<void> _onCompanyDeleted(
      CompanyDeleted event, Emitter<CompanyState> emit) async {
    emit(state.copyWith(deletingCompanyId: event.companyId, clearError: true, clearMessage: true));
    final result = await _deleteCompanyUseCase(event.companyId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: CompanyStatus.failure,
          error: failure.message,
          clearDeletingId: true)),
      (_) {
        emit(state.copyWith(
            status: CompanyStatus.success,
            message: 'Company deleted successfully.',
            clearDeletingId: true));
        add(MyCompaniesFetched());
      },
    );
  }
}