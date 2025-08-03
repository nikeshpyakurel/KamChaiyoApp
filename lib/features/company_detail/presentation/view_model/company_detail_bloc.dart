import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/company_detail/domain/entity/company_detail_entity.dart';
import 'package:kamchaiyo/features/company_detail/domain/use_case/get_company_detail_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

part 'company_detail_event.dart';
part 'company_detail_state.dart';

class CompanyDetailBloc extends Bloc<CompanyDetailEvent, CompanyDetailState> {
  final GetCompanyDetailUseCase _getCompanyDetailUseCase;

  CompanyDetailBloc({required GetCompanyDetailUseCase getCompanyDetailUseCase})
      : _getCompanyDetailUseCase = getCompanyDetailUseCase,
        super(const CompanyDetailState()) {
    on<CompanyDetailFetched>(_onCompanyDetailFetched);
    on<CompanyJobsSearchQueryChanged>(_onCompanyJobsSearchQueryChanged);
  }

  Future<void> _onCompanyDetailFetched(
      CompanyDetailFetched event, Emitter<CompanyDetailState> emit) async {
    emit(state.copyWith(status: CompanyDetailStatus.loading));
    final result = await _getCompanyDetailUseCase(event.companyId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: CompanyDetailStatus.failure, error: failure.message)),
      (details) => emit(state.copyWith(
        status: CompanyDetailStatus.success,
        details: details,
        filteredJobs: details.jobs,
      )),
    );
  }

  void _onCompanyJobsSearchQueryChanged(
      CompanyJobsSearchQueryChanged event, Emitter<CompanyDetailState> emit) {
    if (state.details == null) return;

    if (event.query.isEmpty) {
      emit(state.copyWith(filteredJobs: state.details!.jobs));
    } else {
      final filtered = state.details!.jobs
          .where((job) =>
              job.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredJobs: filtered));
    }
  }
}