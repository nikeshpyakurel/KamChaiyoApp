import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/create_company_usecase.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/delete_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_my_posted_jobs_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_event.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_state.dart';


class JobViewModel extends Bloc<JobEvent, JobState> {
  final GetMyPostedJobsUseCase _getJobsUseCase;
  final GetMyCompaniesUseCase _getCompaniesUseCase;
  final PostJobUseCase _postJobUseCase;
  final UpdateJobUseCase _updateJobUseCase;
  final DeleteJobUseCase _deleteJobUseCase;

  JobViewModel({
    required GetMyPostedJobsUseCase getMyPostedJobsUseCase,
    required GetMyCompaniesUseCase getMyCompaniesUseCase,
    required PostJobUseCase postJobUseCase,
    required UpdateJobUseCase updateJobUseCase,
    required DeleteJobUseCase deleteJobUseCase,
  })  : _getJobsUseCase = getMyPostedJobsUseCase,
        _getCompaniesUseCase = getMyCompaniesUseCase,
        _postJobUseCase = postJobUseCase,
        _updateJobUseCase = updateJobUseCase,
        _deleteJobUseCase = deleteJobUseCase,
        super(const JobState()) {
    on<MyJobsAndCompaniesFetched>(_onFetchJobsAndCompanies);
    on<JobPosted>(_onJobPosted);
    on<JobUpdated>(_onJobUpdated);
    on<JobDeleted>(_onJobDeleted);
    on<ClearMessage>(_onClearMessage);
    on<ClearError>(_onClearError);
  }

  Future<void> _onFetchJobsAndCompanies(
      MyJobsAndCompaniesFetched event, Emitter<JobState> emit) async {
    emit(state.copyWith(status: JobStatus.loading, clearError: true, clearMessage: true));

    final results = await Future.wait([
      _getJobsUseCase(NoParams()),
      _getCompaniesUseCase(NoParams()),
    ]);

    final jobsResult = results[0] as Either<Failure, List<JobEntity>>;
    final companiesResult = results[1] as Either<Failure, List<CompanyEntity>>;

    jobsResult.fold(
      (failure) {
        emit(state.copyWith(status: JobStatus.failure, error: failure.message));
      },
      (jobs) {

        companiesResult.fold(
          (failure) {
             print("Warning: Failed to fetch companies, but jobs were fetched: ${failure.message}");
             emit(state.copyWith(
                status: JobStatus.success,
                jobs: jobs,
                myCompanies: [], 
             ));
          },
          (companies) {
            emit(state.copyWith(
              status: JobStatus.success,
              jobs: jobs,
              myCompanies: companies,
            ));
          },
        );
      },
    );
  }


  Future<void> _onJobPosted(JobPosted event, Emitter<JobState> emit) async {
    emit(state.copyWith(status: JobStatus.loading, clearMessage: true, clearError: true));
    final result = await _postJobUseCase(event.params);
    result.fold(
      (failure) => emit(state.copyWith(status: JobStatus.failure, error: failure.message)),
      (_) {
        add(MyJobsAndCompaniesFetched());
      },
    );
  }

  Future<void> _onJobUpdated(JobUpdated event, Emitter<JobState> emit) async {
    emit(state.copyWith(status: JobStatus.loading, clearMessage: true, clearError: true));
    final result = await _updateJobUseCase(event.params);
    result.fold(
      (failure) => emit(state.copyWith(status: JobStatus.failure, error: failure.message)),
      (_) {
        add(MyJobsAndCompaniesFetched());
      },
    );
  }

  Future<void> _onJobDeleted(JobDeleted event, Emitter<JobState> emit) async {
    emit(state.copyWith(status: JobStatus.loading, clearMessage: true, clearError: true));
    final result = await _deleteJobUseCase(event.jobId);
    result.fold(
      (failure) => emit(state.copyWith(status: JobStatus.failure, error: failure.message)),
      (_) {
        add(MyJobsAndCompaniesFetched());
      },
    );
  }

  void _onClearMessage(ClearMessage event, Emitter<JobState> emit) {
    emit(state.copyWith(clearMessage: true));
  }

  void _onClearError(ClearError event, Emitter<JobState> emit) {
    emit(state.copyWith(clearError: true));
  }
}