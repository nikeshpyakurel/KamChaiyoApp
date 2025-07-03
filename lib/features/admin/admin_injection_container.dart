import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/admin/data/data_source/remote/admin_remote_data_source.dart';
import 'package:kamchaiyo/features/admin/data/repository/admin_repository_impl.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_companies_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_users_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/toggle_company_verification_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/update_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';

void initAdminInjection(GetIt sl) {
  sl.registerFactory(
    () => AdminBloc(
      getAllUsersUseCase: sl(),
      getAllCompaniesUseCase: sl(),
      toggleCompanyVerificationUseCase: sl(),
      getChatbotSettingsUseCase: sl(),
      updateChatbotSettingsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetAllCompaniesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleCompanyVerificationUseCase(sl()));
  sl.registerLazySingleton(() => GetChatbotSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateChatbotSettingsUseCase(sl()));

  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(sl()));
}