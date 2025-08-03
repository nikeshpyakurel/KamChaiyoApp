import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/user_profile/data/data_source/remote/user_profile_remote_data_source.dart';
import 'package:kamchaiyo/features/user_profile/data/repository/user_profile_repository_impl.dart';
import 'package:kamchaiyo/features/user_profile/domain/repository/user_profile_repository.dart';
import 'package:kamchaiyo/features/user_profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_view_model.dart';

void initUserProfileInjection(GetIt sl) {
  sl.registerFactory(() => UserProfileViewModel(getUserProfileUseCase: sl()));

  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));

  sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<UserProfileRemoteDataSource>(
      () => UserProfileRemoteDataSourceImpl(sl()));
}