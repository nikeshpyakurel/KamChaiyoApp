import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/company/data/data_source/remote/company_remote_data_source.dart';
import 'package:kamchaiyo/features/company/data/repository/company_repository_impl.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';
import 'package:kamchaiyo/features/company/domain/use_case/create_company_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/delete_company_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_public_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_view_model.dart';

void initCompanyInjection(GetIt sl) {
  sl.registerFactory(
    () => CompanyViewModel(
      getMyCompaniesUseCase: sl(),
      createCompanyUseCase: sl(),
      updateCompanyUseCase: sl(), 
      deleteCompanyUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetMyCompaniesUseCase(sl()));
  sl.registerLazySingleton(() => CreateCompanyUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCompanyUseCase(sl())); 
  sl.registerLazySingleton(() => DeleteCompanyUseCase(sl()));
    sl.registerLazySingleton(() => GetPublicCompaniesUseCase(sl())); // New


  sl.registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<CompanyRemoteDataSource>(
      () => CompanyRemoteDataSourceImpl(sl()));
}