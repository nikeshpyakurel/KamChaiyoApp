import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_event.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_state.dart';
import 'package:kamchaiyo/features/application/domain/use_case/get_job_applicants_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_my_posted_jobs_usecase.dart';


class AllApplicantsViewModel extends Bloc<AllApplicantsEvent, AllApplicantsState> {
  final GetMyPostedJobsUseCase _getJobsUseCase;
  final GetJobApplicantsUseCase _getJobApplicantsUseCase;

  AllApplicantsViewModel({
    required GetMyPostedJobsUseCase getMyPostedJobsUseCase,
    required GetJobApplicantsUseCase getJobApplicantsUseCase,
  })  : _getJobsUseCase = getMyPostedJobsUseCase,
        _getJobApplicantsUseCase = getJobApplicantsUseCase,
        super(const AllApplicantsState()) {
    on<AllApplicantsDataFetched>(_onFetchAllData);
  }

  Future<void> _onFetchAllData(
      AllApplicantsDataFetched event, Emitter<AllApplicantsState> emit) async {
    emit(state.copyWith(status: AllApplicantsStatus.loading));

    final jobsResult = await _getJobsUseCase(NoParams());

    await jobsResult.fold(
      (failure) async {
        emit(state.copyWith(status: AllApplicantsStatus.failure, error: failure.message));
      },
      (jobs) async {
        final Map<String, int> applicantCounts = {};

        for (final job in jobs) {
          final applicantsResult = await _getJobApplicantsUseCase(job.id);
          applicantsResult.fold(
            (failure) {
              print("Could not fetch applicants for job ${job.id}: ${failure.message}");
              applicantCounts[job.id] = 0;
            },
            (applicants) {
              applicantCounts[job.id] = applicants.length;
            },
          );
        }

        emit(state.copyWith(
          status: AllApplicantsStatus.success,
          jobs: jobs,
          applicantCounts: applicantCounts,
        ));
      },
    );
  }
}