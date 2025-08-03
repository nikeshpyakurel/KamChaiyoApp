import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/my_applications/data/data_source/remote/my_applications_remote_data_source.dart';
import 'package:kamchaiyo/features/my_applications/data/repository/my_applications_repository_impl.dart';
import 'package:kamchaiyo/features/my_applications/domain/repository/my_applications_repository.dart';
import 'package:kamchaiyo/features/my_applications/domain/use_case/get_my_applications_usecase.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';

void initMyApplicationsInjection(GetIt sl) {
  sl.registerFactory(() => MyApplicationsBloc(getMyApplicationsUseCase: sl()));

  sl.registerLazySingleton(() => GetMyApplicationsUseCase(sl()));

  sl.registerLazySingleton<MyApplicationsRepository>(
      () => MyApplicationsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<MyApplicationsRemoteDataSource>(
      () => MyApplicationsRemoteDataSourceImpl(sl()));
}