import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/my_interviews/data/data_source/remote/my_interviews_remote_data_source.dart';
import 'package:kamchaiyo/features/my_interviews/data/repository/my_interviews_repository_impl.dart';
import 'package:kamchaiyo/features/my_interviews/domain/repository/my_interviews_repository.dart';
import 'package:kamchaiyo/features/my_interviews/domain/use_case/get_my_interviews_usecase.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_view_model.dart';

void initMyInterviewsInjection(GetIt sl) {
  sl.registerFactory(() => MyInterviewsViewModel(getMyInterviewsUseCase: sl()));

  sl.registerLazySingleton(() => GetMyInterviewsUseCase(sl()));

  sl.registerLazySingleton<MyInterviewsRepository>(
      () => MyInterviewsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<MyInterviewsRemoteDataSource>(
      () => MyInterviewsRemoteDataSourceImpl(sl()));
}