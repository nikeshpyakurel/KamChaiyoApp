import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/core/network/hive_service.dart'; // Make sure this import exists
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:kamchaiyo/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:kamchaiyo/features/auth/data/repository/auth_repository_impl.dart';
import 'package:kamchaiyo/features/auth/domain/repository/auth_repository.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/login_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/logout_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/signup_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initAuthInjection(GetIt sl) {
  // BLoC, UseCases, Repository, and RemoteDataSource registrations are correct and unchanged
  sl.registerFactory(() => AuthViewModel(loginUseCase: sl(), signupUseCase: sl(), checkAuthStatusUseCase: sl(), logoutUseCase: sl(), updateProfileUseCase: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  // --- THE FIX IS HERE ---
  // We need to provide the dependencies that AuthLocalDataSource's constructor expects.
  // The constructor is AuthLocalDataSource(SharedPreferences, HiveService).
  // So, we ask GetIt (sl) for an instance of each.
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
      sl<SharedPreferences>(),
      sl<HiveService>(), // Provide the already registered HiveService instance.
    ),
  );
}