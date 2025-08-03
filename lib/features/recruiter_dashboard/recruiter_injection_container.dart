import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/data/data_source/remote/recruiter_remote_data_source.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/data/repository/recruiter_repository_impl.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/repository/recruiter_repository.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/use_case/get_recruiter_stats_usecase.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_view_model.dart';

void initRecruiterDashboardInjection(GetIt sl) {
  sl.registerFactory(
    () => RecruiterDashboardViewModel(
      getRecruiterStatsUseCase: sl(),
      jobRepository: sl<JobRepository>(),
      applicationRepository: sl<ApplicationRepository>(),
    ),
  );  

  sl.registerLazySingleton(() => GetRecruiterStatsUseCase(sl()));

  sl.registerLazySingleton<RecruiterRepository>(
      () => RecruiterRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<RecruiterRemoteDataSource>(
      () => RecruiterRemoteDataSourceImpl(sl()));
}