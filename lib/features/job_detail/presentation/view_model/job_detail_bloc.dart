import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/application/domain/use_case/apply_for_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_job_by_id_usecase.dart';

part 'job_detail_event.dart';
part 'job_detail_state.dart';

class JobDetailBloc extends Bloc<JobDetailEvent, JobDetailState> {
  final GetJobByIdUseCase _getJobByIdUseCase;
  final ApplyForJobUseCase _applyForJobUseCase;

  JobDetailBloc({
    required GetJobByIdUseCase getJobByIdUseCase,
    required ApplyForJobUseCase applyForJobUseCase,
  })  : _getJobByIdUseCase = getJobByIdUseCase,
        _applyForJobUseCase = applyForJobUseCase,
        super(const JobDetailState()) {
    on<JobDetailFetched>(_onJobDetailFetched);
    on<JobApplyButtonPressed>(_onJobApplyButtonPressed);
  }

  Future<void> _onJobDetailFetched(
    JobDetailFetched event,
    Emitter<JobDetailState> emit,
  ) async {
    emit(state.copyWith(status: JobDetailStatus.loading));
    final result = await _getJobByIdUseCase(event.jobId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: JobDetailStatus.failure, error: failure.message)),
      (job) =>
          emit(state.copyWith(status: JobDetailStatus.success, job: job)),
    );
  }

  Future<void> _onJobApplyButtonPressed(
    JobApplyButtonPressed event,
    Emitter<JobDetailState> emit,
  ) async {
    emit(state.copyWith(applyStatus: JobApplyStatus.loading, clearMessages: true));
    if (state.job == null) return;

    final result = await _applyForJobUseCase(state.job!.id);
    result.fold(
      (failure) => emit(state.copyWith(
          applyStatus: JobApplyStatus.failure, applyError: failure.message)),
      (_) => emit(state.copyWith(applyStatus: JobApplyStatus.success)),
    );
  }
}