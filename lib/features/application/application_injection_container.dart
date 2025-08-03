import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/application/data/data_source/remote/application_remote_data_source.dart';
import 'package:kamchaiyo/features/application/data/repository/application_repository_impl.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';
import 'package:kamchaiyo/features/application/domain/use_case/apply_for_job_usecase.dart';
import 'package:kamchaiyo/features/application/domain/use_case/get_job_applicants_usecase.dart';
import 'package:kamchaiyo/features/application/domain/use_case/update_application_status_usecase.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_view_model.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_view_model.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_my_posted_jobs_usecase.dart';

void initApplicationInjection(GetIt sl) {
  sl.registerFactory(() => ApplicationViewModel(
        getJobApplicantsUseCase: sl(),
        updateApplicationStatusUseCase: sl(),
      ));
  
  sl.registerFactory(() => AllApplicantsViewModel(
        getJobApplicantsUseCase: sl(),
        getMyPostedJobsUseCase: sl<GetMyPostedJobsUseCase>(),
      ));

  sl.registerLazySingleton(() => GetJobApplicantsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateApplicationStatusUseCase(sl()));

  sl.registerLazySingleton<ApplicationRepository>(
      () => ApplicationRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<ApplicationRemoteDataSource>(
      () => ApplicationRemoteDataSourceImpl(sl()));

    sl.registerLazySingleton(() => ApplyForJobUseCase(sl())); 

}