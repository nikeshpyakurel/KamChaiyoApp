import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/job/data/data_source/remote/job_remote_data_source.dart';
import 'package:kamchaiyo/features/job/data/repository/job_repository_impl.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';
import 'package:kamchaiyo/features/job/domain/use_case/delete_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_job_by_id_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_job_recommendations_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_my_posted_jobs_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/search_jobs_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_view_model.dart';

void initJobInjection(GetIt sl) {
  sl.registerFactory(() => JobViewModel(
        getMyPostedJobsUseCase: sl(),
        getMyCompaniesUseCase: sl(),
        postJobUseCase: sl(),
        updateJobUseCase: sl(),
        deleteJobUseCase: sl(),
      ));

  sl.registerLazySingleton(() => GetMyPostedJobsUseCase(sl()));
  sl.registerLazySingleton(() => PostJobUseCase(sl()));
  sl.registerLazySingleton(() => UpdateJobUseCase(sl()));
  sl.registerLazySingleton(() => DeleteJobUseCase(sl()));
  sl.registerLazySingleton(() => GetJobRecommendationsUseCase(sl())); // New
  sl.registerLazySingleton(() => SearchJobsUseCase(sl())); // New
    sl.registerLazySingleton(() => GetJobByIdUseCase(sl())); // New



  sl.registerLazySingleton<JobRepository>(
      () => JobRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<JobRemoteDataSource>(
      () => JobRemoteDataSourceImpl(sl()));
}