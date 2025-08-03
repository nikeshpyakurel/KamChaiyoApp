import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/application/domain/use_case/get_job_applicants_usecase.dart';
import 'package:kamchaiyo/features/application/domain/use_case/update_application_status_usecase.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_event.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_state.dart';


class ApplicationViewModel extends Bloc<ApplicationEvent, ApplicationState> {
  final GetJobApplicantsUseCase _getJobApplicantsUseCase;
  final UpdateApplicationStatusUseCase _updateStatusUseCase;

  ApplicationViewModel({
    required GetJobApplicantsUseCase getJobApplicantsUseCase,
    required UpdateApplicationStatusUseCase updateApplicationStatusUseCase,
  })  : _getJobApplicantsUseCase = getJobApplicantsUseCase,
        _updateStatusUseCase = updateApplicationStatusUseCase,
        super(const ApplicationState()) {
    on<ApplicantsFetched>(_onApplicantsFetched);
    on<ApplicationStatusUpdated>(_onApplicationStatusUpdated);
  }

  Future<void> _onApplicantsFetched(
      ApplicantsFetched event, Emitter<ApplicationState> emit) async {
    emit(state.copyWith(status: ApplicationStatus.loading));
    final result = await _getJobApplicantsUseCase(event.jobId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ApplicationStatus.failure, error: failure.message)),
      (applicants) =>
          emit(state.copyWith(status: ApplicationStatus.success, applicants: applicants)),
    );
  }

  Future<void> _onApplicationStatusUpdated(
      ApplicationStatusUpdated event, Emitter<ApplicationState> emit) async {
    emit(state.copyWith(updatingApplicationId: event.applicationId));
    final params = UpdateApplicationStatusParams(
        applicationId: event.applicationId, status: event.status);
    final result = await _updateStatusUseCase(params);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ApplicationStatus.failure,
          error: failure.message,
          clearUpdatingId: true)),
      (updatedApplication) {
        final newList = state.applicants.map((app) {
          return app.id == updatedApplication.id ? updatedApplication : app;
        }).toList();
        emit(state.copyWith(
            status: ApplicationStatus.success,
            applicants: newList,
            clearUpdatingId: true));
      },
    );
  }
}