import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:kamchaiyo/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
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
  sl.registerFactory(() => AuthViewModel(loginUseCase: sl(), signupUseCase: sl(), checkAuthStatusUseCase: sl(), logoutUseCase: sl(), updateProfileUseCase: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource(sl<SharedPreferences>(), sl<HiveInterface>().box<AuthHiveModel>(HiveTableConstant.userBox)));
}