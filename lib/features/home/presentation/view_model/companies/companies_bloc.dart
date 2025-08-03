import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_public_companies_usecase.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final GetPublicCompaniesUseCase _getPublicCompaniesUseCase;

  CompaniesBloc({required GetPublicCompaniesUseCase getPublicCompaniesUseCase})
      : _getPublicCompaniesUseCase = getPublicCompaniesUseCase,
        super(const CompaniesState()) {
    on<CompaniesFetched>(_onCompaniesFetched);
    on<CompaniesSearchQueryChanged>(_onCompaniesSearchQueryChanged);
  }

  Future<void> _onCompaniesFetched(
      CompaniesFetched event, Emitter<CompaniesState> emit) async {
    emit(state.copyWith(status: CompaniesStatus.loading));
    final result = await _getPublicCompaniesUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: CompaniesStatus.failure, error: failure.message)),
      (companies) => emit(state.copyWith(
        status: CompaniesStatus.success,
        allCompanies: companies,
        filteredCompanies: companies,
      )),
    );
  }

  void _onCompaniesSearchQueryChanged(
      CompaniesSearchQueryChanged event, Emitter<CompaniesState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredCompanies: state.allCompanies));
    } else {
      final filtered = state.allCompanies
          .where((company) =>
              company.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredCompanies: filtered));
    }
  }
}