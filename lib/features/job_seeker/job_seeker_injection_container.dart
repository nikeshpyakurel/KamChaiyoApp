import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/job_seeker/data/data_sources/remote/job_seeker_remote_data_source.dart';
import 'package:kamchaiyo/features/job_seeker/data/repositories/job_seeker_repository_impl.dart';
import 'package:kamchaiyo/features/job_seeker/domain/repositories/job_seeker_repository.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/apply_for_job_usecase.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/search_jobs_usecase.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/view_models/job_search/job_search_bloc.dart';

void initJobSeekerInjection(GetIt sl) {
  sl.registerFactory(
    () => JobSearchBloc(
      searchJobsUseCase: sl(),
      applyForJobUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SearchJobsUseCase(sl()));
  sl.registerLazySingleton(() => ApplyForJobUseCase(sl()));

  sl.registerLazySingleton<JobSeekerRepository>(
    () => JobSeekerRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<JobSeekerRemoteDataSource>(
    () => JobSeekerRemoteDataSourceImpl(sl()),
  );
}